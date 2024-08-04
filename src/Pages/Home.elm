module Pages.Home exposing (Model, Msg, init, update, view)

import Browser.Navigation as Nav
import Elements exposing (externalLink, linkButton, panel, separator)
import Html exposing (Html, a, button, form, img, input, p, text)
import Html.Attributes exposing (class, disabled, href, placeholder, rel, src, target, type_, width)
import Html.Events exposing (onClick, onInput)
import Route


type alias Model =
    { locationInput : String
    }


type Msg
    = NoOp
    | LocationInputChanged String
    | CreditsButtonClicked


init : Model
init =
    { locationInput = "" }


update : Msg -> Model -> Nav.Key -> ( Model, Cmd Msg )
update msg model navKey =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        CreditsButtonClicked ->
            ( model, Route.pushUrl Route.Credits navKey )

        LocationInputChanged newLocationInput ->
            ( { model | locationInput = newLocationInput }, Cmd.none )


view : Model -> Html Msg
view model =
    let
        logoUrl =
            "ASSET_URL:../assets/img/logo.svg"

        isSubmitDisabled =
            model.locationInput
                |> String.trim
                |> String.isEmpty
    in
    panel "w-full max-w-md"
        [ img [ src logoUrl, width 187, class "m-auto" ] []
        , separator "mt-4 sm:mt-5"
        , form [ class "flex mt-4 sm:mt-5" ]
            [ input
                [ type_ "text"
                , class "input w-full"
                , placeholder "Where are you now?"
                , onInput LocationInputChanged
                ]
                []
            , button [ type_ "submit", class "ml-2 btn", disabled isSubmitDisabled ] [ text "Go" ]
            ]
        , separator "mt-4 sm:mt-5"
        , p [ class "mt-3 sm:mt-4 leading-6 font-light text-justify" ]
            [ text "Designed and developed by "
            , externalLink "https://www.linkedin.com/in/maxmaccari/" "Maxsuel Maccari"
            , text ". You can check all credits of used assets "
            , linkButton CreditsButtonClicked "here"
            , text "."
            ]
        ]
