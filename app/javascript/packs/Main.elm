module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL

type alias Model =
  {
  }

-- INIT

init : (Model, Cmd Message)
init =
  (Model, Cmd.none)

-- VIEW

view : Model -> Html Message
view model =
  div []
    [ h1 [ class "text-center" ] [ text "Living Biobank" ]
    , div [ class "row" ]
      [ div [ class "col-sm-12" ]
      [ table [ class "table table-bordered table-hover" ]
        [ thead []
          [ tr []
            [ th []
              [ text "MRN" ]
            , th []
              [ text "Protocols Requesting" ]
            , th []
              [ text "Number of Samples Available" ]
            , th []
              [ text "Action" ]
            ]
          ]
        , tbody []
          [ tr []
            [ th [ scope "row" ]
              [ text "480856" ]
            , td []
              [ text "4103" ]
            , td []
              [ text "6" ]
            , td []
              [ div [] [ button [ class "btn btn-primary", attribute "data-toggle" "modal", attribute "data-target" "#release" ] [ text
              "Release" ] ]]
            ]
          ]
        , tbody []
          [ tr []
            [ th [ scope "row" ]
              [ text "442141" ]
            , td []
              [ text "4205" ]
            , td []
              [ text "4" ]
            , td []
              [ div [] [ button [ class "btn btn-primary" ] [ text
              "Release" ] ]]
            ]
          ]
        , tbody []
          [ tr []
            [ th [ scope "row" ]
              [ text "728001" ]
            , td []
              [ text "329" ]
            , td []
              [ text "2" ]
            , td []
              [ div [] [ button [ class "btn btn-primary" ] [ text
              "Release" ] ]]
            ]
          ]
        , tbody []
          [ tr []
            [ th [ scope "row" ]
              [ text "137420" ]
            , td []
              [ text "2105" ]
            , td []
              [ text "12" ]
            , td []
              [ div [] [ button [ class "btn btn-primary" ] [ text
              "Release" ] ]]
            ]
          ]
        ]
      ]
    ]
  ]

-- MESSAGE

type Message
  = None

-- UPDATE

update : Message -> Model -> (Model, Cmd Message)
update message model =
  (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Message
subscriptions model =
  Sub.none

-- MAIN

main : Program Never Model Message
main =
  Html.program
    {
      init = init,
      view = view,
      update = update,
      subscriptions = subscriptions
    }
