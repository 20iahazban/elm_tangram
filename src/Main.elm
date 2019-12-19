module Main exposing (main)

import Browser
import Browser.Events as E
import Cycle
import Html exposing (Html, br, div, span, text)
import Html.Attributes as Html_attr exposing (class)
import Html.Events exposing (onClick)
import Logo
import Time



-- MAIN


main =
    Browser.document
        { init = \() -> ( init, Cmd.none )
        , update = \msg model -> ( update msg model, Cmd.none )
        , subscriptions = subscriptions
        , view =
            \model ->
                { title = "Elm - A delightful language for reliable webapps"
                , body =
                    [ viewSplash model
                    ]
                }
        }



-- MODEL


type alias Model =
    { logo : Logo.Model
    , patterns : Cycle.Cycle Logo.Pattern
    , visibility : E.Visibility
    }


init : Model
init =
    { logo = Logo.start
    , visibility = E.Visible
    , patterns =
        Cycle.init
            Logo.heart
            [ Logo.camel
            , Logo.cat
            , Logo.bird
            , Logo.house
            , Logo.child
            , Logo.logo
            , Logo.letter_u
            ]
    }



-- UPDATE


type Msg
    = MouseClicked
    | VisibilityChanged E.Visibility
    | TimeDelta Float
    | TimePassed


update : Msg -> Model -> Model
update msg model =
    case msg of
        MouseClicked ->
            { model
                | patterns = Cycle.step model.patterns
                , logo = Logo.setPattern (Cycle.next model.patterns) model.logo
            }

        TimeDelta timeDelta ->
            { model
                | logo =
                    if Logo.isMoving model.logo then
                        Logo.step timeDelta model.logo

                    else
                        model.logo
            }

        VisibilityChanged visibility ->
            { model | visibility = visibility }

        TimePassed ->
            { model
                | patterns = Cycle.step model.patterns
                , logo = Logo.setPattern (Cycle.next model.patterns) model.logo
            }



-- VIEW SPLASH


viewSplash : Model -> Html Msg
viewSplash model =
    div
        [ class "splash"
        ]
        [ div
            [ class "tangram"
            ]
            [ Logo.view
                [ Html_attr.style "color" "white"
                , onClick MouseClicked
                ]
                model.logo
            ]
        ]



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ E.onVisibilityChange VisibilityChanged
        , case model.visibility of
            E.Hidden ->
                Sub.none

            E.Visible ->
                if Logo.isMoving model.logo then
                    E.onAnimationFrameDelta TimeDelta

                else
                    Time.every 4000 (\_ -> TimePassed)
        ]
