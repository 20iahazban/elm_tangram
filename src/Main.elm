module Main exposing (main)

import Html exposing (Html, div)
import Html.Attributes exposing (class)
import Svg exposing (Svg, g, polygon, svg)
import Svg.Attributes exposing (fill, points, style, transform, viewBox)


main : Html msg
main =
    div
        [ class "splash"
        ]
        [ div
            [ class "tangram"
            ]
            [ svg
                [ viewBox "-600 -600 1200 1200", style "color:white;" ]
                [ g
                    [ transform "scale(1 -1)"
                    ]
                    [ viewShape start.tb1 triangleBig
                    , viewShape start.tb2 triangleBig
                    , viewShape start.tm triangleMedium
                    , viewShape start.sqr square
                    , viewShape start.par parallelogram
                    , viewShape start.ts1 triangleSmall
                    , viewShape start.ts2 triangleSmall
                    ]
                ]
            ]
        ]


start : Model
start =
    { tb1 = Static 0 -210 0
    , tb2 = Static -210 0 90
    , tm = Static 207 207 45
    , sqr = Static 150 0 0
    , par = Static -89 239 0
    , ts1 = Static 0 106 180
    , ts2 = Static 256 -150 270
    }


type alias Model =
    { tb1 : Shape
    , tb2 : Shape
    , tm : Shape
    , sqr : Shape
    , par : Shape
    , ts1 : Shape
    , ts2 : Shape
    }


type Shape
    = Static Float Float Float
    | Moving Float Float Float Float Float Float Float Float Float


viewShape : Shape -> String -> Svg msg
viewShape shape coordinates =
    case shape of
        Static x y a ->
            viewShapeHelp x y a coordinates

        Moving _ _ _ x y a _ _ _ ->
            viewShapeHelp x y a coordinates


viewShapeHelp : Float -> Float -> Float -> String -> Svg msg
viewShapeHelp x y a coordinates =
    polygon
        [ fill "currentColor"
        , points coordinates
        , transform <|
            "translate("
                ++ String.fromFloat x
                ++ " "
                ++ String.fromFloat y
                ++ ") rotate("
                ++ String.fromFloat -a
                ++ ")"
        ]
        []


triangleBig =
    "-280,-90 0,190 280,-90"


triangleMedium =
    "-198,-66 0,132 198,-66"


triangleSmall =
    "-130,-44 0,86  130,-44"


square =
    "-130,0 0,-130 130,0 0,130"


parallelogram =
    "-191,61 69,61 191,-61 -69,-61"
