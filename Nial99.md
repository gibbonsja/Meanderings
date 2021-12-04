# Nial version of K-99

This document gives some Nial versions of the [Ninety-Nine Prolog Problems](https://sites.google.com/site/prologsite/prolog-problems).

## Problem 1

Find the last element of a list.

    last "abcdef"
    "f"

### Solution

    last1 is last                             # Builtin
    last2 is op x ((-1 + tally x) pick x)     # Array indexing
    last2 is pick [-1 + tally, pass]          # Using an atlas, currying  and function composition
    last3 is op x (if 1 = tally x then first x else last3 rest x end)    # recursion
    last4 is first (-1 take)                  # function composition and currying


## Problem 2

Find the last but one element of a list.

### Example
 
    butlast "abcdef"
    "e"
 

### Solution

    butlast1 is 1 pick reverse                # Reverse list and pick 2nd element
    butlast2 is op x ((-2 + tally x) pick x)  # Defining a function/operator
    butlast2 is pick [-2 + tally, pass]       # atlas, composition and currying
    butlast3 is op x (if 2 = tally x then first x else butlast3 rest x end) # recursion
    butlast4 is first (-2 rotate)             # alternate to reverse

## Problem 3

Find the K'th element of a list.

### Example
 
    elementat["abcdef";3]
    "c"
 
### Solution

    elementat1 is op x y ((y - 1) pick x)
    elementat1 is converse pick [first, -1 + second]
    elementat2 is first ((y - 1) drop)
    elementat3 is op x y (if y = 1 then first x else elementat3 (rest x) (y - 1) end)

## Problem 4

Find the number of elements of a list.

### Example
 
    length 1 2 3 4
    4
 
### Solution

    length1 is tally
    length2 is + each (1 first)   # note: (1 first x) is the same as (first [1,x]) 
	length3 is op x (if empty x then 0 else 1 + length3 rest x end)
    
## Problem 5

Reverse a list.

### Example
 
    reverse "abcdef"
    "fedcba"
 
### Solution

    reverse1 is reverse                                    # builtin
    reverse2 is choose [-[-1 + tally, tell tally], pass]   # nested atlas, composition and currying
    reverse3 is op x (if 1 = tally x then x else (reverse3 rest x) link 1 take x end)

## Problem 6

Find out whether a list is a palindrome.

### Example
 
    ispalindrome "aacbcaa"
    1
 

### Solution

    ispalindrome is =[pass,reverse]
 

## Problem 7

Flatten a nested list structure.

### Example
 
    flatten ((1;2 3);(4;(5;(6;7)));8)
    1 2 3 4 5 6 7 8
 

### Nial Solution

    flatten1 is content
    flatten2 is op x (while x ~= (t := link x) do x := t end)


## Problem 8

Eliminate consecutive duplicates of list elements.

### Example
 
    compress "aaaabccaadeeee"
    "abcade"
 

### K Solution
 
    compress : {x@&1,~=':x}
    range : ?    / built in operator
 

### Nial Solution

This and a few subsequent problems use a common core function which uses
cutall to partition a list using a mask formed by comparing adjacent items. 

    runs is cutall [not match [hitch [first, front], pass]  # atlas&composition

then

    compress is each first runs


## Problem 9

Pack consecutive duplicates of list elements into sublists.

### Example
 
    pack "aaaabccaadeeee"
    ("aaaa"
    ,"b"
    "cc"
    "aa"
    ,"d"
    "eeee")
 
    pack: {(&1,~=':x)_ x}

### Nial Solution

    pack is runs          
 

## Problem 10

Run-length encoding of a list.

### Example
 
    encode "aaaabccaadeeee"
    ((4;"a")
    (1;"b")
    (2;"c")
    (2;"a")
    (1;"d")
    (4;"e"))
 

### Solution

    encode is each [tally, first] runs
 

## Problem 11

Modified run-length encoding.

### Example
 
    encodemod "aaaabccaadeeee"
    ((4;"a")
    ,"b"
    (2;"c")
    (2;"a")
    ,"d"
    (4;"e"))
 

### K Solution
 
    encodemod: {{:[1=l:#x;x;l,?x]}'pack x}
 
### Nial Solution

    encodemod is each (op x (if 1 = tally x then x else [tally,first] x end)) runs 

## Problem 12

Decode a run-length encoded list.

### Example
 
    decodemod ((4;"a");"b";(2;"c");(2;"a");"d";(4;"e"))
    "aaaabccaadeeee"
 

### Solution
 
    decodemod is link each (op x (if 2 = tally x then reshape x else x end)
 

## Problem 13

Run-length encoding of a list (direct solution).
Don't explicitly create the sublists containing the duplicates, only count them.

### Example
 
  encodedir "aaaabccaadeeee"
((4;"a")
 ,"b"
 (2;"c")
 (2;"a")
 ,"d"
 (4;"e"))
 

### Solution
 
encodedir: {(-':a,#x),'x@a:&1,~=':x}
 

## Problem 14
Duplicate the elements of a list.

### Example
 
  dupl "abccd"
"aabbccccdd"
 

### Solution
 
dupl : ,/2#'
dupl2: ,/{x,x}'
 

## Problem 15
Duplicate the elements of a list a given number of times.

### Example
 
  repl["abccd";3]
"aaabbbccccccddd"
 

### Solution
 
repl: {,/y#'x}
 

## Problem 16
Drop every N'th element from a list.

### Example
 
  dropevery["abcdefghij";3]
"abdeghj"
 

### Solution
 
dropevery : {x@&~(#x)#((y-1)#0),1}
dropevery2: {x _di-1+y*1+!(#x)%y}
 

## Problem 17
Split a list into two parts; the length of the first part is given.<br />
Do not use any predefined predicates.

### Example
 
  split["abcdefghij";3]
("abc"
 "defghij")
 

### Solution
 
split : {(y#x;y _ x)}
split2: {(0,y)_ x}
split3: {(x@!y;x@y+!(#x)-y)}
 

## Problem 18
Extract a slice from a list.

### Example
 
  slice["abcdefghij";3;7]
"cdef"
 

### Solution
 
slice : {(y-1)_(z-1)#x}
slice2: {x@(y-1)+!z-y}
 

## Problem 19
Rotate a list N places to the left.

### Example
 
  rotate["abcdefghij";3]
"defghijabc"
 

### Solution
 
rotate : {y!x}
rotate2: {,/(y>0)|:/split[x;y]}
 

## Problem 20
Remove the K'th element from a list.

### Example
 
  removeat["abcdef";3]
("c"
 "abdef")
 

### Solution
 
removeat : {(x@y;x _di y:y-1)}
removeat2: {(x@i;x@&~x=x@i:y-1)}
 

## Problem 21
Insert an element at a given position into a list.

### Example
 
  insert["abcd";2;"alfa"]
("a"
 "alfa"
 "b"
 "c"
 "d")
 

### Solution
 
insert : {(l#x),(,z),(l:y-1)_ x}
insert2: {(*s),(,z),,/1_ s:split[x;y]}
insert3: {{x,(,z),y}/split[x;y]}
insert4: {:[y=1;(,z),x;(*x),_f[1_ x;y-1;z]]}
 

## Problem 22
Create a list containing all integers within a given range.

### Example
 
  range[3;7]
3 4 5 6 7
  range[9;3]
9 8 7 6 5 4 3
 

### Solution
 
range: {x+:[0>y-x;-1;1]*!1+_abs y-x}
range: {:[x>y;|y+!x-y-1;x+!y-x-1]}
 

## Problem 23
Extract a given number of randomly selected elements from a list.

### Example
 
  rndselect["abcdefgh";3]
"bfe"
 

### Solution
 
rndselect: {x@(-y)?#x}
 

## Problem 24
Lotto: Draw N different random numbers from the set 1..M.

### Example
 
  lotto[6;49]
12 34 15 31 29 22
 

### Solution
 
lotto : {(-x)?y}
lotto2: {x _draw -y}
 

## Problem 25
Generate a random permutation of the elements of a list.

### Example
 
  rndperm["abcdef"]
"efbadc"
 

### Solution
 
rndperm: {x@(-l)?l:#x}
 

## Problem 26
Generate the combinations of K distinct objects chosen from the N elements of a list.

### Example
 
  combin["abcdef";3]
("abc"
 "abd"
 "abe"
 "abf"
 ...
 "def")
 

### Solution
 
combin: {x@&lt;x:x@{&:'y(?,/(1!)\'1,')/,&x-y}[#x;y]}
 

## Problem 27 (Incomplete)
Group the elements of a set into disjoint subsets.

### Example
 
  list:("aldo";"beat";"carla";"david";"evi";"flip";"gary";"hugo";"ida")
  group[list;3]
(("evi"
  "flip"
  "ida")
 ("evi"
  "flip"
  "gary")
 ...)
 

### Solution
 
group: {combin[x;]'y}
 

## Problem 28
### a)
Sorting a list of lists according to length of sublists.

### Example
 
  lsort[("abc";"de";"fgh";"de";"ijkl";"mn";"o")]
("o"
 "de"
 "de"
 "mn"
 "abc"
 "fgh"
 "ijkl")
 

### Solution
 
lsort: {x@&lt;#:'x}
 

### b)
Sorting a list of lists according to length frequency of sublists.

### Example
 
  lfsort[("abc";"de";"fgh";"de";"ijkl";"mn";"o")]
("ijkl"
 "o"
 "abc"
 "fgh"
 "de"
 "de"
 "mn")
 

### Solution
 
lfsort: {x@,/f@&lt;f:=#:'x}
 




## Problem 29 (2.01)
Determine whether a given integer number is prime.

### Example
 
  isprime ' 0 1 2 4 5
0 0 1 0 1
 

### Solution
 
isprime: {2~#&~x!'!1+x}
 

## Problem 30 (2.02)
Determine the prime factors of a given positive integer.

### Example
 
  primefactors 315
3 3 5 7
 

### Solution
 
primefactors: {{y%x}':({x>1}{x%*{1_ &~(x!)'!1+x}x}\x)}
 

## Problem 31 (2.03)
Construct a list containing the prime factors and their multiplicity.

### Example
 
  multiplicity 315
(2 3
 1 5
 1 7)
 

### Solution
 
multiplicity: {encode primefactors x}
 

## Problem 32 (2.04)
Given a range of integers by its lower and upper limit, construct a list of all prime numbers in that range.

### Example
 
  primes[2;25]
2 3 5 7 11 13 17 19 23
 

### Solution
 
primes: {x+&isprime'x+!1+y-x}
 

## Problem 33 (2.05)
Goldbach's conjecture says that every positive even number greater than 2 is the sum of two prime numbers. Example: 28 = 5 + 23. It is one of the most famous facts in number theory that has not been proved to be correct in the general case. Find the two prime numbers that sum up to a given even integer.

### Example
 
  goldbach 28
5 23
 

### Solution
 
ppairs:   {,/t,/:\:t:primes[2;x]}
goldbach: {*t@&{x=+/y}[x]'t:ppairs[x]}
 

## Problem 34 (2.06)
Given a range of integers by its lower and upper limit, print a list of all even numbers and their Goldbach composition.

### Example
 
  goldbachc[9;20]
(10 3 7
 12 5 7
 14 3 11
 16 3 13
 18 5 13
 20 3 17)
 

### Solution
 
evens:     {2*((x+1)%2)+!(1+y-x)%2}
goldbachc: {{x,goldbach x}'evens[x;y]}
 

## Problem 35 (2.07)
Determine the greatest common divisor of two positive integer numbers.

### Example
 
  gcd[36;63]
9
 

### Solution
 
gcd: {:[y;_f[y;x!y];x]}
 

## Problem 36 (2.08)
Determine whether two positive integer numbers are coprime.
Two numbers are coprime if their greatest common divisor equals 1.

### Example
 
  coprime[35;64]
1
  coprime[35;63]
0
 

### Solution
 
coprime: {1=gcd[x;y]}
 

## Problem 37 (2.09)
Calculate Euler's totient function phi(m).
Euler's so-called totient function phi(m) is defined as the number of positive integers r (1 <= r < m) that are coprime to m.

### Example
 
  phi 10
4
 

### Solution
 
phi: {+/coprime[x]'!x}
 

## Problem 38 (2.10)
Calculate Euler's totient function phi(m)(2).
If the list of the prime factors of a number m is known in the form of problem 2.03 then the function phi(m) can be efficiently calculated as follows: Let [[m1,p1],[m2,p2],[m3,p3],...] be the list of prime factors (and their multiplicities) of a given number m. Then phi(m) can be calculated with the following formula:

 
phi(m) = (p1 - 1) * p1^(m1 - 1) * (p2 - 1) * p2^(m2 - 1) * (p3 - 1) * p3^(m3 - 1) * ...
 

### Example
 
  phi2 10
4
 

### Solution
 
phi2: {*/{(y-1)*y^x-1}.'multiplicity x};
 

## Problem 39 (2.11)
Compare the two methods of calculating Euler's totient function.

### Example
 
  \t phi 10090
806
  \t phi2 10090
7
 
