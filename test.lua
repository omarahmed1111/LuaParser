#!/usr/bin/env lua

local parser = require "parser"
local parse = parser.parse

s1 = "s = 1"


r, e = parse(s1)
assert(r == #s1 + 1)
print(e)
