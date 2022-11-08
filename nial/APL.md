
Some translations of APL into Nial

# Common Verb Trains

| Name | APL Form | APL Meaning | Nial |
| ---------- | -------------- |---------------- | ------------- |
| Monadic Hook | (f g) x |   x f (g x) |  f[pass,g] x |
| Monadic Fork | (f g h) x | (f x) g (h x) | g[f,h] x |
| Dyadic Hook | x (f g) y | x f (g y) | x f[first, g second] y |
| Dyadic Fork | x (f g h) y | (x f y) g (x h y) | x (g[f,h]) y |


