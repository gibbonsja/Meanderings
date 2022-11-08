
Some translations of APL into Nial

Note that different APLs have some different interpretations of the functions.
There is also a level of polymorphism in arguments for both monadic and dyadic
usages.

# Matching Verbs

## ⍳ (Iota)

###  Monadic

- *tell* for 0 origin indexing
- *count* for 1 origin indexing



# Common Verb Trains

| Name | APL Form | APL Meaning | Nial |
| ---------- | -------------- |---------------- | ------------- |
| Monadic Hook | (f g) x |   x f (g x) |  f[pass,g] x |
| Monadic Fork | (f g h) x | (f x) g (h x) | g[f,h] x |
| Dyadic Hook | x (f g) y | x f (g y) | x f[first, g second] y |
| Dyadic Fork | x (f g h) y | (x f y) g (x h y) | x (g[f,h]) y |


