(** Representation of mutable game data.

    This module represents the data stored in the game, including the pits, store, opposites,
    player's turn, name of player 1, and name of player 2. *)

type board = {
  mutable pits : (int * int) list;
  mutable store : int * int;
  opposites : (int * int) list;
}
(** The board type represents the game board. It is a record containing keys corresponding to the 
mutable association list representing the values in each pit on the game board, the mutable
store representing the number of marbles in player 1 and player 2's stores, and the immutable
association list representing index of pits on the opposite side of each other on the game board. *)

type game = {
  mutable game_board : board;
  mutable turn : bool;
  mutable p1 : string;
  mutable p2 : string;
}
(** The game type represents the game. It is a record containing keys corresponding to the game board,
    the boolean that represents whether it is player 1's turn, the name of player 1, and the name of player 2. *)

val startboard : board
(** [startboard] is the board at the start of a game. *)
val game : game
(** [game] is the game at the start of a game. *)

val split_pits :
  (int * int) list -> int -> int -> (int * int) list -> (int * int) list
(** [split_pits l i1 i2 acc] is index [i1] to index [i2] of [l] *)

val p1 : (int * int) list
(** [p1] is player 1 side of the pits *)

val p2 : (int * int) list
(** [p2] is player 2 side of the pits*)

val get_pit_val : (int * int) list -> int -> int
(** [get_pit_val pits idx] is the number of marbels in the [idx] pit*)

val get_store_val : int * int -> bool -> int
(** [get_store_val store player] is the number of marbels in [player]'s store*)

val sum : (int * int) list -> int
(** [sum l] is the sum of the values in a record. *)

val reset : game -> unit
(** [reset g] changes [g] to the starting board *)

val terminate : bool -> board -> bool
(** [terminate turn b] is true if the game should terminate and false otherwise *)

val winner : board -> bool -> string
(** [winner g ai] is the string that states who the winner is based on the
    number of marbels in each player's store at the end of [g] *)
