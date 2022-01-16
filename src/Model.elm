module Model exposing (..)


type alias Model =
    { inflation : Float
    , annualYield : Float
    , lifeExpectancy : Int
    , currentAge : Int
    , retirementIncome : Int
    , currentSavings : Int
    , annualSavings : Int
    , annualSocialSecurityIncome : Int
    , socialSecurityIncomeStartAge : Int
    }


init : Model
init =
    { inflation = 0.02
    , annualYield = 0.07
    , lifeExpectancy = 85
    , currentAge = 30
    , retirementIncome = 120000
    , currentSavings = 100000
    , annualSavings = 20000
    , annualSocialSecurityIncome = 40000
    , socialSecurityIncomeStartAge = 67
    }
