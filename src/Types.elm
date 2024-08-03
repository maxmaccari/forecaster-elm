module Types exposing (ApiCredentials, Forecast, ForecastResponse, Msg(..), Weather)

import Browser exposing (UrlRequest)
import Date exposing (Date)
import HomePage.Main as HomePage
import Http
import Url exposing (Url)


type Msg
    = NoOp
    | UrlRequested UrlRequest
    | UrlChanged Url
    | WeatherReceived (Result Http.Error Weather)
    | ForecastReceived (Result Http.Error ForecastResponse)
    | HomePageMsg HomePage.Msg


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
