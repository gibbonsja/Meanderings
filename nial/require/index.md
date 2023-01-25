---
title: Require
---

[**require.ndf**](require.ndf) is a wrapper around *loaddefs* that 
provides a function 
*_require*, with the same signature as *loaddefs* that avoids reloading 
a file if it has already been loaded before. If you really do need to 
reload that file you can just use *loaddefs*.

When *require.ndf* is first loaded it sets up its environment. Subsequent
loads of *require.ndf* will not change that environment.

The full pathnames of already successfully loaded files 
are cached in a hash table
and a subsequent require call will check the table to see if the file
is already loaded.

The function call *_require fn [flag]* is identical to that of *loaddefs*.
For simplicity the name *require* is aliased to *_require*.

The expression *_required_files* will give a list of the full pathnames
of the files successfully loaded by *_require*

The environment variable *NIAL_LIBPATH* if present is assumed to contain a 
*:* (*;* for Windows) separated list of directories to search 
along with the current directory and the standard *Nialroot* 
subdirectory *niallib*. 
