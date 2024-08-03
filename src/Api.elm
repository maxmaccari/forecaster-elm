module Api exposing (getWeather)

import Http
import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as D
import Types exposing (ApiCredentials, Msg(..), Weather)


getWeather : ApiCredentials -> String -> Cmd Msg
getWeather credentials location =
    let
        url =
            buildUrl credentials "weather" location
    in
    Http.get
        { url = url
        , expect = Http.expectJson DataReceived decodeWeather
        }


buildUrl : ApiCredentials -> String -> String -> String
buildUrl { apiUrl, apiKey } path location =
    apiUrl ++ "/" ++ path ++ "?q=" ++ location ++ "&appid=" ++ apiKey


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
    in
    D.succeed Weather
        |> D.required "weather" (atListHead "description" D.string)
        |> D.required "weather" (atListHead "icon" D.string)
        |> D.requiredAt [ "main", "temp" ] D.float
        |> D.requiredAt [ "main", "feels_like" ] D.float
        |> D.requiredAt [ "main", "temp_min" ] D.float
        |> D.requiredAt [ "main", "temp_max" ] D.float
        |> D.requiredAt [ "main", "humidity" ] D.int
        |> D.requiredAt [ "main", "pressure" ] D.int
        |> D.requiredAt [ "clouds", "all" ] D.int
