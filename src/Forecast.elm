module Forecast exposing (ApiCredentials)

import Date exposing (Date, fromPosix)
import Forecast.Location exposing (Location(..))
import Http
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
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


type alias ForecastResponse =
    { city : String
    , weathers : List Weather
    }


getWeather : ApiCredentials -> String -> (Result Http.Error Weather -> msg) -> Cmd msg
getWeather credentials location msg =
    let
        url =
            buildUrl credentials "weather" location
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg decodeWeather
        }


get5DaysForecast : ApiCredentials -> String -> (Result Http.Error ForecastResponse -> msg) -> Cmd msg
get5DaysForecast credentials location msg =
    let
        url =
            buildUrl credentials "forecast" location
    in
    Http.get
        { url = url
        , expect = Http.expectJson msg decodeForecast
        }


buildUrl : ApiCredentials -> String -> String -> String
buildUrl { apiUrl, apiKey } path location =
    apiUrl
        ++ "/"
        ++ path
        ++ "?q="
        ++ location
        ++ "&appid="
        ++ apiKey
        ++ "&units=metric"


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


decodeForecast : Decoder ForecastResponse
decodeForecast =
    D.succeed ForecastResponse
        |> D.requiredAt [ "city", "name" ] D.string
        |> D.required "list" (D.list decodeWeather)
