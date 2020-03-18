#!/usr/bin/env lua

local parser = require "parser"
local parse = parser.parse

--success tests
test1 = "s"
r, e = parse(test1)
assert(r == #test1 + 1)
print("'" ..test1 .. "' -> matched successfully")

test2 = " s = 1"
r, e = parse(test2)
assert(r == #test2 + 1)
print("'" ..test2 .. "' -> matched successfully")

test3 = " s =     100000e3"
r, e = parse(test3)
assert(r == #test3 + 1)
print("'" ..test3 .. "' -> matched successfully")


test4 = " 444444 "
r, e = parse(test4)
assert(r == #test4 + 1)
print("'" ..test4 .. "' -> matched successfully")

test5 = " 8+7*(88+9)"
r, e = parse(test5)
assert(r == #test5 + 1)
print("'" ..test5 .. "' -> matched successfully")


test6 = " id = 8+7*(88+9)"
r, e = parse(test6)
assert(r == #test6 + 1)
print("'" ..test6 .. "' -> matched successfully")

test7 = " id   = 8+7*(88+9) + ((7e2*3) -(88.4+5.3))"
r, e = parse(test7)
assert(r == #test7 + 1)
print("'" ..test7 .. "' -> matched successfully")

--failed tests
test8 = " 88 + "
r, e = parse(test8)
print("'" ..test8 .. "' ->" ..e)

test9 = " 88 * "
r, e = parse(test9)
print("'" ..test9 .. "' ->" ..e)

test10 = " id   = 8+7*(88+9) + ((7e2*3 -(88.4+5.3))"
r, e = parse(test10)
print("'" ..test10 .. "' ->" ..e)
