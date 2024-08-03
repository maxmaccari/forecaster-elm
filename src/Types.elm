module Types exposing (ApiCredentials, Model, Msg(..))

import Http


type alias ApiCredentials =
    { apiUrl : String
    , apiKey : String
    }


type alias Model =
    { apiCredentials : ApiCredentials
    , data : Maybe String
    }


type Msg
    = NoOp
    | DataReceived (Result Http.Error String)
