---
title: "16 Expressions in Nial"
---

This is a translation, and homage, of Roger Hui's *APL in 16 Expressions* into Nial.

# 0. Array Logic

        x := 5 -2.7 0 6
    5 -2.7 0 6


        (x>0)-(x<0)         % if x > 0 then 1 elseif x<0 then -1 else 0 end;
    1 -1 0 1

        (x>0)-(x<0)*x       % if x >= 0 then x else  opposite x end;
    5 2.7 0 6

- Boolean functions have true(l) and false(o) and are packed bits. In arithmetic
   expressions they are 1 and 0
- Functions apply to entire arrays, as in, for example, +(x>100) to compute the
   number of elements of vector x greater than 100 .
- A simple function precedence (“left to right”).



# 1. On Average

         avg is /[+,tally]
     
         x := floor (10*random 20)
    7 4 3 9 1 3 9 4 5 3 6 1 8 7 8 8 1 4 8 0

        avg x
    4.95



2. Index-Of Selfie

Dyalog APL has multiple meanings for iota (⍳) depending on the arguments in both the
monadic and dyadic contexts.

For this section the closest definition is

    index_of is eachleft find [1 raise first, 1 raise second]

-  nub (unique)

    ((x index_of x) eachboth = tell shape x) sublist x

-  an efficient alternative to *x inner [and,=] transpose y* for two arrays x and y

    (x index_of x) outer = (y index_of x)

-  an efficient computation for *x outer match y* for non-simple vector x

    (x index_of x) outer = (y index_of x)

-  equivalent to x bykeys f y

    (x index_of x) bykeys f y		