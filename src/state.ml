type board = {
  mutable pits : (int * int) list; (*[(1, 4); (2, 4)...*)
  mutable store : int * int; (*(1,5) (p1 store, p2 store)*)
  opposites : (int * int) list; (*(1,12); (2,11)... *)
}

type game = {
  mutable game_board : board;
  mutable turn : bool; (* player1 is true *)
  mutable p1 : string; (* player1's name *)
  mutable p2 : string; (* player2's name *)
}

let startboard =
  {
    pits =
      [
        (0, 4);
        (1, 4);
        (2, 4);
        (3, 4);
        (4, 4);
        (5, 4);
        (6, 0);
        (7, 4);
        (8, 4);
        (9, 4);
        (10, 4);
        (11, 4);
        (12, 4);
        (13, 0);
      ];
    store = (0, 0);
    opposites =
      [
        (0, 12);
        (1, 11);
        (2, 10);
        (3, 9);
        (4, 8);
        (5, 7);
        (7, 5);
        (8, 4);
        (9, 3);
        (10, 2);
        (11, 1);
        (12, 0);
      ];
  }

let game =
  { game_board = startboard; turn = true; p1 = "Player 1"; p2 = "Player 2" }

let rec split_pits l i1 i2 acc =
  let reversed =
    match l with
    | [] -> acc
    | (k, v) :: t ->
        if k >= i1 && k <= i2 then split_pits t i1 i2 ((k, v) :: acc)
        else split_pits t i1 i2 acc
  in
  List.rev reversed

let p1 = split_pits game.game_board.pits 0 5 []
let p2 = split_pits game.game_board.pits 7 12 []

(** [get_pit_val pits idx] is the number of marbels in the [idx] pit*)
let rec get_pit_val (pits : (int * int) list) idx =
  match pits with
  | (i, v) :: t -> if i = idx then v else get_pit_val t idx
  | _ -> raise (Failure "invalid index")

let get_store_val stores player =
  match stores with
  | a, b -> if player then a else b

let rec sum l =
  match l with
  | [] -> 0
  | (k, v) :: t -> v + sum t

let reset g =
  g.game_board.pits <- startboard.pits;
  g.game_board.store <- startboard.store;
  g.turn <- true

let terminate turn b =
  let p1 = split_pits b.pits 0 5 [] in
  let p2 = split_pits b.pits 7 12 [] in
  match turn with
  | true -> if sum p1 = 0 then true else false
  | false -> if sum p2 = 0 then true else false

let winner g ai =
  match g.store with
  | p1, p2 ->
      if p1 > p2 then "Player 1 Wins ٩( ^ᴗ^ )۶!!"
      else if p1 < p2 && not ai then "Player 2 Wins ╰(´꒳`)╯!!"
      else if p1 < p2 && ai then "AI Wins ʕ·ᴥ·ʔ!!"
      else "Tie :-D"
