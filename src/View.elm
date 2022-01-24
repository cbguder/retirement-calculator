module View exposing (view)

import FormatNumber
import FormatNumber.Locales
import Html exposing (Html, div, form, h1, input, label, span, table, td, text, th, tr)
import Html.Attributes exposing (class, for, id, scope, step, type_, value)
import Html.Events exposing (onInput)
import Model exposing (Model)
import Msg exposing (..)
import Retirement


view : Model -> Html Msg
view model =
    let
        result =
            Retirement.simulate model
    in
    div [ class "container" ]
        [ h1 [ class "my-5" ] [ text "Retirement Calculator" ]
        , div [ class "row" ]
            [ div [ class "col-4" ] [ inputForm model ]
            , div [ class "col-8" ] [ retirementAge result, yearsTable result ]
            ]
        ]


inputForm : Model -> Html Msg
inputForm model =
    form []
        [ integerField { id = "current-age", label = "Current Age", value = model.currentAge, msg = CurrentAge }
        , integerField { id = "life-expectancy", label = "Life Expectancy", value = model.lifeExpectancy, msg = LifeExpectancy }
        , integerField { id = "current-savings", label = "Current Savings", value = model.currentSavings, msg = CurrentSavings }
        , integerField { id = "annual-savings", label = "Annual Savings", value = model.annualSavings, msg = AnnualSavings }
        , integerField { id = "retirement-income", label = "Retirement Income", value = model.retirementIncome, msg = RetirementIncome }
        , integerField { id = "ssa-income", label = "Annual SSA Income", value = model.ssaIncome, msg = SSAIncome }
        , integerField { id = "ssa-age", label = "SSA Income Starts at Age", value = model.ssaIncomeStartAge, msg = SSAIncomeStart }
        , floatField { id = "inflation", label = "Inflation", value = model.inflation, msg = Inflation }
        , floatField { id = "yield", label = "Yield", value = model.annualYield, msg = Yield }
        ]


integerField field =
    inputField
        { id = field.id
        , label = field.label
        , value = String.fromInt field.value
        , msg = field.msg
        , step = "1"
        }


floatField field =
    inputField
        { id = field.id
        , label = field.label
        , value = String.fromFloat field.value
        , msg = field.msg
        , step = "0.01"
        }


inputField field =
    div [ class "form-floating mb-3" ]
        [ input
            [ id field.id
            , type_ "number"
            , step field.step
            , class "form-control"
            , value field.value
            , onInput field.msg
            ]
            []
        , label [ for field.id ] [ text field.label ]
        ]


retirementAge result =
    let
        retirementAgeText =
            case result of
                Just aResult ->
                    String.fromInt aResult.retirementAge

                Nothing ->
                    "-"
    in
    div [ class "mb-3" ]
        [ span [ class "fw-bold" ] [ text "Estimated Retirement Age:" ]
        , text " "
        , text retirementAgeText
        ]


yearsTable result =
    let
        years =
            case result of
                Just aResult ->
                    aResult.years

                Nothing ->
                    []
    in
    table [ class "table" ]
        (tr []
            [ th [ scope "col" ] [ text "Age" ]
            , th [ scope "col", class "text-end" ] [ text "Deposits" ]
            , th [ scope "col", class "text-end" ] [ text "Market Change" ]
            , th [ scope "col", class "text-end" ] [ text "SSA Income" ]
            , th [ scope "col", class "text-end" ] [ text "Withdrawals" ]
            , th [ scope "col", class "text-end" ] [ text "End Balance" ]
            ]
            :: List.map yearRow years
        )


yearRow year =
    tr []
        [ td [] [ text (String.fromInt year.age) ]
        , td [ class "text-end" ] [ text (formatCurrency year.deposits) ]
        , td [ class "text-end" ] [ text (formatCurrency year.marketChange) ]
        , td [ class "text-end" ] [ text (formatCurrency year.ssaIncome) ]
        , td [ class "text-end" ] [ text (formatCurrency year.withdrawals) ]
        , td [ class "text-end" ] [ text (formatCurrency year.endingBalance) ]
        ]


formatCurrency amount =
    FormatNumber.format locale (toFloat amount)


locale =
    let
        base =
            FormatNumber.Locales.base
    in
    { base
        | thousandSeparator = ","
        , positivePrefix = "$"
        , negativePrefix = "$"
        , zeroPrefix = "$"
    }
