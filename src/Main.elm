module Main exposing (..)

import Browser exposing (Document, UrlRequest)
import Browser.Navigation as Nav
import Elements exposing (baseView)
import Forecast exposing (ApiCredentials, Forecast, ForecastRemoteData, askForForecast, getForecast)
import Forecast.Location exposing (Location)
import Html exposing (Html, div, text)
import Pages.Credits as CreditsPage
import Pages.Forecast as ForecastPage
import Pages.Home as HomePage
import Pages.NotFound as NotFoundPage
import RemoteData
import Route exposing (Route)
import Url exposing (Url)


type alias Flags =
    { apiUrl : String
    , apiKey : String
    }


type Page
    = HomePage HomePage.Model
    | CreditsPage
    | NotFoundPage
    | ForecastPage Location Forecast.ForecastRemoteData


type alias Model =
    { apiCredentials : ApiCredentials
    , route : Route
    , page : Page
    , navKey : Nav.Key
    , forecastModel : Forecast.Model
    }


type Msg
    = NoOp
    | UrlRequested UrlRequest
    | UrlChanged Url
    | HomePageMsg HomePage.Msg
    | NotFoundPageMsg NotFoundPage.Msg
    | CreditsPageMsg CreditsPage.Msg
    | ForecastUpdated Forecast.Msg


init : Flags -> Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url navKey =
    let
        model =
            { apiCredentials = ApiCredentials flags.apiUrl flags.apiKey
            , route = Route.parseUrl url
            , page = NotFoundPage
            , navKey = navKey
            , forecastModel = Forecast.init
            }
    in
    ( model, Cmd.none )
        |> initCurrentPage


initCurrentPage : ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
initCurrentPage ( model, cmd ) =
    let
        ( currentPage, newModel, mappedPageCmds ) =
            case model.route of
                Route.NotFound ->
                    ( NotFoundPage, model, Cmd.none )

                Route.Home ->
                    let
                        initialModel =
                            HomePage.init
                    in
                    ( HomePage initialModel, model, Cmd.none )

                Route.Credits ->
                    ( CreditsPage, model, Cmd.none )

                Route.Forecast location ->
                    let
                        ( forecast, forecastModel, mappedCmd ) =
                            askForForecast model.apiCredentials ForecastUpdated location model.forecastModel
                    in
                    ( ForecastPage location forecast, { model | forecastModel = forecastModel }, mappedCmd )
    in
    ( { newModel | page = currentPage }, Cmd.batch [ cmd, mappedPageCmds ] )


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

        NotFoundPageMsg notFoundMgs ->
            case model.page of
                NotFoundPage ->
                    let
                        cmd =
                            NotFoundPage.update notFoundMgs model.navKey
                    in
                    ( model, Cmd.map NotFoundPageMsg cmd )

                _ ->
                    ( model, Cmd.none )

        CreditsPageMsg creditsMsg ->
            case model.page of
                CreditsPage ->
                    let
                        cmd =
                            CreditsPage.update creditsMsg model.navKey
                    in
                    ( model, Cmd.map CreditsPageMsg cmd )

                _ ->
                    ( model, Cmd.none )

        ForecastUpdated forecastMsg ->
            let
                newForecastModel =
                    Forecast.update forecastMsg model.forecastModel

                page =
                    case model.page of
                        ForecastPage location _ ->
                            ForecastPage location (getForecast location newForecastModel)

                        _ ->
                            model.page
            in
            ( { model | forecastModel = newForecastModel, page = page }, Cmd.none )


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
                |> Html.map CreditsPageMsg

        NotFoundPage ->
            NotFoundPage.view
                |> Html.map NotFoundPageMsg

        ForecastPage _ forecastRemoteData ->
            remoteView ForecastPage.view forecastRemoteData


remoteView : (Forecast -> Html Msg) -> ForecastRemoteData -> Html Msg
remoteView succeedView remoteData =
    case remoteData of
        RemoteData.NotAsked ->
            div [] [ text "Not Asked" ]

        RemoteData.Loading ->
            div [] [ text "Loading..." ]

        RemoteData.Success forecast ->
            succeedView forecast

        RemoteData.Failure error ->
            div [] [ text <| "Error..." ++ Debug.toString error ]


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
