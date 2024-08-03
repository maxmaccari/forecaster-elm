module Pages.NotFound exposing (..)

import Browser.Navigation as Nav
import Elements exposing (linkButton, panel, panelTitle, separator)
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Icons
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
    panel "w-full max-w-80" <|
        [ div [ class "flex items-center" ]
            [ Icons.warning "w-8 h-8 fill-primary "
            , panelTitle "Page Not Found"
            ]
        , separator "mt-4"
        , p [ class "mt-4 text-justify" ]
            [ text "The given url is not found. "
            , linkButton BackToHomeClicked "Click here"
            , text "to input a location to and get a forecast for your desired location."
            ]
        ]
