module Api exposing (getWeather)

import Http
import Types exposing (ApiCredentials, Msg(..))


getWeather : ApiCredentials -> String -> Cmd Msg
getWeather credentials location =
    let
        url =
            buildUrl credentials "weather" location
    in
    Http.get
        { url = url
        , expect = Http.expectString DataReceived
        }


buildUrl : ApiCredentials -> String -> String -> String
buildUrl { apiUrl, apiKey } path location =
    apiUrl ++ "/" ++ path ++ "?q=" ++ location ++ "&appid=" ++ apiKey
