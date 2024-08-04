module Pages.HomeTest exposing (..)

import Html.Attributes as Attributes
import Main exposing (Page(..))
import Pages.Home as HomePage
import Test exposing (..)
import Test.Html.Query as Query
import Test.Html.Selector as Selector exposing (disabled, tag)


dataTest : String -> Selector.Selector
dataTest tag =
    Selector.attribute (Attributes.attribute "data-test" tag)


suite : Test
suite =
    describe "Page.Home"
        [ test "Go button is disabled when input is empty"
            (\() ->
                let
                    model =
                        HomePage.init

                    view =
                        HomePage.view model
                in
                view
                    |> Query.fromHtml
                    |> Query.find [ tag "button", dataTest "go-button" ]
                    |> Query.has [ disabled True ]
            )
        , test "Go button is enabled when input is filled"
            (\() ->
                let
                    initialModel =
                        HomePage.init

                    model =
                        { initialModel | locationInput = "abc" }

                    view =
                        HomePage.view model
                in
                view
                    |> Query.fromHtml
                    |> Query.find [ tag "button", dataTest "go-button" ]
                    |> Query.has [ disabled False ]
            )
        ]
