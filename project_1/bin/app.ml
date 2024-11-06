open Eio.Std;;

(* A task type with a priority and a work function *)
type 'a task = { priority: int; work: unit -> 'a }

(* A simple priority queue using a list *)
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

(* Function to process tasks from the queue *)
let rec worker_loop (queue: unit TaskQueue.t) =
  match TaskQueue.pop queue with
  | None ->
      Eio.Fiber.yield ();  (* Yield and wait for tasks *)
      worker_loop queue
  | Some task ->
      task.work ();  (* Execute the task *)
      worker_loop queue

(* Function to start worker fibers *)
let scheduler num_workers =
  let queue = TaskQueue.create () in
  Switch.run (fun sw ->
    for _ = 1 to num_workers do
      Fiber.fork ~sw (fun () -> worker_loop queue)
  done;
  queue)

(* Function to submit tasks *)
let submit_task queue task =
  TaskQueue.add queue task
(*Jared*)


