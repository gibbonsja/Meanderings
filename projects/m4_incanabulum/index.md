---
title: M4 J Incanabulum
---

This is a rewrite of Arthur Whitney's J Incanabulum using the 
GNU *m4* macro-processor rather than the original C macros.

The source is in the file [ji.m4](./ji.m4), the m4 macros is 
in [im.m4](./im.m4) and there is a 
small [makefile](./makefile) that currently uses *gcc* but
can also use the *clang* compiler.

It currently compiles without warnings and runs with the 
following limitations.

- only integer values are supported
- integers and pointers must have the same size
- variables are the letters *a* thru *z* and assignment is *=* 
- evaluation is right to left
- no error handling
- no memory management
- functions are limited to the following table
- arrays have a maximum rank of 3
- missing functions will crash the program (monadic *,* and dyadic *<*)

| Char | Monadic | Dyadic |
| ---- | ------- | ------ |
| +    | id      | plus   |
| {    | size    | from   |
| ~    | iota    | find   |
| <    | box     |        |
| #    | shape   | reshape|
| ,    |         | cat    |

Despite its limitations it is a cute little system to extend and play with ideas. 

A small session transcript:

    >m=3
    3 
    >m=m,3
    3 3 
    >t=~9
    0 1 2 3 4 5 6 7 8 
    >y=m#t
    0 1 2 3 4 5 6 7 8 
    >#m
    2 
    >#y
    3 3 
    >1{y
    3 4 5 
    >0{y
    0 1 2 
    >2{y
    6 7 8 
    >u=1{y
    3 4 5 
    >v=2{y
    6 7 8 
    >u+v
    9 11 13 

