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
        [ button [ onClick Decrement, class "text-xl px-2 bg-indigo-600 hover:bg-indigo-400 text-indigo-50" ] [ text "-" ]
        , div [ class "text-4xl ml-2 font-bold" ] [ text (String.fromInt model) ]
        , button [ onClick Increment, class "text-xl ml-2 px-2 bg-indigo-600 hover:bg-indigo-400 text-indigo-50" ] [ text "+" ]
        ]
