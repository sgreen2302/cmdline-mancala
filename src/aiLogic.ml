type ai = {
  mutable on : bool;
  mutable mode : string;
}

let ai = { on = false; mode = "MEDIUM" }
let set_ai b = ai.on <- b
let state_ai () = ai.on
let set_mode m = ai.mode <- m
let ai_mode () = ai.mode

let rec check_pits p num =
  if num = 13 then -1
  else if 13 - num - List.assoc num p = 0 then num
  else check_pits p (num + 1)

let rec check_empty move pits =
  if move = 13 then -1
  else
    let check = (move + List.assoc move pits) mod 14 in
    if
      List.assoc move pits <> 0
      && check < 13 && check > 6
      && List.assoc check pits = 0
    then move
    else check_empty (move + 1) pits

let rec check_empty_smart store move pits lst =
  if move = 13 then lst
  else
    let check = (move + List.assoc move pits) mod 14 in
    let opp = check - (2 * (check - 6)) in
    if
      List.assoc move pits <> 0
      && check < 13 && check > 6
      && List.assoc check pits = 0
      && opp <> move
      && List.assoc opp pits <> 0
    then
      check_empty_smart store (move + 1) pits
        ((move, 1 + store + List.assoc opp pits) :: lst)
    else check_empty_smart store (move + 1) pits lst

let rec find_largest lst (pair : int * int) =
  match (lst, pair) with
  | [], (move, store) -> move
  | (m, st) :: t, (move, store) ->
      if st > store then find_largest t (m, st) else find_largest t (move, store)

let easy_ai pits =
  try
    let choice = check_pits pits 7 in
    if choice = -1 then (Random.int 230000 mod 6) + 7 else choice
  with f -> raise (Failure "check pits failed")

let medium_ai pits =
  try
    let choice = check_pits pits 7 in
    if choice <> -1 then choice
    else
      let move = check_empty 7 pits in
      if move <> -1 then move else (Random.int 230000 mod 6) + 7
  with f -> raise (Failure "check empty failed")

let smart_ai pits store =
  let choice = check_pits pits 7 in
  if choice <> -1 then choice
  else
    let move = check_empty_smart store 7 pits [] in
    if move <> [] then
      let found = find_largest move (-1, 0) in
      if found = -1 then (Random.int 230000 mod 6) + 7 else found
    else (Random.int 230000 mod 6) + 7

let rec make_valid move pits =
  if List.assoc move pits = 0 then
    make_valid ((Random.int 230000 mod 6) + 7) pits
  else move

let decision (b : State.board) =
  match b.store with
  | _, i ->
      if ai.mode = "BABY" then make_valid ((Random.int 230000 mod 6) + 7) b.pits
      else if ai.mode = "EASY" then make_valid (easy_ai b.pits) b.pits
      else if ai.mode = "MED" then make_valid (medium_ai b.pits) b.pits
      else if ai.mode = "SMART" then make_valid (smart_ai b.pits i) b.pits
      else -1
