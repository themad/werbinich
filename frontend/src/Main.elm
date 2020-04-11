module Main exposing (..)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import Http
import SweetPoll

-- MAIN
main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }

-- MODEL

type Player
    = Player { name : String
             , who  : String
             , done : Bool
             , count: Int
             }
    | NewPlayer { name : String }

type alias Gamestate =
    { turn : String
    , players : List Player
    }

type Model
    = NewGame  { gamestate : Gamestate, playername : String } -- Deciding what your neighbour should be
    | Game     { gamestate : Gamestate, playername : String } -- Running Game
    | PreSetup                        { playername : String } -- "Please enter your name"
    | GameFinished                                            -- End screen
    | CriticalFailure                                         -- Something went wrong. Maybe

init : () -> (Model, Cmd Msg)
init _ =
    ( exampleGame
    , Cmd.none
    )

exampleGame : Model
exampleGame = NewGame
              { gamestate = Gamestate "Ellen"
                            [ NewPlayer { name = "Ellen" }
                            , Player { name = "Andreas"
                                     , who = "Kurt Gödel"
                                     , done = False
                                     , count = 0
                                     }
                            , Player { name = "Computer"
                                     , who = "Count Count von Count"
                                     , done = False
                                     , count = 0
                                     }
                            , NewPlayer { name = "Matthias" }
                            , NewPlayer { name = "Stefan" }
                            ]
              , playername = "Computer"
              }

nextPlayer : String -> List Player -> Maybe Player
nextPlayer playername list =
    case list of
        [] -> Nothing
        x::xs ->
            let
                nextPlayer_ restlist firstItem =
                    case restlist of
                        p::ys -> case p of
                                    NewPlayer {name} -> if name == playername then
                                                         case ys of
                                                             y::zs -> Just y
                                                             [] -> Just firstItem
                                                     else nextPlayer_ ys firstItem
                                    Player {name} -> if name == playername then
                                                         case ys of
                                                             y::zs -> Just y
                                                             [] -> Just firstItem
                                                     else nextPlayer_ ys firstItem
                        [] -> Nothing
            in nextPlayer_ (x::xs) x
   
-- UPDATE
type Msg
    = EnteredName String
    | NextPlayer
    | SetGuess String

update : Msg -> Model -> (Model, Cmd Msg)
update msg model = (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model = Sub.none

-- VIEW
view : Model -> Html Msg
view model =
    case model of
        NewGame { gamestate, playername } ->
            div [] [ ul [ id "Leute" ] (List.map (viewPlayer playername) gamestate.players)
                   , div [] [h3 [] [text "Bitte gib einen Namen für "], maybeViewPlayer playername (nextPlayer playername gamestate.players)]
                   ]
        _ -> h1 [] [text "Hallo, Welt!"]

maybeViewPlayer : String -> Maybe Player -> Html Msg
maybeViewPlayer me p = case p of
                        Nothing -> text "niemand?"
                        Just player -> viewPlayer me player

viewPlayer : String -> Player -> Html Msg
viewPlayer playername p = case p of
                   NewPlayer {name} -> li [] [text name]
                   Player {name, who} ->
                       if name == playername then
                           li [] [text (name ++ " "), em [style "color" "red"] [text "???"]]
                       else
                           li [] [text (name ++ " "), em [] [text who]]
