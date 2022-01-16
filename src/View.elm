module View exposing (view)

import Html exposing (Html, div, form, input, label, p, text)
import Html.Attributes exposing (class, value)
import Html.Events exposing (onInput)
import Model exposing (Model)
import Msg exposing (..)
import Retirement


view : Model -> Html Msg
view model =
    div []
        [ inputForm model
        , result model
        ]


inputForm : Model -> Html Msg
inputForm model =
    form []
        [ integerField { label = "Current Age", value = model.currentAge, msg = CurrentAge }
        , integerField { label = "Life Expectancy", value = model.lifeExpectancy, msg = LifeExpectancy }
        , integerField { label = "Current Savings", value = model.currentSavings, msg = CurrentSavings }
        , integerField { label = "Annual Savings", value = model.annualSavings, msg = AnnualSavings }
        , integerField { label = "Retirement Income", value = model.retirementIncome, msg = RetirementIncome }
        , integerField { label = "Annual SSA Income", value = model.annualSocialSecurityIncome, msg = SSAIncome }
        , integerField { label = "SSA Income Starts at Age", value = model.socialSecurityIncomeStartAge, msg = SSAIncomeStart }
        , floatField { label = "Inflation", value = model.inflation, msg = Inflation }
        , floatField { label = "Yield", value = model.annualYield, msg = Yield }
        ]


integerField field =
    inputField { label = field.label, value = String.fromInt field.value, msg = field.msg }


floatField field =
    inputField { label = field.label, value = String.fromFloat field.value, msg = field.msg }


inputField field =
    div [ class "row mb-3" ]
        [ label [ class "col-sm-2 form-label" ] [ text field.label ]
        , div [ class "col-sm-10" ] [ input [ class "form-control", value field.value, onInput field.msg ] [] ]
        ]


result model =
    p []
        [ text "Estimated Retirement Age: "
        , text (String.fromInt (Retirement.estimateRetirementAge model))
        ]
