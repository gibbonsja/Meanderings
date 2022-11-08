


# 1. Remove Duplicates from a List

If v is a list of elements find the unique elements.

    ((v eachleft find v) eachboth = tell tally v) sublist v

The operator *x find y* returns the index of the first location of *x* in *y*.
Using *v eachleft find v* above we get a list of the indices of the first
occurrences of the elements of *v* in *v*. If that index matches the actual
index of the item then it is the first occurence.

Using *eachboth =* we get a boolean mask for sublist to extract those items.



