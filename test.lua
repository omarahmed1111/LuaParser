#!/usr/bin/env lua

local parser = require "parser"
local parse = parser.parse

test1 = "s"
r, e = parse(test1)
assert(r == #test1 + 1)


test2 = " s = 1"
r, e = parse(test2)
assert(r == #test2 + 1)


test3 = " s =     100000e3"
r, e = parse(test3)
assert(r == #test3 + 1)


test4 = " 444444 "
r, e = parse(test4)
assert(r == #test4 + 1)
