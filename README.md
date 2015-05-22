# cream
Concurrent Runtime Environment And Modules

This is a project that builds upon schedlua to create a simple 
runtime environment that leverages lua co-routines for concurrent
program execution.  This is very similar to TINN, but is focused
on Linux in this case.

There are several modules pulled in from various other projects.
The largest of these is probably the ljsyscall functions.  This is
used to gain portability across multiple flavors of *NIX where
that matters.

In addition, there are other modules such as serpent, fun, dkjson,
reflect, and the like which are pulled in for their convenience in
one form or another performing some specific useful task.

