module Forecast.ForecastTest exposing (..)

import Expect
import Forecast.Location as Location exposing (Location(..))
import Test exposing (..)


suite : Test
suite =
    describe "Forecast.Location"
        [ describe "toString"
            [ test "`Place \"location\"` is converted to \"location\"" <|
                \() ->
                    Place "location"
                        |> Location.toString
                        |> Expect.equal "location"
            , test "`Coords 123.123 -123.123` is converted to \"lat=123.123&lon=-123.123\"" <|
                \() ->
                    Coords 123.123 -123.123
                        |> Location.toString
                        |> Expect.equal "lat=123.123&lon=-123.123"
            ]
        , describe "parse"
            [ test "\"location\" is parsed to `Place \"location\"" <|
                \() ->
                    "location"
                        |> Location.parse
                        |> Expect.equal (Place "location")
            , test "\"lat=123.123&lon=-123.123\" is parsed to `Coords 123.123 -123.123`" <|
                \() ->
                    "lat=123.123&lon=-123.123"
                        |> Location.parse
                        |> Expect.equal (Coords 123.123 -123.123)
            ]
        ]
