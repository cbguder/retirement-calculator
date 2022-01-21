module Main exposing (..)

import Browser
import Model exposing (init)
import Update exposing (update)
import View exposing (view)


main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
