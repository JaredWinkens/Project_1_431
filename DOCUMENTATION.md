# Concurrent Task Scheduler
**Overview**: The application will act as a task scheduler, where multiple tasks can be submitted and processed concurrently. Tasks could be executed with different priorities, and the scheduler will manage them using data structures like priority queues and a worker pool.

## Core Components:

**Priority Queue:** A priority queue to hold tasks. Higher-priority tasks are executed before lower-priority ones.

**Worker Pool:** A pool of worker threads (or fibers) that will pick tasks from the queue and process them concurrently.

**Task Submission Interface:** A function to submit new tasks, assigning them a priority. This could involve several clients submitting tasks simultaneously.

**Task Processing:** Workers will concurrently execute tasks.

**Concurrency Management:** Uses Eio's concurrency primitives to manage tasks, ensuring proper synchronization and avoiding race conditions.

## Setup:

**Initialize dune project**

`dune init <project_name>`

**Add Dependencies:** In your dune file, add the necessary dependencies, including eio. You might also want to add base for easier list and queue management.

```
(executable
  (name <project_name>)
  (libraries eio base))
```

## Code

**Task Definition:** The `task` type contains a priority and a work function that represents the task to be executed.

**Task Queue:** The `TaskQueue` module is a simple priority queue implemented using a list. When adding a task, the list is sorted based on the priority (higher values have higher priority).

**Worker Loop:** The `worker_loop` function processes tasks from the queue. If the queue is empty, it yields and waits for new tasks. When a task is available, it executes it and continues.

**Scheduler Function:** The `scheduler` function initializes the task queue and forks a specified number of worker fibers to process tasks concurrently.

**Task Submission:** The `task_submit` function adds tasks to the task queue.

**Main Function:** ...

## Running the App

1. Make sure you have `Eio` installed in your OCaml environment.

2. Create a new project as described and add the provided code in `app.ml`.

3. Run the project using Dune:

  ```
  dune build
  dune exec ./app.exe
  ```