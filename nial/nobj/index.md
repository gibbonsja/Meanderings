---
title: "A Very Simple Object System for Nial"
---

The source code can be found in the file [nobj.ndf](nobj.ndf) and a 
small example/test in the file [nobjexample.ndf](nobj.ndf).

# Overview

**nobj** is a very simple and small prototype based object
system for Nial based on hash tables.

Objects are represented as a pair consisting of

1. a hash table of attribute/value pairs where
   the attributes are Nial *phrases*
2. a parent object for inheritance

Attribute lookups start in the base table and if not found then
the ancestor tables are recursively searched.

Object methods are attribute/value pairs where the
value is a cast of a function *fn* of the form

    attr fn [obj,additional_args]
	
# Creating New Objects

There are two ways to create new objects: 

1. clone an existing object and add new attribute/value pairs. This 
   produces a new object whose parent is the existing object
2. flatten an existing object which produces an object with no parent
   whose attributes are an amalgamation of the attributes of the 
   existing object

To clone an existing object you use the function

    _objclone [attr/value pair, ...]  parent

and to flatten an existing table you use the function

    _objlevel obj

When cloning you can use *null* for the parent and the empty array *[]*
if you don't want to add attributes.

# Setting and Getting Attributes

To set the value of an existing attribute or add a new attribute to an
object use the following function

    _objset obj attr_value_pair

In both cases the new attribute and value will be in the base table
even if the old attribute is in some ancestor.

To get the current value of an attribute for an object use the function

    _objget obj attr

which first searches the base table for the attribute and if not found will 
try to find the attribute in parent and so on.


# Invoking Methods

An object method is just an attribute/value pair where the value is the 
cast of a function *fn* with a signature *fn obj args*. 

To invoke a method use the function

    _objsend method_name [obj, args]

This will look up the method name to get the function cast and then
apply the cast to the arguments *[obj,args]*.


