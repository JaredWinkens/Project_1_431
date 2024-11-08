open Eio;;

(* A task type with a priority and a work function *)
type 'a task = { priority: int; work: unit -> 'a }

(* A simple priority queue using a list *)
module TaskQueue = struct
  let create () : 'a task list ref = ref []

  let add (queue: 'a task list ref) (task: 'a task) =
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
let rec worker_loop (queue: 'a task list ref) clock =
  match TaskQueue.pop queue with
  | None ->
      Eio.Fiber.yield ();  (* Yield and wait for tasks *)
      worker_loop queue clock
  | Some task ->
      task.work ();  (* Execute the task *)
      worker_loop queue clock

(* Function to start worker fibers *)
let scheduler env num_workers =
  let queue = TaskQueue.create () in
  Switch.run (fun sw ->
    for _ = 1 to num_workers do
      Fiber.fork ~sw (fun () -> worker_loop queue env#clock) (* Pass clock to worker *)
  done;
  queue)

(* Function to submit tasks *)
let submit_task queue task =
  TaskQueue.add queue task
(*Jared*)

(* Example usage *)
let () =
  Eio_linux.run (fun env ->
    let queue = scheduler env 4 in  (* Start scheduler with 4 worker fibers *)

    (* Submit some tasks *)
    for i = 1 to 10 do
      let task = {
        priority = Random.int 10;  (* Random priority between 0 and 9 *)
        work = (fun () ->
          Printf.printf "Executing task with priority %d\n" i;
          Eio.Time.sleep env#clock (Random.float 1.0) )  (* Simulate work *)
      } in
      submit_task queue task;
    done;
    Eio.Time.sleep env#clock 2.0;  (* Wait for a moment to let tasks complete *)
    Printf.printf "All tasks submitted.\n"
  )
  (*Aiden*)
