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
    [ h1 [ class "text-center" ] [ text "SPARC Bio Bank" ]
    , div [ class "row" ]
      [ div [ class "col-sm-12" ]
      [ table [ class "table table-bordered table-hover" ]
        [ thead []
          [ tr []
            [ th []
              [ text "MRN" ]
            , th []
              [ text "Protocols Requests" ]
            , th []
              [ text "Number of Samples available" ]
            , th []
              [ text "Action" ]
            ]
          ]
        , tbody []
          [ tr []
            [ th [ scope "row" ]
              [ text "1" ]
            , td []
              [ text "Mark" ]
            , td []
              [ text "Otto" ]
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
