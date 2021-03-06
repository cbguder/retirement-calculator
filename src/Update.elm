module Update exposing (update)

import Maybe
import Model exposing (Model, store)
import Msg exposing (..)
import String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        newModel =
            updateModel msg model
    in
    ( newModel, store newModel )


updateModel : Msg -> Model -> Model
updateModel msg model =
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
            { model | ssaIncome = updateInt value }

        SSAIncomeStart value ->
            { model | ssaIncomeStartAge = updateInt value }

        Inflation value ->
            { model | inflation = updateFloat value }

        Yield value ->
            { model | annualYield = updateFloat value }


updateInt value =
    Maybe.withDefault 0 (String.toInt value)


updateFloat value =
    Maybe.withDefault 0 (String.toFloat value)
