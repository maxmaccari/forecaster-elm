module Types exposing (ApiCredentials, Forecast, ForecastResponse, Location(..), Weather)

import Date exposing (Date)


type alias ApiCredentials =
    { apiUrl : String
    , apiKey : String
    }


type alias Forecast =
    { cityName : String
    , currentWeather : Weather
    , weathers : List Weather
    }


type Location
    = Place String



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
