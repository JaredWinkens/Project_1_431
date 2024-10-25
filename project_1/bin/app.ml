open Eio

(* Task type with priority and action *)
type task = {
  priority : int;
  action : unit -> unit;
}

(* Priority Queue implemented as a sorted list *)
module TaskPriorityQueue = struct
  type t = task list ref

  let create () : t = ref []

  (* Insert task by maintaining sorted order (higher priority first) *)
  let add_task queue task =
    let rec insert sorted = function
      | [] -> List.rev_append sorted [task]
      | h :: t as rest ->
        if task.priority > h.priority then
          List.rev_append sorted (task :: rest)
        else
          insert (h :: sorted) t
    in
    queue := insert [] !queue

  let pop_task queue =
    match !queue with
    | [] -> None
    | h :: t ->
        queue := t;
        Some h
end
