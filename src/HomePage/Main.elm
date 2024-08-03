module HomePage.Main exposing (Model, Msg, init, update, view)

import Html exposing (Html, div, text)


type alias Model =
    { locationInput : String
    }


type Msg
    = NoOp


init : Model
init =
    { locationInput = "" }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] [ text "Home" ]
