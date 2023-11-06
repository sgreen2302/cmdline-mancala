open OUnit2
open Mancala
open State
open AiLogic

(* Test Plan for overall system Module by Module:

   AILogic Test Plan: This was tested using black box and glass box testing. By
   looking at functions, we were able to write tests covering every branch to
   make sure our conditions were sound and, through testing expected
   functionality, we were able to detect and squash gameplay bugs. Through the
   use of both techniques, we are able to be assured that each case is handled
   appropriately and that our functions work as intended. We left out certain
   functions because the majority of the work is done by throughly tested
   functions, so confidence in those functions transfer confidence in the
   omitted functions.

   State Test Plan: The system were all automatically tested using glass box
   testing. By looking at the functions implemented in State.ml, we were able to
   write test cases that ensures every branch is covered by testing and
   functions properly. The glass box testing approach demostrates the
   correctness of the system, because we were given the game logic of Mancala
   and implemented every function based on the given game logic of Mancala.
   Hence, using glass box testing, we can ensure that all logic required by the
   rules of Mancala is correctly implemented.

   Mancala Test Plan: This module was tested using both glass box and black box
   testing. As we thought about the functions required to implement gameplay,
   black box testing was used to ensure that our code later worked as intented,
   especially with the broader functions that updated the game board. After
   implementation, glass box testing was used to ensure every branch was
   covered, which also utilized the bisect report. Through the use of bisect
   coverage nearing 100% and glass box testing through gameplay, we were able to
   ensure all functions are properly tested and working as intended.

   Generally, all modules were manually tested through comparing the gameplay of
   our implementation of Mancala with an offical online version of the game.
   This helped us to instill full confidence that our implementations worked
   correctly because it mimicked other functioning implementations. *)

let start_pits =
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
  ]

let opps =
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
  ]

let zero_pits =
  [
    (0, 5);
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
  ]

let one_pits =
  [
    (0, 5);
    (1, 5);
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
  ]

let set_zero_pits =
  [
    (0, 4);
    (1, 4);
    (2, 4);
    (3, 4);
    (4, 0);
    (5, 4);
    (6, 0);
    (7, 4);
    (8, 4);
    (9, 4);
    (10, 4);
    (11, 4);
    (12, 4);
    (13, 0);
  ]

let first_move_board =
  {
    pits =
      [
        (0, 4);
        (1, 4);
        (2, 4);
        (3, 4);
        (4, 0);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 5);
        (9, 4);
        (10, 4);
        (11, 4);
        (12, 4);
        (13, 0);
      ];
    store = (1, 0);
    opposites = opps;
  }

let first_move_game =
  {
    game_board = first_move_board;
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let second_move_board =
  {
    pits =
      [
        (0, 5);
        (1, 5);
        (2, 4);
        (3, 4);
        (4, 0);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 5);
        (9, 4);
        (10, 4);
        (11, 0);
        (12, 5);
        (13, 0);
      ];
    store = (1, 1);
    opposites = opps;
  }

let emptied_pits =
  [
    (0, 0);
    (1, 0);
    (2, 0);
    (3, 0);
    (4, 0);
    (5, 0);
    (6, 0);
    (7, 0);
    (8, 0);
    (9, 0);
    (10, 0);
    (11, 0);
    (12, 0);
    (13, 0);
  ]

let multi_pits =
  [
    (0, 14);
    (1, 0);
    (2, 11);
    (3, 0);
    (4, 0);
    (5, 0);
    (6, 0);
    (7, 6);
    (8, 0);
    (9, 0);
    (10, 0);
    (11, 0);
    (12, 0);
    (13, 0);
  ]

let multi_mt =
  [
    (0, 12);
    (1, 0);
    (2, 4);
    (3, 0);
    (4, 0);
    (5, 0);
    (6, 0);
    (7, 0);
    (8, 0);
    (9, 1);
    (10, 2);
    (11, 0);
    (12, 0);
    (13, 0);
  ]

let second_move_game =
  {
    game_board = second_move_board;
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let check_store_test (name : string) (curr : int) (turn : bool)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal expected_output (check_store curr turn)

let update_store_test (name : string) (store : int * int) (curr : int)
    (expected_output : int * int) : test =
  name >:: fun _ -> assert_equal expected_output (update_store store curr)

let update_pit_test (name : string) (pits : (int * int) list) (curr : int)
    (expected_output : (int * int) list) : test =
  name >:: fun _ -> assert_equal expected_output (update_pit pits curr)

let set_zero_pit_test (name : string) (pits : (int * int) list) (curr : int)
    (expected_output : (int * int) list) : test =
  name >:: fun _ -> assert_equal expected_output (set_zero_pit pits curr)

let get_tail_test (name : string) (t : int * int) (expected_output : int) : test
    =
  name >:: fun _ -> assert_equal expected_output (get_tail t)

let get_opposite_count_test (name : string) (b : State.board) (p : int)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (get_opposite_count b p)

let carry_over_test (name : string) (g : State.game) (p : int)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal expected_output (carry_over g p)

let carry_to_store_test (name : string) (g : State.game) (p : int)
    (expected_output : int * int) : test =
  name >:: fun _ -> assert_equal expected_output (carry_to_store g p)

let carry_test (name : string) (game : game) (pit : int)
    (expected_output : board) : test =
  name >:: fun _ ->
  assert_equal expected_output (carry_marbles game pit game.turn)

let carry_pits_test (name : string) (game : game) (pit : int)
    (expected_output : (int * int) list) : test =
  name >:: fun _ ->
  assert_equal expected_output (carry_marbles game pit game.turn).pits

let carry_store_test (name : string) (game : game) (pit : int)
    (expected_output : int * int) : test =
  name >:: fun _ ->
  assert_equal expected_output (carry_marbles game pit game.turn).store

let pick_tile_test (name : string) (game : game) (pit : int)
    (expected_output : int * int) : test =
  name >:: fun _ -> assert_equal expected_output (pick_tile game pit).store

let ai_off () = set_ai false
let reset_mode () = set_mode "MEDIUM"

let state_ai_test (name : string) (actual_output : bool)
    (expected_output : bool) : test =
  ai_off ();
  name >:: fun _ -> assert_equal expected_output actual_output

let mode_ai_test (name : string) (actual_output : string)
    (expected_output : string) : test =
  reset_mode ();
  name >:: fun _ -> assert_equal expected_output actual_output

let check_pits_test (name : string) (num : int) (p : (int * int) list)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (check_pits p num)

let check_empty_test (name : string) (move : int) (pits : (int * int) list)
    (expected_output : int) : test =
  name >:: fun _ ->
  assert_equal expected_output (check_empty move pits) ~printer:string_of_int

let empty_smart_test (name : string) (store : int) (move : int)
    (pits : (int * int) list) (expected_output : (int * int) list) : test =
  name >:: fun _ ->
  assert_equal expected_output (check_empty_smart store move pits [])

let start_pits =
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
  ]

let zero_pits =
  [
    (0, 5);
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
  ]

let starting_board = { pits = start_pits; store = (0, 0); opposites = opps }

let one_pits =
  [
    (0, 5);
    (1, 5);
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
  ]

let first_move_board =
  {
    pits =
      [
        (0, 4);
        (1, 4);
        (2, 4);
        (3, 4);
        (4, 0);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 5);
        (9, 4);
        (10, 4);
        (11, 4);
        (12, 4);
        (13, 0);
      ];
    store = (1, 0);
    opposites = opps;
  }

let first_move_game =
  {
    game_board = first_move_board;
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let second_move_board =
  {
    pits =
      [
        (0, 5);
        (1, 5);
        (2, 4);
        (3, 4);
        (4, 0);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 5);
        (9, 4);
        (10, 4);
        (11, 0);
        (12, 5);
        (13, 0);
      ];
    store = (1, 1);
    opposites = opps;
  }

let second_move_game =
  {
    game_board = second_move_board;
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let carry_over_board =
  {
    pits =
      [
        (0, 5);
        (1, 5);
        (2, 4);
        (3, 0);
        (4, 1);
        (5, 6);
        (6, 1);
        (7, 6);
        (8, 5);
        (9, 0);
        (10, 5);
        (11, 1);
        (12, 6);
        (13, 0);
      ];
    store = (1, 2);
    opposites = opps;
  }

let p1_carry_over_game =
  {
    game_board = carry_over_board;
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let p2_carry_over_game =
  {
    game_board = carry_over_board;
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

(* choose 1 *)
let p1_carry_to_store_board =
  {
    pits =
      [
        (0, 0);
        (1, 1);
        (2, 6);
        (3, 6);
        (4, 6);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 0);
        (9, 1);
        (10, 1);
        (11, 7);
        (12, 7);
        (13, 0);
      ];
    store = (1, 2);
    opposites = opps;
  }

(*choose 12, also double as P2 play again (12) and P1 skip over P2 store (5) *)
let p2_carry_to_store_board =
  {
    pits =
      [
        (0, 1);
        (1, 0);
        (2, 8);
        (3, 6);
        (4, 1);
        (5, 8);
        (6, 0);
        (7, 6);
        (8, 1);
        (9, 2);
        (10, 0);
        (11, 0);
        (12, 1);
        (13, 0);
      ];
    store = (10, 3);
    opposites = opps;
  }

let p1_carry_store_game =
  {
    game_board = p1_carry_to_store_board;
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let p2_carry_store_game =
  {
    game_board = p2_carry_to_store_board;
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let skip_store_game =
  {
    game_board = p2_carry_to_store_board;
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let skip_board_2 =
  {
    pits =
      [
        (0, 0);
        (1, 1);
        (2, 6);
        (3, 6);
        (4, 6);
        (5, 5);
        (6, 0);
        (7, 0);
        (8, 1);
        (9, 2);
        (10, 2);
        (11, 8);
        (12, 8);
        (13, 0);
      ];
    store = (1, 2);
    opposites = opps;
  }

let skip_store_game_2 =
  { game_board = skip_board_2; turn = false; p1 = "Player 1"; p2 = "Player 2" }

let pick_game_1 =
  {
    game_board =
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
        opposites = opps;
      };
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let pick_game_2 =
  {
    game_board =
      {
        pits =
          [
            (0, 4);
            (1, 4);
            (2, 4);
            (3, 4);
            (4, 0);
            (5, 5);
            (6, 0);
            (7, 5);
            (8, 5);
            (9, 4);
            (10, 4);
            (11, 4);
            (12, 4);
            (13, 0);
          ];
        store = (1, 0);
        opposites = opps;
      };
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let pick_game_3 =
  {
    game_board =
      {
        pits =
          [
            (0, 4);
            (1, 0);
            (2, 5);
            (3, 5);
            (4, 5);
            (5, 5);
            (6, 0);
            (7, 4);
            (8, 0);
            (9, 5);
            (10, 5);
            (11, 5);
            (12, 5);
            (13, 0);
          ];
        store = (0, 0);
        opposites = opps;
      };
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

let pick_game_4 =
  {
    game_board =
      {
        pits =
          [
            (0, 4);
            (1, 0);
            (2, 5);
            (3, 5);
            (4, 5);
            (5, 5);
            (6, 0);
            (7, 4);
            (8, 0);
            (9, 5);
            (10, 5);
            (11, 5);
            (12, 5);
            (13, 0);
          ];
        store = (0, 0);
        opposites = opps;
      };
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

(* choose 0 *)
let p1_carry_marble_board =
  {
    pits =
      [
        (0, 1);
        (1, 0);
        (2, 6);
        (3, 6);
        (4, 6);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 0);
        (9, 1);
        (10, 1);
        (11, 7);
        (12, 7);
        (13, 0);
      ];
    store = (1, 2);
    opposites = opps;
  }

let p1_carry_marble_game =
  {
    game_board = p1_carry_marble_board;
    turn = true;
    p1 = "Player 1";
    p2 = "Player 2";
  }

(* choose 10 *)
let p2_carry_marble_board_a =
  {
    pits =
      [
        (0, 0);
        (1, 0);
        (2, 6);
        (3, 6);
        (4, 6);
        (5, 5);
        (6, 0);
        (7, 5);
        (8, 0);
        (9, 1);
        (10, 1);
        (11, 0);
        (12, 7);
        (13, 0);
      ];
    store = (9, 2);
    opposites = opps;
  }

let p2_carry_marble_game_a =
  {
    game_board = p2_carry_marble_board_a;
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

(*choose 11*)
let p2_carry_marble_board_b =
  {
    pits =
      [
        (0, 1);
        (1, 0);
        (2, 8);
        (3, 6);
        (4, 1);
        (5, 8);
        (6, 0);
        (7, 6);
        (8, 1);
        (9, 2);
        (10, 0);
        (11, 1);
        (12, 0);
        (13, 0);
      ];
    store = (10, 3);
    opposites = opps;
  }

let p2_carry_marble_game_b =
  {
    game_board = p2_carry_marble_board_b;
    turn = false;
    p1 = "Player 1";
    p2 = "Player 2";
  }

(* check that failure is raised: ( "lonely room - exit failure" >:: fun _ ->
   assert_raises (UnknownExit "ho plaza") (fun () -> next_room lonely_t "the
   room" "ho plaza") ); *)

let p1_start_pits = [ (0, 4); (1, 4); (2, 4); (3, 4); (4, 4); (5, 4) ]
let p2_start_pits = [ (7, 4); (8, 4); (9, 4); (10, 4); (11, 4); (12, 4) ]

let rec print_list l =
  match l with
  | [] -> print_endline ""
  | (i, v) :: t ->
      print_endline (string_of_int i ^ ", " ^ string_of_int v);
      print_list t

let split_pits_test (name : string) (pits : (int * int) list) (starti : int)
    (endi : int) (acc : (int * int) list) (expected_output : (int * int) list) :
    test =
  name >:: fun _ ->
  let res = split_pits pits starti endi acc in
  assert_equal res expected_output

let get_pit_val_test (name : string) (pits : (int * int) list) (idx : int)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (get_pit_val pits idx)

let get_store_val_test (name : string) (store : int * int) (pl : bool)
    (expected_output : int) : test =
  name >:: fun _ -> assert_equal expected_output (get_store_val store pl)

let sum_test (name : string) (pits : (int * int) list) (expected_output : int) :
    test =
  name >:: fun _ -> assert_equal (sum pits) expected_output

let terminate_test (name : string) (turn : bool) (board : board)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal (terminate turn board) expected_output

let winner_test (name : string) (board : board) (ai : bool)
    (expected_output : string) : test =
  name >:: fun _ -> assert_equal (winner board ai) expected_output

let p1_zeros =
  {
    pits =
      [
        (0, 0);
        (1, 0);
        (2, 0);
        (3, 0);
        (4, 0);
        (5, 0);
        (6, 0);
        (7, 0);
        (8, 3);
        (9, 4);
        (10, 4);
        (11, 4);
        (12, 4);
        (13, 0);
      ];
    store = (20, 9);
    opposites = opps;
  }

let p2_zeros =
  {
    pits =
      [
        (0, 0);
        (1, 2);
        (2, 0);
        (3, 0);
        (4, 2);
        (5, 0);
        (6, 0);
        (7, 0);
        (8, 0);
        (9, 0);
        (10, 0);
        (11, 0);
        (12, 0);
        (13, 0);
      ];
    store = (22, 22);
    opposites = opps;
  }

let p2_winner =
  {
    pits =
      [
        (0, 0);
        (1, 0);
        (2, 0);
        (3, 0);
        (4, 0);
        (5, 0);
        (6, 0);
        (7, 0);
        (8, 3);
        (9, 4);
        (10, 4);
        (11, 4);
        (12, 4);
        (13, 0);
      ];
    store = (9, 20);
    opposites = opps;
  }

let starting_game =
  { game_board = starting_board; turn = true; p1 = "Player 1"; p2 = "Player 2" }

let custom_reset g b t =
  g.game_board.pits <- b.pits;
  g.game_board.store <- b.store;
  g.turn <- t;
  g

let p1_zeros_game =
  { game_board = p1_zeros; turn = true; p1 = "Player 1"; p2 = "Player 2" }

let state_tests =
  [
    split_pits_test "player 1 start board" start_pits 0 5 [] p1_start_pits;
    split_pits_test "player 2 start board" start_pits 7 12 [] p2_start_pits;
    get_pit_val_test "get pit value 0" start_pits 0 4;
    get_pit_val_test "get pit value 8" p1_zeros.pits 8 3;
    get_pit_val_test "get pit value 13" p1_zeros.pits 13 0;
    ( "invalid get pit value -1" >:: fun _ ->
      assert_raises (Failure "invalid index") (fun () ->
          get_pit_val p1_zeros.pits (-1)) );
    ( "invalid get pit value 20" >:: fun _ ->
      assert_raises (Failure "invalid index") (fun () ->
          get_pit_val p1_zeros.pits 20) );
    get_store_val_test "get store value player 1" p2_winner.store true 9;
    get_store_val_test "get store value player 2" p2_winner.store false 20;
    sum_test "sum start board" start_pits 48;
    sum_test "sum first move board" first_move_board.pits 47;
    terminate_test "terminate true player 1 turn" true p1_zeros true;
    terminate_test "terminate true player 2 turn" false p2_zeros true;
    terminate_test "terminate false player 1 turn" true p2_zeros false;
    terminate_test "terminate false player 2 turn" false p1_zeros false;
    winner_test "winner player 1" p1_zeros false "Player 1 Wins ٩( ^ᴗ^ )۶!!";
    winner_test "winner player 1 with ai" p1_zeros true
      "Player 1 Wins ٩( ^ᴗ^ )۶!!";
    winner_test "tie" p2_zeros false "Tie :-D";
    winner_test "winner player 2" p2_winner false "Player 2 Wins ╰(´꒳`)╯!!";
    winner_test "winner ai" p2_winner true "AI Wins ʕ·ᴥ·ʔ!!";
  ]

let mancala_tests =
  [
    check_store_test "P1 store / P1 turn" 6 true true;
    check_store_test "P1\n       store / P2 turn" 6 false false;
    check_store_test "P2 store / P1 turn" 13 true false;
    check_store_test "P2 store / P2 turn" 13 false true;
    update_store_test "empty store, P1" (0, 0) 6 (1, 0);
    update_store_test "empty store, P2" (0, 0) 13 (0, 1);
    update_store_test "non-empty store,\n       P1" (4, 6) 6 (5, 6);
    update_store_test "non-empty store, P2" (7, 7) 13 (7, 8);
    update_pit_test "starting pit config, pit 1" start_pits 0 zero_pits;
    update_pit_test "modified pit config, pit 2" zero_pits 1 one_pits;
    ( "invalid pit - pit failure" >:: fun _ ->
      assert_raises (Invalid_argument "Current pit invalid") (fun () ->
          update_pit one_pits 14) );
    set_zero_pit_test "set 0, pit 4" start_pits 4 set_zero_pits;
    ( "invalid pit - pit failure" >:: fun _ ->
      assert_raises (Invalid_argument "Chosen pit invalid") (fun () ->
          set_zero_pit start_pits 14) );
    get_tail_test "store - P1:0, P2: 2" (0, 2) 2;
    get_opposite_count_test "starting board, pit 4" startboard 4 4;
    get_opposite_count_test "first\n       move board, pit 4" first_move_board 4
      5;
    get_opposite_count_test "first\n       move board, pit 8" first_move_board 8
      0;
    carry_over_test "starting game\n       (P1), pit 4" starting_game 4 false;
    carry_over_test "P1 turn, pit 4" p1_carry_over_game 4 true;
    carry_over_test "P2 turn, pit 11" p2_carry_over_game 11 true;
    carry_to_store_test "P1 / pit 0" p1_carry_store_game 1 (9, 2);
    carry_to_store_test "P2 / pit 11" p2_carry_store_game 12 (10, 5);
    carry_pits_test "pits - starting config,\n       P1 pit 4" starting_game 4
      first_move_board.pits;
    carry_store_test "store\n       - starting config, P1 pit 4" starting_game 4
      first_move_board.store;
    carry_test "board - starting config, P1 4" starting_game 4 first_move_board;
    carry_pits_test "pits - first move config, P2 pit 11" first_move_game 11
      second_move_board.pits;
    carry_store_test "store -\n       first move config, P2 pit 11"
      first_move_game 11 second_move_board.store;
    carry_store_test "store - carry-over P1" p1_carry_marble_game 0 (9, 2);
    carry_store_test "store - no carry-over P2" p2_carry_marble_game_a 10 (9, 2);
    carry_store_test "store - carry-over P1" p2_carry_marble_game_b 11 (10, 5);
    carry_store_test "store - P2 land in store" p2_carry_store_game 12 (10, 4);
    (* carry_store_test "store - P1 skip P2 store" skip_store_game 5 (11, 3); *)
    carry_store_test "store - P2 skip P1 store" skip_store_game_2 12 (1, 10);
    pick_tile_test "starting config, P1 4" pick_game_1 4 (1, 0);
    pick_tile_test "first move config, P2 11" pick_game_2 9 (1, 1);
    ( "P1 invalid pit - zero balance" >:: fun _ ->
      assert_raises (Invalid_argument "Zero balance in pit") (fun () ->
          pick_tile pick_game_3 1) );
    ( "P2 invalid pit - zero balance" >:: fun _ ->
      assert_raises (Invalid_argument "Zero balance in pit") (fun () ->
          pick_tile pick_game_4 8) );
    ( "P1 invalid pit - P2 pit" >:: fun _ ->
      assert_raises (Invalid_argument "Invalid Move for P1") (fun () ->
          pick_tile pick_game_3 8) );
    ( "P2 invalid pit - P1 pit" >:: fun _ ->
      assert_raises (Invalid_argument "Invalid Move for P2") (fun () ->
          pick_tile pick_game_4 1) );
  ]

let ai_tests =
  [
    state_ai_test "default setting" (state_ai ()) false;
    state_ai_test "set true"
      (set_ai true;
       state_ai ())
      true;
    state_ai_test "set false"
      (set_ai false;
       state_ai ())
      false;
    mode_ai_test "default mode" (ai_mode ()) "MEDIUM";
    mode_ai_test "BABY mode"
      (set_mode "BABY";
       ai_mode ())
      "BABY";
    check_pits_test "check_pits startboard 0" 0 start_pits 9;
    check_pits_test "check_pits startboard 10" 10 start_pits (-1);
    check_pits_test "check_pits empty 0" 0 emptied_pits (-1);
    check_pits_test "check_pits multiple 0" 0 multi_pits 2;
    check_pits_test "check_pits multiple 5" 5 multi_pits 7;
    check_pits_test "check_pits P2 store 13" 13 emptied_pits (-1);
    check_empty_test "check_empty startboard 0" 0 start_pits (-1);
    check_empty_test "check_empty lands store" 0 multi_pits (-1);
    check_empty_test "check_empty multi valid" 0 multi_mt 0;
    check_empty_test "check_empty valid10 10" 10 multi_mt 10;
    empty_smart_test "check_empty smart" 0 1 multi_mt [ (10, 13) ];
    empty_smart_test "check_empty overflow" 0 0
      [
        (0, 2);
        (1, 1);
        (2, 4);
        (3, 0);
        (4, 4);
        (5, 0);
        (6, 0);
        (7, 0);
        (8, 0);
        (9, 2);
        (10, 26);
        (11, 0);
        (12, 0);
        (13, 0);
      ]
      [ (10, 5); (9, 2) ];
    ( "find_large" >:: fun _ ->
      assert_equal 10 (find_largest [ (10, 5); (9, 2) ] (0, 0)) );
    ( "find_impos" >:: fun _ ->
      assert_equal (-1) (find_largest [ (10, 5); (9, 2) ] (-1, 10)) );
  ]

let suite =
  "test suite" >::: List.flatten [ state_tests; mancala_tests; ai_tests ]

let _ = run_test_tt_main suite
