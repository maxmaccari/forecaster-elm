module Types exposing (ApiCredentials, Forecast, Model, Msg(..), Weather)

import Http


type alias ApiCredentials =
    { apiUrl : String
    , apiKey : String
    }



-- TODO: Create new custom types for Temperature, Humidity, Pressure and Icon


type alias Weather =
    { description : String
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
    { name : String
    , weather : Weather
    }


type alias Model =
    { apiCredentials : ApiCredentials
    , data : Maybe Weather
    }


type Msg
    = NoOp
    | DataReceived (Result Http.Error Weather)
