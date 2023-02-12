module Main exposing (..)

import Browser
import Html exposing (Html, br, button, div, li, ol, text)
import Html.Attributes exposing (style)
import Html.Events exposing (onClick)


type alias CartLineItemId =
    String


type alias CartLineItem =
    { cartLineItemId : CartLineItemId, description : String }


type alias ShoppingCartModel =
    { cartId : String, cartLineItems : List CartLineItem }


type alias Model =
    { shoppingCart : ShoppingCartModel, selectedItems : List CartLineItemId }


main : Program () Model ShoppingCartMessage
main =
    Browser.sandbox { init = init, update = update, view = view }


init : Model
init =
    { shoppingCart = { cartId = "123", cartLineItems = [ { cartLineItemId = "1", description = "Laptop" } ] }, selectedItems = [] }


type ShoppingCartMessage
    = AddItem CartLineItem
    | RemoveItem CartLineItemId
    | TogglItemSelection CartLineItemId
    | ClearSelectedItems
    | ClearCart


update : ShoppingCartMessage -> Model -> Model
update msg ({ shoppingCart, selectedItems } as model) =
    case msg of
        AddItem newCartItem ->
            { model | shoppingCart = { shoppingCart | cartLineItems = newCartItem :: shoppingCart.cartLineItems } }

        RemoveItem itemId ->
            { model | shoppingCart = { shoppingCart | cartLineItems = List.filter (\item -> item.cartLineItemId /= itemId) shoppingCart.cartLineItems } }

        ClearCart ->
            { model | shoppingCart = { shoppingCart | cartLineItems = [] } }

        TogglItemSelection itemId ->
            { model
                | selectedItems =
                    if List.member itemId selectedItems then
                        List.filter (\id -> id /= itemId) selectedItems

                    else
                        itemId :: selectedItems
            }

        ClearSelectedItems ->
            { model | selectedItems = [] }


styledContainer : List (Html.Attribute msg) -> List (Html msg) -> Html msg
styledContainer htmlAttributes children =
    div
        ([ style "max-width" "400px"
         , style "display" "flex"
         , style "flex-direction" "column"
         , style "align-items" "center"
         , style "border" "1px solid black"
         , style "border-radius" "5px"
         , style "box-shadow" "0 0 10px 0 rgba(0,0,0,0.5)"
         , style "margin" "0 auto"
         ]
            ++ htmlAttributes
        )
        children


styledItem : CartLineItem -> List CartLineItemId -> Html ShoppingCartMessage
styledItem cartItem selectedItems =
    li
        [ style "text-decoration"
            (if List.member cartItem.cartLineItemId selectedItems then
                "line-through"

             else
                "none"
            )
        , style "cursor" "pointer"
        , onClick (TogglItemSelection cartItem.cartLineItemId)
        ]
        [ text ("Id: " ++ cartItem.cartLineItemId)
        , br [] []
        , text ("Description: " ++ cartItem.description)
        ]


view : Model -> Html ShoppingCartMessage
view model =
    div []
        [ styledContainer []
            [ text ("CartId: " ++ model.shoppingCart.cartId)
            , ol []
                (List.map
                    (\item ->
                        styledItem item model.selectedItems
                    )
                    model.shoppingCart.cartLineItems
                )
            ]
        , styledContainer [ style "margin-top" "20px" ]
            [ button [ onClick (AddItem { cartLineItemId = "2", description = "Pen" }) ] [ text "Add Item" ]
            , button [ onClick (RemoveItem "1") ] [ text "Remove Cart Item" ]
            , button [ onClick ClearCart ] [ text "Clear Cart" ]
            ]
        ]
