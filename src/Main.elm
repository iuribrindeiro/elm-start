module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text)
import Html.Events exposing (onClick)
import Html exposing (input)
import Html.Attributes exposing (value)
import Html.Attributes exposing (placeholder)

import Html.Events exposing (onInput)
import Html.Attributes exposing (style)


type alias Model = { name: String, count: Int }
main : Program () Model Msg
main =
  Browser.sandbox { init = init, update = update, view = view }


init : Model
init = { name = "", count = 0}

type Msg = Increment | Decrement | SetName String

update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      { model | count = model.count + 1 } 

    Decrement ->
      { model | count = model.count - 1 }

    SetName name -> { model | name = name }

view : Model -> Html Msg
view model =
  div [ 
        style "max-width" "400px"
      , style "display" "flex"
      , style "flex-direction" "column"
      , style "align-items" "center"
      , style "border" "1px solid black"
      , style "border-radius" "5px"
      , style "box-shadow" "0 0 10px 0 rgba(0,0,0,0.5)"
      ]
    [ text model.name  
    , button [ onClick Decrement ] [ text "-" ]
    , div [] [ text (String.fromInt model.count) ]
    , button [ onClick Increment ] [ text "+" ]
    , input [ placeholder "Enter your name", value model.name, onInput SetName ] []
    ]
