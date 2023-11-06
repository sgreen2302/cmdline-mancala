open State
open AiLogic

let rec update_pit (pit : (int * int) list) (curr : int) =
  match pit with
  | [] -> raise (Invalid_argument "Current pit invalid")
  | (a, b) :: t ->
      if a = curr then (curr, b + 1) :: t else (a, b) :: update_pit t curr

let rec set_zero_pit (pit : (int * int) list) (c : int) =
  match pit with
  | [] -> raise (Invalid_argument "Chosen pit invalid")
  | (a, b) :: t -> if a = c then (c, 0) :: t else (a, b) :: set_zero_pit t c

let update_store store curr =
  match store with
  | a, b -> if curr = 6 then (a + 1, b) else (a, b + 1)

let check_store curr turn = (curr = 6 && turn) || (curr = 13 && not turn)

let get_tail (t : int * int) =
  match t with
  | _, b -> b

let get_opposite_count b p = List.assoc (List.assoc p b.opposites) b.pits

let carry_over g p =
  let b = g.game_board in
  let t = g.turn in
  if
    t && p > 0 && p < 6 && List.assoc p b.pits = 1 && get_opposite_count b p > 0
  then true
  else if
    (not t) && p > 6 && p < 13
    && List.assoc p b.pits = 1
    && get_opposite_count b p > 0
  then true
  else false

let carry_to_store g p =
  let b = g.game_board in
  let t = g.turn in
  match b.store with
  | x, y ->
      if t then (x + 1 + get_opposite_count b p, y)
      else (x, y + 1 + get_opposite_count b p)

let carry_marbles g pit turn =
  let board = g.game_board in
  let in_motion = ref (List.assoc pit board.pits) in
  let curr = ref ((pit + 1) mod 14) in
  while !in_motion > 0 do
    in_motion := !in_motion - 1;

    if check_store !curr turn then board.store <- update_store board.store !curr
    else (
      if !curr = 6 || !curr = 13 then curr := (!curr + 1) mod 14;

      board.pits <- update_pit board.pits !curr);

    curr := (!curr + 1) mod 14
  done;
  if carry_over g (!curr - 1) then (
    board.store <- carry_to_store g (!curr - 1);
    board.pits <-
      set_zero_pit board.pits (List.assoc (!curr - 1) board.opposites);
    board.pits <- set_zero_pit board.pits (!curr - 1);
    board.pits <- set_zero_pit board.pits pit)
  else board.pits <- set_zero_pit board.pits pit;

  if check_store ((!curr + 13) mod 14) g.turn then board
  else (
    g.turn <- not g.turn;

    board)

let pick_tile g p =
  let turn = g.turn in

  if turn then
    let count = List.assoc p g.game_board.pits in
    if p < 6 && p >= 0 then
      if count = 0 then raise (Invalid_argument "Zero balance in pit")
      else carry_marbles g p turn
    else raise (Invalid_argument "Invalid Move for P1")
  else if not (AiLogic.state_ai ()) then
    let count = List.assoc p g.game_board.pits in
    if p > 6 && p <= 12 then
      if count = 0 then raise (Invalid_argument "Zero balance in pit")
      else carry_marbles g p turn
    else raise (Invalid_argument "Invalid Move for P2")
  else carry_marbles g (AiLogic.decision g.game_board) turn

module State = State
module AiLogic = AiLogic