module Forecast.Location exposing (..)

import Regex


type Location
    = Place String
    | Coords Float Float


toString : Location -> String
toString location =
    case location of
        Place place ->
            place

        Coords lat lon ->
            "lat=" ++ String.fromFloat lat ++ "&lon=" ++ String.fromFloat lon


parse : String -> Location
parse str =
    let
        regex =
            "^lat=(-?\\d+\\.?\\d*)&?lon=(-?\\d+\\.?\\d*)$"
                |> Regex.fromString
                |> Maybe.withDefault Regex.never

        matches =
            Regex.find regex str
                |> List.map .submatches
                |> List.head
                |> Maybe.withDefault []
    in
    case matches of
        [ Just lat, Just lon ] ->
            Maybe.map2 Coords (String.toFloat lat) (String.toFloat lon)
                |> Maybe.withDefault (Place str)

        _ ->
            Place str
