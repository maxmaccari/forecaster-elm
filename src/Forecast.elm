module Forecast exposing (ApiCredentials, Forecast, ForecastError, ForecastRemoteData, Model, Msg, askForForecast, getForecast, init, update)

import Date exposing (Date, fromPosix)
import Dict exposing (Dict)
import Forecast.Location as Location exposing (Location(..))
import Http exposing (Error(..))
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import RemoteData exposing (RemoteData(..))
import Time exposing (millisToPosix, utc)


type alias ApiCredentials =
    { apiUrl : String
    , apiKey : String
    }


type alias Forecast =
    { cityName : String
    , currentWeather : Weather
    , weathers : List Weather
    }


type alias ForecastRemoteData =
    RemoteData ForecastError Forecast


type alias Model =
    Dict String PartialForcast


type ForecastError
    = InvalidLocation
    | ParseError String
    | HttpError String


type PartialForcast
    = PartialForecast (RemoteData ForecastError Weather) (RemoteData ForecastError Next5DaysForecast)


type Msg
    = CurrentWeatherRetrieved Location (RemoteData ForecastError Weather)
    | Next5DaysForecestRetrieved Location (RemoteData ForecastError Next5DaysForecast)



-- TODO: Create new custom types for Temperature, Humidity, Pressure and Icon


type alias Weather =
    { date : Date
    , description : String
    , icon : String
    , temperature : Float
    , feelsLike : Float
    , min : Float
    , max : Float
    , humidity : Int
    , pressure : Int
    , cloudness : Int
    }


type alias Next5DaysForecast =
    { city : String
    , weathers : List Weather
    }


init : Model
init =
    Dict.empty


update : Msg -> Model -> Model
update msg model =
    case msg of
        CurrentWeatherRetrieved location newWeatherResult ->
            case Dict.get (Location.toString location) model of
                Just (PartialForecast _ current5Days) ->
                    let
                        newEntry =
                            PartialForecast newWeatherResult current5Days

                        newStore =
                            Dict.insert (Location.toString location) newEntry model
                    in
                    newStore

                Nothing ->
                    model

        Next5DaysForecestRetrieved location new5DaysResult ->
            case Dict.get (Location.toString location) model of
                Just (PartialForecast currentWeatherResult _) ->
                    let
                        newEntry =
                            PartialForecast currentWeatherResult new5DaysResult

                        newStore =
                            Dict.insert (Location.toString location) newEntry model
                    in
                    newStore

                Nothing ->
                    model


{-| Ask for a forecast from Store. If it's not found, ask from servers.
-}
askForForecast :
    ApiCredentials
    -> (Msg -> msg)
    -> Location
    -> Model
    -> ( ForecastRemoteData, Model, Cmd msg )
askForForecast credentials tagger location model =
    case getForecast location model of
        NotAsked ->
            let
                cmd =
                    Cmd.batch
                        [ getWeather credentials location
                        , get5DaysForecast credentials location
                        ]
                        |> Cmd.map tagger

                newEntry =
                    PartialForecast RemoteData.Loading RemoteData.Loading

                newForecastStore =
                    Dict.insert (Location.toString location) newEntry model
            in
            ( RemoteData.Loading, newForecastStore, cmd )

        otherStatus ->
            ( otherStatus, model, Cmd.none )


{-| Get a Forecast from the store by its Location.
-}
getForecast : Location -> Model -> ForecastRemoteData
getForecast location model =
    let
        buildForecast : Weather -> Next5DaysForecast -> Forecast
        buildForecast currentWeather next5DaysForecast =
            { cityName = next5DaysForecast.city
            , currentWeather = currentWeather
            , weathers = next5DaysForecast.weathers
            }

        partialForecastToForecast : PartialForcast -> ForecastRemoteData
        partialForecastToForecast (PartialForecast weather next5DaysForecast) =
            RemoteData.map2 buildForecast weather next5DaysForecast
    in
    Dict.get (Location.toString location) model
        |> Maybe.map partialForecastToForecast
        |> Maybe.withDefault RemoteData.NotAsked


getWeather : ApiCredentials -> Location -> Cmd Msg
getWeather credentials location =
    let
        url =
            buildUrl credentials "weather" location

        resultToMsg =
            Result.mapError parseHttpError >> RemoteData.fromResult >> CurrentWeatherRetrieved location
    in
    Http.get
        { url = url
        , expect =
            Http.expectJson resultToMsg decodeWeather
        }


get5DaysForecast : ApiCredentials -> Location -> Cmd Msg
get5DaysForecast credentials location =
    let
        url =
            buildUrl credentials "forecast" location

        resultToMsg =
            Result.mapError parseHttpError >> RemoteData.fromResult >> Next5DaysForecestRetrieved location
    in
    Http.get
        { url = url
        , expect = Http.expectJson resultToMsg decodeForecast
        }


buildUrl : ApiCredentials -> String -> Location -> String
buildUrl { apiUrl, apiKey } path location =
    let
        locationQuery =
            case location of
                Place place ->
                    "q=" ++ place

                Coords _ _ ->
                    Location.toString location
    in
    apiUrl
        ++ "/"
        ++ path
        ++ "?"
        ++ locationQuery
        ++ "&appid="
        ++ apiKey
        ++ "&units=metric"


parseHttpError : Http.Error -> ForecastError
parseHttpError httpError =
    case httpError of
        BadBody error ->
            ParseError error

        BadUrl error ->
            HttpError <| "Bad Url: " ++ error

        Timeout ->
            HttpError <| "Connection timed out"

        NetworkError ->
            HttpError <| "Network error"

        BadStatus 404 ->
            InvalidLocation

        BadStatus code ->
            HttpError <| "Server answered with status: " ++ String.fromInt code


decodeWeather : Decoder Weather
decodeWeather =
    let
        getHeadValue list =
            case List.head list of
                Just value ->
                    D.succeed value

                Nothing ->
                    D.fail "List empty."

        valueDecoder : String -> Decoder a -> Decoder a
        valueDecoder field decoder =
            D.succeed identity
                |> D.required field decoder

        atListHead field decoder =
            D.list (valueDecoder field decoder)
                |> D.andThen getHeadValue

        date =
            D.int
                |> D.map
                    (\posix ->
                        fromPosix utc (millisToPosix posix)
                    )
    in
    D.succeed Weather
        |> D.required "dt" date
        |> D.required "weather" (atListHead "description" D.string)
        |> D.required "weather" (atListHead "icon" D.string)
        |> D.requiredAt [ "main", "temp" ] D.float
        |> D.requiredAt [ "main", "feels_like" ] D.float
        |> D.requiredAt [ "main", "temp_min" ] D.float
        |> D.requiredAt [ "main", "temp_max" ] D.float
        |> D.requiredAt [ "main", "humidity" ] D.int
        |> D.requiredAt [ "main", "pressure" ] D.int
        |> D.requiredAt [ "clouds", "all" ] D.int


decodeForecast : Decoder Next5DaysForecast
decodeForecast =
    D.succeed Next5DaysForecast
        |> D.requiredAt [ "city", "name" ] D.string
        |> D.required "list" (D.list decodeWeather)
