let buf = Queue.create ();;

let readfile filename buffer =
  let rec print_all_lines in_chan =
    Queue.add (input_line in_chan) buffer;
    print_all_lines in_chan
  in
  let in_file = open_in filename
in
try 
  print_all_lines in_file
with End_of_file -> close_in in_file;;

readfile "input.txt" buf;;

let nums = Array.of_list (String.split_on_char ',' (Queue.take buf));; 
(Queue.take buf);;

let grids = ref (Array.make 0 (Array.make_matrix 5 5 "+"));;
let grid = ref (Array.make_matrix 5 5 "+");;

let i = ref 0 in
while (Queue.is_empty buf) == false
do
  let line = (Queue.take buf) in
  if (String.length line) == 0
  then begin
    grids := Array.append !grids (Array.make 1 !grid);
    grid := Array.make_matrix 5 5 " ";
    i := 0;
  end
  else begin
    let re = Str.regexp " +" in
    let fline = Str.global_replace re ";" (String.trim line) in
    !grid.(!i) <- Array.of_list (String.split_on_char ';' fline);
    i := !i + 1;
  end
done;;

exception Found;;
let result = ref 0 in
try
for num_i = 0 to (Array.length nums) - 1 do
  let num = nums.(num_i) in
  for g = 0 to (Array.length !grids) - 1 do
    for y = 0 to 4 do
      for x = 0 to 4 do
        let cell = !grids.(g).(y).(x) in
        if String.equal cell num then begin
          !grids.(g).(y).(x) <- String.concat "-" ["";cell];
        end;

        let lineChecks = ref true in
        for xl = 0 to 4 do
          if (String.get !grids.(g).(y).(xl) 0) != '-' then begin 
            lineChecks := false;
          end;
        done;

        let colsChecks = ref true in
        for yl = 0 to 4 do
          if (String.get !grids.(g).(yl).(x) 0) != '-' then begin 
            colsChecks := false;
          end;
        done;

        if !lineChecks || !colsChecks then begin
          for xl = 0 to 4 do
            for yl = 0 to 4 do
              if (String.get !grids.(g).(yl).(xl) 0) != '-' then begin
                let num = Int.abs (Stdlib.int_of_string !grids.(g).(yl).(xl)) in
                result := !result + num;
              end;
            done;
          done;
          result := (Stdlib.int_of_string num) * !result;
          raise Found
        end;
      done;
    done;
  done;
done;
with Found ->
  print_string "Part 1 : ";
  print_int !result;
  print_endline "";
;;

let winners = ref (List.init 0 (fun _ -> 0)) in
let result = ref 0 in
try
for num_i = 0 to (Array.length nums) - 1 do
  let num = nums.(num_i) in
  for g = 0 to (Array.length !grids) - 1 do
    for y = 0 to 4 do
      for x = 0 to 4 do
        let cell = !grids.(g).(y).(x) in
        if String.equal cell num then begin
          !grids.(g).(y).(x) <- String.concat "-" ["";cell];
        end;

        let lineChecks = ref true in
        for xl = 0 to 4 do
          if (String.get !grids.(g).(y).(xl) 0) != '-' then begin 
            lineChecks := false;
          end;
        done;

        let colsChecks = ref true in
        for yl = 0 to 4 do
          if (String.get !grids.(g).(yl).(x) 0) != '-' then begin 
            colsChecks := false;
          end;
        done;

        if !lineChecks || !colsChecks then begin
          try
            let _ = List.find (fun n -> n = g) !winners in ();
          with Not_found -> begin
            winners := List.append !winners [g];
            if (Array.length !grids) == (List.length !winners) then begin
              for xl = 0 to 4 do
                for yl = 0 to 4 do
                  if (String.get !grids.(g).(yl).(xl) 0) != '-' then begin
                    let n = Int.abs (Stdlib.int_of_string !grids.(g).(yl).(xl)) in
                    result := !result + n;
                  end;
                done;
              done;
              result := (Stdlib.int_of_string num) * !result;
              raise Found;
            end;
          end;
        end;
      done;
    done;
  done;
done;
with Found ->
  print_string "Part 2 : ";
  print_int !result;
  print_endline "";
;;