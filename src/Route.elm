module Route exposing (..)

import Browser.Navigation as Nav
import Types exposing (Location(..))
import Url exposing (Url)
import Url.Parser exposing (..)


type Route
    = NotFound
    | Home
    | Credits
    | Forecast Location


pushUrl : Route -> Nav.Key -> Cmd msg
pushUrl route navKey =
    routeToString route
        |> Nav.pushUrl navKey


routeToString : Route -> String
routeToString route =
    case route of
        NotFound ->
            "/not-found"

        Home ->
            "/"

        Credits ->
            "/credits"

        Forecast (Place location) ->
            "/forecast/" ++ location


parseUrl : Url -> Route
parseUrl url =
    case parse matchRoute url of
        Just route ->
            route

        Nothing ->
            NotFound


matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map Home top
        , map Credits (s "credits")
        , map Forecast (s "forecast" </> locationParser)
        ]


locationParser : Parser (Location -> a) a
locationParser =
    custom "LOCATION" <|
        \location -> Just (Place location)
