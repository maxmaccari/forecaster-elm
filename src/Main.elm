module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)


main =
    Browser.sandbox { init = init, update = update, view = view }


type alias Model =
    Int


init : Model
init =
    0


type Msg
    = Increment
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        Increment ->
            model + 1

        Decrement ->
            model - 1


view : Model -> Html Msg
view model =
    div [ class "w-screen h-screen flex items-center justify-center" ]
        [ button [ onClick Decrement, class "btn" ] [ text "-" ]
        , div [ class "text-4xl ml-2 font-bold" ] [ text (String.fromInt model) ]
        , button [ onClick Increment, class "btn ml-2" ] [ text "+" ]
        ]
