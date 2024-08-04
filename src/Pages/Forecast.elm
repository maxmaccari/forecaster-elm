module Pages.Forecast exposing (..)

import Forecast exposing (Forecast)
import Html exposing (Html, div, text)


view : Forecast -> Html msg
view forecast =
    div [] [ text "forecast" ]
