preresolve
==========

Calls `require.resolve` on all the string literals given to
require in a source file, and outputs a new source file, so that when
you are starting your program, this work doesn't have to be done, and 
time is saved.

The amount you save by doing this will vary widely depending on the 
nature of the modules you are using and the performance characteristics of 
the platform you are running on, but under normal circumstances, this seems
to result in ~10% improvement in startup time.

Also see https://github.com/650Industries/gulp-preresolve if you want
to incorporate this into your build script flow.

