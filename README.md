# cream
Concurrent Runtime Environment And Modules

This is a project that builds upon schedlua to create a simple 
runtime environment that leverages lua co-routines for concurrent
program execution.  This is very similar to TINN, but is focused
on Linux in this case.

cream uses ljsyscall to gain portability across multiple versions
of *NIX
