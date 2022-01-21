module Retirement exposing (Result, Year, simulate)

import Model exposing (Model)


type alias Result =
    { retirementAge : Int
    , years : List Year
    }


type alias Year =
    { age : Int
    , endingBalance : Int
    , deposits : Int
    , withdrawals : Int
    , ssaIncome : Int
    , marketChange : Int
    }


simulate : Model -> Maybe Result
simulate model =
    simulateWithRetirementAge model model.currentAge


simulateWithRetirementAge : Model -> Int -> Maybe Result
simulateWithRetirementAge model retirementAge =
    let
        years =
            simulateYears model retirementAge (model.lifeExpectancy - model.currentAge + 1)
    in
    case List.head years of
        Just lastYear ->
            if lastYear.endingBalance >= 0 then
                Just
                    { retirementAge = retirementAge
                    , years = List.reverse years
                    }

            else
                simulateWithRetirementAge model (retirementAge + 1)

        Nothing ->
            Nothing


simulateYears : Model -> Int -> Int -> List Year
simulateYears model retirementAge numYears =
    let
        years =
            if numYears <= 1 then
                []

            else
                simulateYears model retirementAge (numYears - 1)
    in
    case List.head years of
        Just lastYear ->
            simulateYear model retirementAge (lastYear.age + 1) lastYear.endingBalance :: years

        Nothing ->
            [ simulateYear model retirementAge model.currentAge model.currentSavings ]


simulateYear model retirementAge age startingBalance =
    let
        yearDeposits =
            deposits model retirementAge age

        yearWithdrawals =
            withdrawals model retirementAge age

        yearSsaIncome =
            ssaIncome model age

        yearMarketChange =
            marketChange model startingBalance

        endingBalance =
            startingBalance
                + yearDeposits
                + yearSsaIncome
                + yearMarketChange
                - yearWithdrawals
    in
    { age = age
    , endingBalance = endingBalance
    , deposits = yearDeposits
    , withdrawals = yearWithdrawals
    , ssaIncome = yearSsaIncome
    , marketChange = yearMarketChange
    }


marketChange model startingBalance =
    toFloat startingBalance
        * model.annualYield
        |> round


deposits model retirementAge age =
    if age < retirementAge then
        model.annualSavings

    else
        0


ssaIncome model age =
    if age < model.ssaIncomeStartAge then
        0

    else
        model.ssaIncome


withdrawals model retirementAge age =
    if age < retirementAge then
        0

    else if age < model.ssaIncomeStartAge then
        adjusted model age model.retirementIncome

    else
        adjusted model age (model.retirementIncome - model.ssaIncome)


adjusted model age amount =
    let
        years =
            toFloat (age - model.currentAge)
    in
    toFloat amount
        * ((1.0 + model.inflation) ^ years)
        |> round
