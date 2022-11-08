


# 1. Remove Duplicates from a List

If v is a list of elements find the unique elements.

Nial has a builtin operator *cull* to do this but from first principles -

    ((v eachleft find v) match tell tally v) sublist v

The operator *x find y* returns the index of the first location of *x* in *y*.
Using *v eachleft find v* above we get a list of the indices of the first
occurrences of the elements of *v* in *v*. If that index matches the actual
index of the item then it is the first occurence.

Using *match*, a binary pervasive operator, to compare the locations from
*find* with the indices (*tell tally v*) we get a boolean mask for
sublist to extract those items.

For convenience We could turn this into a new operator with

    remdup is op v {
      ((v eachleft find v) match tell tally v) sublist v
    }

