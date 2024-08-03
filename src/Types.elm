module Types exposing (ApiCredentials, Forecast, Model, Msg(..), Weather)

import Date exposing (Date)
import Http


type alias ApiCredentials =
    { apiUrl : String
    , apiKey : String
    }



-- TODO: Create new custom types for Temperature, Humidity, Pressure and Icon


type alias Weather =
    { date : Date
    , description : String
    , icon : String
    , temperature : Float
    , feelsLike : Float
    , min : Float
    , max : Float
    , humidity : Int
    , pressure : Int
    , cloudness : Int
    }


type alias Forecast =
    { city : String
    , weathers : List Weather
    }


type alias Model =
    { apiCredentials : ApiCredentials
    , currentWeather : Maybe Weather
    , forecast : Maybe Forecast
    }


type Msg
    = NoOp
    | WeatherReceived (Result Http.Error Weather)
    | ForecastReceived (Result Http.Error Forecast)
