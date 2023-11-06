open Mancala
open State
open AiLogic

let convert_tile str =
  if
    String.length str = 1
    && Char.code (Char.uppercase_ascii str.[0]) >= 65
    && Char.code (Char.uppercase_ascii str.[0]) <= 77
  then Char.code (Char.uppercase_ascii str.[0]) - 65
  else raise (Failure "unable to convert")

let printboard board =
  let p = board.pits in
  let a = string_of_int (get_pit_val p 0) in
  let b = string_of_int (get_pit_val p 1) in
  let c = string_of_int (get_pit_val p 2) in
  let d = string_of_int (get_pit_val p 3) in
  let e = string_of_int (get_pit_val p 4) in
  let f = string_of_int (get_pit_val p 5) in
  let h = string_of_int (get_pit_val p 7) in
  let i = string_of_int (get_pit_val p 8) in
  let j = string_of_int (get_pit_val p 9) in
  let k = string_of_int (get_pit_val p 10) in
  let l = string_of_int (get_pit_val p 11) in
  let m = string_of_int (get_pit_val p 12) in
  let p1 = string_of_int (get_store_val board.store true) in
  let p2 = string_of_int (get_store_val board.store false) in
  print_endline
    "\n------------------------------------------------------------\n\n";
  print_endline
    "\n----------------------<<< Player Two <<<---------------------";
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline "|        |  [M] |  [L] |  [K] | [J]  | [I]  | [H]  |        |";
  print_endline
    ("|   P    |   " ^ m ^ "  |   " ^ l ^ "  |   " ^ k ^ "  |  " ^ j ^ "   |  "
   ^ i ^ "   |  " ^ h ^ "   |    P   |");
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline "|   T    |      |      |      |      |      |      |    O   |";
  print_endline "|   W    -------------------------------------------    N   |";
  print_endline "|   O    |      |      |      |      |      |      |    E   |";
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline
    ("| TOTAL  |   " ^ a ^ "  |   " ^ b ^ "  |   " ^ c ^ "  |  " ^ d ^ "   |  "
   ^ e ^ "   |  " ^ f ^ "   |  TOTAL |");
  print_endline
    ("|   " ^ p2 ^ "    |  [A] |  [B] |  [C] | [D]  | [E]  | [F]  |    " ^ p1
   ^ "   |");
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline
    "---------------------->>> Player One >>>---------------------\n\n"

let rec continue_game () : unit =
  if terminate game.turn game.game_board then (
    print_endline (winner game.game_board (AiLogic.state_ai ()));
    reset game)
  else if not (AiLogic.state_ai ()) then (
    if game.turn then print_endline ("Hello " ^ game.p1 ^ "! \n")
    else print_endline ("Hello " ^ game.p2 ^ "! \n");
    print_endline "Pick a valid pit in your column: \n";
    print_string "> ";
    let input = read_line () in
    try
      let t = convert_tile input in
      game.game_board <- pick_tile game t;
      printboard game.game_board;
      continue_game ()
    with f -> (
      match f with
      | Invalid_argument x -> (
          match x with
          | "Invalid Move for P1" ->
              print_endline
                "This is player two's pit. Please choose again from A-F: \n";
              continue_game ()
          | "Invalid Move for P2" ->
              print_endline
                "This is player one's pit. Please choose again from H-M: \n";
              continue_game ()
          | "Zero balance in pit" ->
              print_endline
                "This pit contains zero stones to move. Please choose again: \n";
              continue_game ()
          | _ ->
              print_endline
                "This is another player's pit. Please choose again: \n";
              continue_game ())
      | Failure _ ->
          print_endline "This is an invalid pit. Please choose again: \n";
          continue_game ()
      | _ ->
          print_endline "Unable to process. \n";
          continue_game ()))
  else (
    if game.turn then
      print_string
        ("Hello " ^ game.p1 ^ "! \nPick a valid pit in your column:\n> ")
    else print_endline "AI is deciding";

    if game.turn then
      let input = read_line () in
      try
        let t = convert_tile input in
        game.game_board <- pick_tile game t;
        printboard game.game_board;
        continue_game ()
      with f -> (
        match f with
        | Invalid_argument x -> (
            match x with
            | "Invalid Move for P1" ->
                print_endline
                  "This is player two's pit. Please choose again from A-F: \n";
                continue_game ()
            | "Invalid Move for P2" ->
                print_endline
                  "This is player one's pit. Please choose again from H-M: \n";
                continue_game ()
            | "Zero balance in pit" ->
                print_endline
                  "This pit contains zero stones to move. Please choose again: \n";
                continue_game ()
            | _ ->
                print_endline
                  "This is another player's pit. Please choose again: \n";
                continue_game ())
        | Failure _ ->
            print_endline "This is an invalid pit. Please choose again: \n";
            continue_game ()
        | _ ->
            print_endline "Unable to process. \n";
            continue_game ())
    else (
      game.game_board <- pick_tile game (-1);
      printboard game.game_board;
      continue_game ()))

let starting_board () =
  print_endline
    "\n------------------------------------------------------------\n\n";
  print_endline
    "\n----------------------<<< Player Two <<<---------------------";
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline "|        |  [M] |  [L] |  [K] | [J]  | [I]  | [H]  |        |";
  print_endline "|   P    |   4  |   4  |   4  |  4   |  4   |  4   |    P   |";
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline "|   T    |      |      |      |      |      |      |    O   |";
  print_endline "|   W    -------------------------------------------    N   |";
  print_endline "|   O    |      |      |      |      |      |      |    E   |";
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline "| TOTAL  |   4  |   4  |   4  |  4   |  4   |  4   |  TOTAL |";
  print_endline "|   0    |  [A] |  [B] |  [C] | [D]  | [E]  | [F]  |    0   |";
  print_endline "|        |      |      |      |      |      |      |        |";
  print_endline
    "---------------------->>> Player One >>>---------------------\n\n";
  continue_game ()

let rec prompt_game () =
  print_endline "Do you want to play? (Yes or No)\n";
  print_string "> ";
  match read_line () with
  | exception End_of_file -> ()
  | str -> (
      match String.uppercase_ascii str with
      | "YES" | "Y" -> begin
          print_endline
            "Are you playing by yourself (1) or with a friend (2)?\n\n";
          print_string "> ";
          match read_line () with
          | exception End_of_file -> ()
          | num ->
              if String.length num = 1 then (
                match num with
                | "1" -> (
                    AiLogic.set_ai true;
                    print_endline "Pick a mode: baby, easy, medium or smart\n\n";
                    print_string "> ";
                    match read_line () with
                    | exception End_of_file -> ()
                    | mode -> (
                        (match String.uppercase_ascii mode with
                        | "BABY" -> AiLogic.set_mode "BABY"
                        | "EASY" -> AiLogic.set_mode "EASY"
                        | "MED" | "MEDIUM" -> AiLogic.set_mode "MED"
                        | "SMART" -> AiLogic.set_mode "SMART"
                        | _ ->
                            print_endline "\nBack to start :\n";
                            prompt_game ());
                        print_endline
                          "What do you want your Player's name to be? \n";
                        let s = read_line () in
                        match s with
                        | "" ->
                            print_endline "\nSetting up your board\n\n";
                            starting_board ()
                        | a ->
                            game.p1 <- a;
                            print_endline "\nSetting up your board\n\n";
                            starting_board ()))
                | "2" ->
                    AiLogic.set_ai false;
                    print_endline "What do you want Player 1's name to be? \n";
                    (match read_line () with
                    | "" -> ()
                    | exception End_of_file -> ()
                    | a -> game.p1 <- a);
                    print_endline "What do you want Player 2's name to be? \n";
                    (match read_line () with
                    | "" -> ()
                    | exception End_of_file -> ()
                    | a -> game.p2 <- a);
                    print_endline "\nSetting up your board\n\n";
                    starting_board ()
                | _ ->
                    print_endline "\nTake this seriously >:(\n\n";
                    prompt_game ())
              else print_endline "\nTake this seriously >:( \n\n";
              prompt_game ()
        end
      | "NO" | "N" ->
          print_endline "\nExiting game.\n\n";
          print_endline "\nGoodbye!\n\n";
          exit 0
      | _ -> prompt_game ())

let display_rules () =
  print_endline "\nHere are some quick rules:\n\n";
  print_endline "\n1) The game moves counter-clockwise.\n\n";
  print_endline "\n2) Each player takes a turn, beginning with player 1.\n\n";
  print_endline
    "\n3) On your turn, choose one of your pits to move stones from.\n\n";
  print_endline "\n4) If you end in your own store, go again.\n\n";
  print_endline
    "\n\
     5) If you end in your own pit, it is your opponent's turn, however, if \
     your pit was empty, you will collect the stones from your pit and the pit \
     opposite.\n\n\
     6) Game over when a player has no moves left. \n\n\
     7) Winner is whoever has the most stones in their store.\n";
  prompt_game ()

(** [main ()] prompts for the game to play, then starts it. *)
let rec main () =
  ANSITerminal.print_string [ ANSITerminal.red ] "\n\nWelcome to Mancala.\n";
  print_endline "By Passionately Unrelenting People (PUP)\n\n";
  print_endline "Do you want to see the rules? (Yes or No)\n";
  print_string "> ";
  match read_line () with
  | exception End_of_file -> ()
  | str -> (
      match String.uppercase_ascii str with
      | "YES" | "Y" -> display_rules ()
      | "NO" | "N" -> prompt_game ()
      | _ -> main ())

(* Execute the game engine. *)
let () = main ()
