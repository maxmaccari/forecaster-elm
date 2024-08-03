module Main exposing (..)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Dict exposing (Dict)
import Elements exposing (baseView, panel, separator)
import Html exposing (Html, div, h1, p, text)
import Html.Attributes exposing (class)
import Icons
import Pages.Credits as CreditsPage
import Pages.Home as HomePage
import Route exposing (Route)
import Types exposing (ApiCredentials, Forecast, Msg(..))
import Url exposing (Url)


type alias Flags =
    { apiUrl : String
    , apiKey : String
    }


type Page
    = HomePage HomePage.Model
    | CreditsPage
    | NotFoundPage


type alias Model =
    { apiCredentials : ApiCredentials
    , forecasts : Dict String Forecast
    , route : Route
    , page : Page
    , navKey : Nav.Key
    }


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { apiCredentials = ApiCredentials flags.apiUrl flags.apiKey
            , forecasts = Dict.empty
            , route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            }
    in
    ( model, Cmd.none )
        |> initCurrentPage


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, cmd ) =
    let
        ( currentPage, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, Cmd.none )

                Route.Home ->
                    let
                        initialModel =
                            HomePage.init
                    in
                    ( HomePage initialModel, Cmd.none )

                Route.Credits ->
                    ( CreditsPage, Cmd.none )
    in
    ( { model | page = currentPage }, Cmd.batch [ cmd, mappedPageCmds ] )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        UrlRequested urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.navKey (Url.toString url) )

                Browser.External url ->
                    ( model, Nav.load url )

        UrlChanged url ->
            let
                newRoute =
                    Route.parseUrl url
            in
            ( { model | route = newRoute }, Cmd.none )
                |> initCurrentPage

        HomePageMsg homeMsg ->
            case model.page of
                HomePage homeModel ->
                    let
                        ( newHomeModel, cmd ) =
                            HomePage.update homeMsg homeModel model.navKey
                    in
                    ( { model | page = HomePage newHomeModel }, Cmd.map HomePageMsg cmd )

                _ ->
                    ( model, Cmd.none )

        WeatherReceived _ ->
            ( model, Cmd.none )

        ForecastReceived _ ->
            ( model, Cmd.none )


view : Model -> Document Msg
view model =
    { title = "Forecaster"
    , body = [ baseView <| currentView model ]
    }


currentView : Model -> Html Msg
currentView model =
    case model.page of
        HomePage homePageModel ->
            HomePage.view homePageModel
                |> Html.map HomePageMsg

        CreditsPage ->
            CreditsPage.view

        NotFoundPage ->
            notFoundView


notFoundView : Html Msg
notFoundView =
    panel "w-full max-w-80" <|
        [ div [ class "flex items-center" ]
            [ Icons.warning "w-8 h-8 fill-primary "
            , h1 [ class "text-2xl bg-bold ml-2" ] [ text "Page Not Found" ]
            ]
        , separator ""
        , p [ class "mt-2" ] [ text "The given url is not found." ]
        ]


main : Program Flags Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        , onUrlRequest = UrlRequested
        , onUrlChange = UrlChanged
        }
