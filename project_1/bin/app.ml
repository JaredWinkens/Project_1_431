open Eio.Std;;

(* Define a task type with a priority and a work function *)
type 'a task = { priority: int; work: unit -> 'a }

(* Define a simple priority queue using a list *)
module TaskQueue = struct
  type 'a t = 'a task list ref

  let create () = ref []

  let add queue task =
    queue := List.sort (fun t1 t2 -> compare t2.priority t1.priority) (task :: !queue)

  let pop queue =
    match !queue with
    | [] -> None
    | task :: rest ->
        queue := rest;
        Some task
end
(*Sawyer*)


