(** Representation of mutable Mancala artificial intelligence.

    This module represents the logic needed to represent a opponent in a single
    player game. It handles turning on and off the AI, setting its level of
    inteligence, as well as querying the decision that results from its
    analysis. *)

val set_ai : bool -> unit
(** [set_ai b] modifies AI to be in its active state if [b] [true], otherwise AI
    inactive. *)

val state_ai : unit -> bool
(** [state_ai] is AI's current state, active if [true], inactive otherwise. *)

val set_mode : string -> unit
(** [set_mode m] modifies AI to be of difficulty [m]. Requires: [m] be one of
    four strings: ["BABY"], ["EASY"], ["MEDIUM"] or ["MED"], ["SMART"] *)

val ai_mode : unit -> string
(** [ai_mode] is AI's current difficulty setting. Default is ["MEDIUM"]*)

val check_pits : (int * int) list -> int -> int
(** [check_pits p num] is the leftmost key, starting from [num], associated with
    a value in which [key + value] will equal the key of the last binding in the
    list. If no such key exists, is [-1] In terms of Macala, returns leftmost
    key whose value will result in landing in Player 2's store.

    Requires: [p] to have keys similar to an Array's (0: v0; 1: v1; ... n: vn)
    and it must have a length of 14. [num] must be less than or equal to 13 *)

val check_empty : int -> (int * int) list -> int
(** [check_empty move pits] is the leftmost key, starting from [move],
    associated with a value in which [key + value] will equal the key of a
    binding whose value is 0. If no such key exists, is [-1]. In terms of
    Macala, returns key whose value will result in landing in an empty pit.

    Requires: [pits] to have keys similar to an Array's (0: v0; 1: v1; ... n:
    vn) and it must have a length of 14. [move] must be less than or equal to 13 *)

val check_empty_smart :
  int -> int -> (int * int) list -> (int * int) list -> (int * int) list
(** [check_empty_smart store move pits lst] is the list of keys that were
    associated with a value in which [key + value] would equal the key of a
    binding whose value is 0 and value of [store] + value associated with key +
    value associated opposing key. If no such key exists, is [lst]. In terms of
    Macala, returns list of keys whose value results in landing in an empty pit
    and the total in Player 2's store if a move was made.

    Requires: [pits] to have keys similar to an Array's (0: v0; 1: v1; ... n:
    vn) and it must have a length of 14. [move] must be less than or equal to
    13. [lst] must be an empty lst. *)

val find_largest : (int * int) list -> int * int -> int
(** [find_largest lst pair] is key associated with the highest value in [lst]
    that is higher than value associated with [pair], if no such key exists, is
    the key in [pair]*)

val easy_ai : (int * int) list -> int
(** [easy_ai b] is AI choice prioritizing moves that will allow them to play
    again. If no such move exists, will choose a random move.*)

val medium_ai : (int * int) list -> int
(** [medium_ai b] is AI choice prioritizing moves that will allow them to play
    again. If no such move exists, will prioritize moves that will land a marble
    in an empty pit on Player 2's side. If no such move exists, will choose a
    random move.*)

val smart_ai : (int * int) list -> int -> int
(** [smart_ai b store] is the is AI choice prioritizing moves that will allow
    them to play again. If no such move exists, will prioritize moves that will
    land a marble in an empty pit on Player 2's side and get them the most
    increase to their points. If no such move exists, will choose a random move.*)

val make_valid : int -> (int * int) list -> int
(** [make_valid move pits] if value associated with [move] is 0 then is first
    random key that is not associated with 0, else is [move]

    Requires: [pits] to have keys similar to an Array's (0: v0; 1: v1; ... n:
    vn) and it must have a length of 14.*)

val decision : State.board -> int
(** [decision b] is the Mancala move of the AI based on its difficulty*)
