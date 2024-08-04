module Elements exposing (..)

import Html exposing (Attribute, Html, a, button, div, h2, hr, text)
import Html.Attributes exposing (attribute, class, href, rel, style, target)
import Html.Events exposing (onClick)


baseView : Html msg -> Html msg
baseView child =
    let
        morningPhotoAsset =
            "ASSET_URL:../assets/img/morning_photo.jpg"

        morningPhotoUrl =
            "url(" ++ morningPhotoAsset ++ ")"
    in
    div
        [ class "min-w-full min-h-screen bg-cover flex items-center justify-center"
        , style "background-image" morningPhotoUrl
        ]
        [ child
        ]


panel : String -> List (Html msg) -> Html msg
panel classes children =
    div [ class <| "px-2 py-3 mx-4 sm:mx-0 sm:p-6 bg-secondary/80 text-primary flex flex-col " ++ classes ] children


panelTitle : String -> Html msg
panelTitle title =
    h2 [ class "text-3xl font-bold text-center text-primary" ] [ text title ]


separator : String -> Html msg
separator classes =
    hr [ class <| "border-0 border-t border-gray " ++ classes ] []


linkButton : msg -> String -> Html msg
linkButton msg textContent =
    button
        [ class "text-primary underline cursor-pointer hover:text-primary/80"
        , onClick msg
        ]
        [ text textContent ]


externalLink : String -> String -> Html msg
externalLink url textContent =
    a
        [ href url
        , class "text-primary underline cursor-pointer hover:text-primary/80"
        , target "_blank"
        , rel "noopener noreferrer nofollow"
        ]
        [ text textContent ]


dataTest : String -> Attribute msg
dataTest tag =
    attribute "data-test" tag
