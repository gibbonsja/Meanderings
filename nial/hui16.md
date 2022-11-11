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