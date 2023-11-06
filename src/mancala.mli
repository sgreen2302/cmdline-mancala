(** Representation of the Mancala gameplay.

    This module represents the logic necessary to implement a fully functional
    gameplay of Mancala. It handles the updating of the game board, including
    pits and stores, as well as updating the game turn to allow for the next
    player to go. Logic is also included here to enforce correct input from the
    player. *)

val update_pit : (int * int) list -> int -> (int * int) list
(** [update_pit pit curr] increments the count of the current pit [curr] by one
    in the board pits [pit]. **)

val set_zero_pit : (int * int) list -> int -> (int * int) list
(** [set_zero_pit pit c] is a new list of board pits [pit] with the count of pit
    [c] set to 0 if [c] is in [pit]. Otherwise, Invalid_argument is raised. **)

val update_store : int * int -> int -> int * int
(** [update_store store curr] increments the count of the current store [curr]
    by one in the board store [store]. Requires: [curr] is a valid store, thus
    representing one of the two board stores. **)

val check_store : int -> bool -> bool
(** [check_store curr turn] is [true] if [curr] is a valid store for the player
    [turn], otherwise [false]. **)

val get_tail : int * int -> int
(** [get_tail t] is the second element b in the tuple [t] if [t] = [(a,b)]. **)

val get_opposite_count : State.board -> int -> int
(** [get_opposite_count b p] is the number of stones in the pit opposite from
    [p] in the game board [b]. Requires: [p] is a valid pit in [b].*)

val carry_over : State.game -> int -> bool
(** [carry_over g p] is [true] if [p] is a valid pit on the side of player
    [g.turn] with 1 stone in it, and [p] has an opposite pit with at least 1
    stone. Otherwise, [false].*)

val carry_to_store : State.game -> int -> int * int
(** [carry_to_store g p] is a new store for [g.game_board] with the store
    corresponding to player [g.turn] updated with the carry-over stones from pit
    [p] and its opposite. Requires: [carry_over g p] is true*)

val carry_marbles : State.game -> int -> bool -> State.board
(** [carry_marbles g pit turn] is a new board with the pits, stores, and turn
    updated based on the selected [pit] and player [turn].*)

val pick_tile : State.game -> int -> State.board
(** [pick_tile g p] checks if p is a valid pit selection for the player [t] and
    if so, calls [carry_marbles g p g.turn] and is a new board with the pits,
    stores, and turn updated. Otherwise, Invalid_argument is raised. **)

module State : module type of State
module AiLogic : module type of AiLogic