module Main exposing (..)

import Api
import Browser
import Dict
import Html exposing (Html, div)
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
            , forecasts = Dict.empty
            }

        cmd =
            Cmd.batch
                [ Api.getWeather model.apiCredentials "cuiabá"
                , Api.get5DaysForecast model.apiCredentials "cuiabá"
                ]
    in
    ( model, cmd )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        WeatherReceived _ ->
            ( model, Cmd.none )

        ForecastReceived _ ->
            ( model, Cmd.none )


view : Model -> Html Msg
view model =
    div [] []


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }
