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
