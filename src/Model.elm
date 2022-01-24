port module Model exposing (Model, init, store)

import Json.Decode as D
import Json.Decode.Pipeline exposing (required)
import Json.Encode as E
import Msg exposing (Msg)


port setStorage : E.Value -> Cmd msg


type alias Model =
    { inflation : Float
    , annualYield : Float
    , lifeExpectancy : Int
    , currentAge : Int
    , retirementIncome : Int
    , currentSavings : Int
    , annualSavings : Int
    , ssaIncome : Int
    , ssaIncomeStartAge : Int
    }


init : E.Value -> ( Model, Cmd Msg )
init flags =
    case D.decodeValue decoder flags of
        Ok model ->
            ( model, Cmd.none )

        Err _ ->
            ( defaultModel, Cmd.none )


defaultModel =
    { inflation = 0.02
    , annualYield = 0.07
    , lifeExpectancy = 85
    , currentAge = 30
    , retirementIncome = 100000
    , currentSavings = 100000
    , annualSavings = 20000
    , ssaIncome = 40000
    , ssaIncomeStartAge = 67
    }


store : Model -> Cmd Msg
store model =
    setStorage (encode model)


encode : Model -> E.Value
encode model =
    E.object
        [ ( "inflation", E.float model.inflation )
        , ( "annualYield", E.float model.annualYield )
        , ( "lifeExpectancy", E.int model.lifeExpectancy )
        , ( "currentAge", E.int model.currentAge )
        , ( "retirementIncome", E.int model.retirementIncome )
        , ( "currentSavings", E.int model.currentSavings )
        , ( "annualSavings", E.int model.annualSavings )
        , ( "ssaIncome", E.int model.ssaIncome )
        , ( "ssaIncomeStartAge", E.int model.ssaIncomeStartAge )
        ]


decoder : D.Decoder Model
decoder =
    D.succeed Model
        |> required "inflation" D.float
        |> required "annualYield" D.float
        |> required "lifeExpectancy" D.int
        |> required "currentAge" D.int
        |> required "retirementIncome" D.int
        |> required "currentSavings" D.int
        |> required "annualSavings" D.int
        |> required "ssaIncome" D.int
        |> required "ssaIncomeStartAge" D.int
