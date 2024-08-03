module Types exposing (ApiCredentials, Forecast, ForecastResponse, Model, Msg(..), Weather)

import Date exposing (Date)
import Dict exposing (Dict)
import Http


type alias Model =
    { apiCredentials : ApiCredentials
    , forecasts : Dict String Forecast
    }


type Msg
    = NoOp
    | WeatherReceived (Result Http.Error Weather)
    | ForecastReceived (Result Http.Error ForecastResponse)


type alias ApiCredentials =
    { apiUrl : String
    , apiKey : String
    }


type alias Forecast =
    { cityName : String
    , currentWeather : Weather
    , weathers : List Weather
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


type alias ForecastResponse =
    { city : String
    , weathers : List Weather
    }
