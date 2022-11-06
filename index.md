---
title: "Some Personal Meanderings, mostly on Nial" 
---

Nial (Nested Interactive Array Language) is an array language created by Michael Jenkins, at
Queens University Toronto, based on the Array Theory of Trenchard More (IBM). Both were members of the
early APL community.

Nial was first released in 1982, 4 years after the release of the first publicly available version of
APL.
The current version of Nial, QNial7, is an evolution from that C coded version and is hosted on Github.
It is released
under a GPL3 licence. For details go to [Nial Website](https://nial-array-language.org).

There is also an evolving Web Assembly version available
at [Nial WASM](https://niallang.github.io/NIAL_WASM).

Some simple examples of Nial are

**Array Manipulation**

Create a 3 dimensional array of the numbers 1 to 24 

    x := 2 3 4 reshape count 24

    1  2  3  4   13 14 15 16
    5  6  7  8   17 18 19 20
    9 10 11 12   21 22 23 24

Sum all the entries of that array

    +x
    300
    
Turn that array into a 2 element vector of 3 by 4 arrays

     1 raise x

    +----------+-----------+
    |1  2  3  4|13 14 15 16|
    |5  6  7  8|17 18 19 20|
    |9 10 11 12|21 22 23 24|
    +----------+-----------+

Then sum the top level elements of that

    + (1 raise x)

    14 16 18 20   
    22 24 26 28
    30 32 34 36
    

     



