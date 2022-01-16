module Retirement exposing (estimateRetirementAge)


estimateRetirementAge model =
    if model.lifeExpectancy > model.currentAge then
        estimateRetirementAgeStep model.currentAge model

    else
        0


estimateRetirementAgeStep retirementAge model =
    if estimateSavingsAtDeath retirementAge model > 0 then
        retirementAge

    else
        estimateRetirementAgeStep (retirementAge + 1) model


estimateSavingsAtDeath retirementAge model =
    if model.currentAge == model.lifeExpectancy then
        model.currentSavings

    else
        estimateSavingsAtDeath retirementAge
            { model
                | currentAge = model.currentAge + 1
                , currentSavings = updateSavings retirementAge model
                , retirementIncome = updateRetirementIncome model
            }


updateSavings retirementAge model =
    model.currentSavings
        + yield model
        + savings retirementAge model
        + ssaIncome model
        - withdrawals retirementAge model


updateRetirementIncome model =
    toFloat model.retirementIncome
        * (1.0 + model.inflation)
        |> round


yield model =
    toFloat model.currentSavings
        * model.annualYield
        |> round


savings retirementAge model =
    if model.currentAge < retirementAge then
        model.annualSavings

    else
        0


ssaIncome model =
    if model.currentAge < model.socialSecurityIncomeStartAge then
        0

    else
        model.annualSocialSecurityIncome


withdrawals retirementAge model =
    if model.currentAge < retirementAge then
        0

    else
        model.retirementIncome
