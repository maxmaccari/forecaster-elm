module Pages.Credits exposing (..)

import Browser.Navigation as Nav
import Elements exposing (externalLink, panel, panelTitle, separator)
import Html exposing (Html, button, p, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Route


type Msg
    = BackToHomeClicked


update : Msg -> Nav.Key -> Cmd Msg
update msg navKey =
    case msg of
        BackToHomeClicked ->
            Route.pushUrl Route.Home navKey


view : Html Msg
view =
    panel "max-w-md"
        [ panelTitle "Credits"
        , separator "mt-1"
        , p [ class "mt-4" ]
            [ text "Icons taken from "
            , externalLink "https://www.flaticon.com/" "www.flaticon.com"
            , text " made by: "
            , externalLink "https://www.flaticon.com/free-icon/wind_615486?term=wind&page=1&position=50" "Freeplk"
            , text ", "
            , externalLink "https://www.flaticon.com/free-icon/humidity_1163648?term=humidity&page=1&position=43" "Iconixar"
            , text ", "
            , externalLink "https://www.flaticon.com/free-icon/meter_1085657?term=pressure&page=1&position=13" "Goodware"
            , text " and "
            , externalLink "https://www.flaticon.com/packs/weather-forecast" "Linector"
            , text "."
            ]
        , p [ class "mt-3" ]
            [ text "Photos taken from "
            , externalLink "https://unsplash.com/" "unsplash.com"
            , text " by: "
            , externalLink "https://unsplash.com/photos/W5MhJ6cy1So" " @davidmarcu"
            , text ", "
            , externalLink "https://unsplash.com/photos/Lagi4DWvXpc" " @niklas_wersinger"
            , text ", "
            , externalLink "https://unsplash.com/photos/trvELSvNZoY" " @ivans_in_danger"
            , text ", "
            , externalLink "https://unsplash.com/photos/QdwR5aRGkbs" " @jfelise"
            , text ", "
            , externalLink "https://unsplash.com/photos/VWxiaKn-lVc" " @tadej"
            , text " and "
            , externalLink "https://unsplash.com/photos/TvCRYXwKhfQ" " @renancaraujo"
            , text "."
            ]
        , separator "mt-4"
        , button [ class "btn mt-4", onClick BackToHomeClicked ] [ text "Back" ]
        ]
