# WorkerThreadPool

Inherits: Object

A singleton that allocates some Threads on startup, used to offload tasks to these threads.

## Description

The WorkerThreadPool singleton allocates a set of Threads (called worker threads) on project startup and provides methods for offloading tasks to them. This can be used for simple multithreading without having to create Threads.

Tasks hold the Callable to be run by the threads. WorkerThreadPool can be used to create regular tasks, which will be taken by one worker thread, or group tasks, which can be distributed between multiple worker threads. Group tasks execute the Callable multiple times, which makes them useful for iterating over a lot of elements, such as the enemies in an arena.

Here's a sample on how to offload an expensive function to worker threads:

```
var enemies = [] # An array to be filled with enemies.
func process_enemy_ai(enemy_index):
    var processed_enemy = enemies[enemy_index]
    # Expensive logic...
func _process(delta):
    var task_id = WorkerThreadPool.add_group_task(process_enemy_ai, enemies.size())
    # Other code...
    WorkerThreadPool.wait_for_group_task_completion(task_id)
    # Other code that depends on the enemy AI already being processed.
```

```
private List _enemies = new List(); // A list to be filled with enemies.
private void ProcessEnemyAI(int enemyIndex)
{
    Node processedEnemy = _enemies[enemyIndex];
    // Expensive logic here.
}
public override void _Process(double delta)
{
    long taskId = WorkerThreadPool.AddGroupTask(Callable.From(ProcessEnemyAI), _enemies.Count);
    // Other code...
    WorkerThreadPool.WaitForGroupTaskCompletion(taskId);
    // Other code that depends on the enemy AI already being processed.
}
```

The above code relies on the number of elements in the enemies array remaining constant during the multithreaded part.

Note: Using this singleton could affect performance negatively if the task being distributed between threads is not computationally expensive.

## Tutorials

- Using multiple threads
- Thread-safe APIs

## Methods

int | add_group_task(action: Callable, elements: int, tasks_needed: int = -1, high_priority: bool = false, description: String = "")
int | add_task(action: Callable, high_priority: bool = false, description: String = "")
int | get_caller_group_id() const
int | get_caller_task_id() const
int | get_group_processed_element_count(group_id: int) const
bool | is_group_task_completed(group_id: int) const
bool | is_task_completed(task_id: int) const
void | wait_for_group_task_completion(group_id: int)
Error | wait_for_task_completion(task_id: int)

---

## Method Descriptions

int add_group_task(action: Callable, elements: int, tasks_needed: int = -1, high_priority: bool = false, description: String = "") 

Adds action as a group task to be executed by the worker threads. The Callable will be called a number of times based on elements, with the first thread calling it with the value 0 as a parameter, and each consecutive execution incrementing this value by 1 until it reaches element - 1.

The number of threads the task is distributed to is defined by tasks_needed, where the default value -1 means it is distributed to all worker threads. high_priority determines if the task has a high priority or a low priority (default). You can optionally provide a description to help with debugging.

Returns a group task ID that can be used by other methods.

Warning: Every task must be waited for completion using wait_for_task_completion() or wait_for_group_task_completion() at some point so that any allocated resources inside the task can be cleaned up.

---

int add_task(action: Callable, high_priority: bool = false, description: String = "") 

Adds action as a task to be executed by a worker thread. high_priority determines if the task has a high priority or a low priority (default). You can optionally provide a description to help with debugging.

Returns a task ID that can be used by other methods.

Warning: Every task must be waited for completion using wait_for_task_completion() or wait_for_group_task_completion() at some point so that any allocated resources inside the task can be cleaned up.

---

int get_caller_group_id() const 

Returns the task group ID of the current thread calling this method, or -1 if invalid or the current thread is not part of a task group.

---

int get_caller_task_id() const 

Returns the task ID of the current thread calling this method, or -1 if the task is a group task, invalid or the current thread is not part of the thread pool (e.g. the main thread).

Can be used by a task to get its own task ID, or to determine whether the current code is running inside the worker thread pool.

Note: Group tasks have their own IDs, so this method will return -1 for group tasks.

---

int get_group_processed_element_count(group_id: int) const 

Returns how many times the Callable of the group task with the given ID has already been executed by the worker threads.

Note: If a thread has started executing the Callable but is yet to finish, it won't be counted.

---

bool is_group_task_completed(group_id: int) const 

Returns true if the group task with the given ID is completed.

Note: You should only call this method between adding the group task and awaiting its completion.

---

bool is_task_completed(task_id: int) const 

Returns true if the task with the given ID is completed.

Note: You should only call this method between adding the task and awaiting its completion.

---

void wait_for_group_task_completion(group_id: int) 

Pauses the thread that calls this method until the group task with the given ID is completed.

---

Error wait_for_task_completion(task_id: int) 

Pauses the thread that calls this method until the task with the given ID is completed.

Returns @GlobalScope.OK if the task could be successfully awaited.

Returns @GlobalScope.ERR_INVALID_PARAMETER if a task with the passed ID does not exist (maybe because it was already awaited and disposed of).

Returns @GlobalScope.ERR_BUSY if the call is made from another running task and, due to task scheduling, there's potential for deadlocking (e.g., the task to await may be at a lower level in the call stack and therefore can't progress). This is an advanced situation that should only matter when some tasks depend on others (in the current implementation, the tricky case is a task trying to wait on an older one).
