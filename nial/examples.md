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


**Booleans etc**

Create 50 random numbers in the range [0,1).

         r := random 50
		 
    0.726391 0.448169 0.384064 0.961273 0.123186 0.384953 0.911016 0.44919 0.536883
    0.385413 0.639681 0.119586 0.882235 0.72909 0.810901 0.819432 0.193461 0.498833 
    0.880408 0.00925989 0.631015 0.476912 0.455139 0.52156 0.851008 0.893033 0.210305 
	0.603614 0.940779 0.672059 0.289858 0.645433 0.799226 0.597586 0.632906 0.24416 
	0.600288 0.0355598 0.653786 0.175224 0.98553 0.794918 0.184277 0.141942 0.623868 
	0.344969 0.892283 0.599387 0.898681 0.127729

Which are less that 0.5? I.e. get a boolean array

        r < 0.5
		
    ollollolololoooollololloooloooloooolololoolloloool

Then pick out those numbers using the boolean array

        (r < 0.5) sublist r
		
    0.448169 0.384064 0.123186 0.384953 0.44919 0.385413 0.119586 0.193461 0.498833 
    0.00925989 0.476912 0.455139 0.210305 0.289858 0.24416 0.0355598 0.175224 0.184277 
	0.141942 0.344969 0.127729

In the above we mentioned *r* twice. We can avoid that

	    sublist [0.5>=,pass] r
		
    0.448169 0.384064 0.123186 0.384953 0.44919 0.385413 0.119586 0.193461 0.498833 
    0.00925989 0.476912 0.455139 0.210305 0.289858 0.24416 0.0355598 0.175224 0.184277 
	0.141942 0.344969 0.127729

To explain, the construction *[0.5>=,pass]* is called an atlas, an array of operators/functions. In Nial
the form *[f,g]x* is equivalent to *[f x,g x]*. The form *0.5>=* is Nial's currying, reducing the operator
*>=* which expects two arguments to a single argument operator. The operator *pass* is the identity 
operator *x = pass x*. Finally the complete form *sublist[0.5>=,pass]*
is just function composition i.e. *f g x* is the same as *f (g x)*. The last thing to mention is Nial
doesn't really have dyadic operators, its just syntactic sugar and *x f y* is the same as *f[x,y]*. 
