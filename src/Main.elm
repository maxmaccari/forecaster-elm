module Main exposing (..)

import Api
import Browser
import Html exposing (Html, div, p, text)
import Html.Attributes exposing (class)
import Types exposing (ApiCredentials, Model, Msg(..))


type alias Flags =
    { apiUrl : String
    , apiKey : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    let
        model =
            { apiCredentials = ApiCredentials flags.apiUrl flags.apiKey
            , data = Nothing
            }
    in
    ( model, Api.getWeather model.apiCredentials "cuiabá" )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        DataReceived (Ok data) ->
            ( { model | data = Just data }, Cmd.none )

        DataReceived (Err _) ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [ class "w-screen h-screen flex items-center justify-center flex-col" ]
        [ div [ class "text-4xl ml-2 font-bold" ] [ text "Data:" ]
        , case model.data of
            Just data ->
                p [ class "mx-8 border p-4 bg-gray/10" ] [ text <| Debug.toString data ]

            Nothing ->
                text ""
        ]


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
