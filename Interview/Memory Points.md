1. Threads - 
- A thread is the smallest unit of execution within a process . It represents a sequence of instructions that the CPU executes. Threads are managed by the operating system and can run concurrently, and on multi-core systems, they can run in parallel.

2. Process - A program instance which has its own memory

3. Stack - A stack is a memory structure that follows the Last-In-First-Out principle and is used to manage function calls and local variables during execution. Each thread has its own call stack, which keeps track of the execution context of functions.

4. Synchronous- Synchronous execution means tasks are executed sequentially, where each operation must complete before the next one starts, so it blocks the execution flow.

5. Asynchronous- Asynchronous execution, on the other hand, allows tasks to run in a non-blocking way. Instead of waiting, operations like API calls are handled in the background and their results are processed later using callbacks, promises, or async/await.
 - In JavaScript, this is managed by the event loop, which takes completed async tasks from queues and pushes them back to the call stack.

6. If JavaScript is single-threaded, how does it handle asynchronous operations?
- JavaScript is single-threaded, so it uses the event loop to handle asynchronous operations. When an async task like a network request or a timer is triggered, it is delegated to browser APIs or Node.js APIs, which run outside the main thread.
- Once the operation is completed, its callback is placed into a queue, such as the callback queue or microtask queue. The event loop continuously checks the call stack, and when it is empty, it pushes the queued callbacks back onto the stack for execution.

7. Difference between callback queue and microtask queue?
- The callback queue, also known as the macrotask queue, holds tasks like setTimeout, setInterval, and I/O operations. The microtask queue holds higher priority tasks such as Promise callbacks. The event loop always processes all microtasks before taking tasks from the callback queue, which is why Promise callbacks execute before setTimeout even if the delay is zero.”

8. What is the role of the event loop in JavaScript?
- The event loop is a mechanism in the JavaScript runtime that enables asynchronous, non-blocking behavior despite JavaScript being single-threaded.
- It continuously checks the call stack, and when the stack is empty, it takes tasks from the microtask queue or callback queue and pushes them onto the stack for execution.
- This allows JavaScript to handle operations like API calls and timers without blocking the main execution thread.

9. What happens if the call stack never becomes empty?
- If the call stack never becomes empty, the event loop cannot process tasks from the queues, which means asynchronous operations like timers and promises will never execute. This can happen in cases like infinite loops, where the main thread is continuously occupied.

10. What is the difference between blocking and non-blocking code?
- “Blocking code is code that halts the execution of the program until the current operation completes, meaning the thread is occupied and cannot proceed to the next task.
- Non-blocking code, on the other hand, allows the program to continue executing other tasks without waiting for the current operation to finish. In JavaScript, this is typically achieved using asynchronous mechanisms like callbacks, promises, or async/await, where the operation is handled in the background and resumed later via the event loop.