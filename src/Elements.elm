module Elements exposing (..)

import Html exposing (Html, div, hr)
import Html.Attributes exposing (class, style)


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


separator : String -> Html msg
separator classes =
    hr [ class <| "border-0 border-t border-gray " ++ classes ] []
