module Update exposing (update)

import Maybe
import Model exposing (Model)
import Msg exposing (..)
import String


update : Msg -> Model -> Model
update msg model =
    case msg of
        CurrentAge value ->
            { model | currentAge = updateInt value }

        LifeExpectancy value ->
            { model | lifeExpectancy = updateInt value }

        CurrentSavings value ->
            { model | currentSavings = updateInt value }

        AnnualSavings value ->
            { model | annualSavings = updateInt value }

        RetirementIncome value ->
            { model | retirementIncome = updateInt value }

        SSAIncome value ->
            { model | annualSocialSecurityIncome = updateInt value }

        SSAIncomeStart value ->
            { model | socialSecurityIncomeStartAge = updateInt value }

        Inflation value ->
            { model | inflation = updateFloat value }

        Yield value ->
            { model | annualYield = updateFloat value }


updateInt value =
    Maybe.withDefault 0 (String.toInt value)


updateFloat value =
    Maybe.withDefault 0 (String.toFloat value)
