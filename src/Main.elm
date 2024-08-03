module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


type alias Flags =
    { apiUrl : String
    , apiKey : String
    }


type alias Model =
    { apiUrl : String
    , apiKey : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { apiUrl = flags.apiUrl
            , apiKey = flags.apiKey
            }
    in
    ( model, Cmd.none )


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "w-screen h-screen flex items-center justify-center" ]
        [ div [ class "text-4xl ml-2 font-bold" ] [ text "Hello" ]
        ]


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
