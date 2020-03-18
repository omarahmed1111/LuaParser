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

test8 = "id = (8)((7)) "
r, e = parse(test8)
assert(r == #test8 + 1)
print("'" ..test8 .. "' -> matched successfully")

--failed tests
ftest1 = " 88 + "
r, e, err = parse(ftest1)
assert((r==nil or r < #ftest1 + 1) and err==parser.terror.termErr)
print("'" ..ftest1 .. "' ->" ..e..err)

ftest2 = " 88 * "
r, e, err = parse(ftest2)
assert((r==nil or r < #ftest2 + 1) and err==parser.terror.factorErr)
print("'" ..ftest2 .. "' ->" ..e..err)

ftest3 = " id   = 8+7*(88+9) + ((7e2*3 -(88.4+5.3))"
r, e, err = parse(ftest3)
assert((r==nil or r < #ftest3 + 1) and err==parser.terror.CloseBrMissing)
print("'" ..ftest3 .. "' ->" ..e..err)

ftest4 = " id   ="
r, e, err = parse(ftest4)
assert((r==nil or r < #ftest4 + 1) and err==parser.terror.expErr)
print("'" ..ftest4 .. "' ->" ..e..err)

ftest5 = " id = (())"
r, e, err = parse(ftest5)
assert((r==nil or r < #ftest5 + 1) and err==parser.terror.expErr)
print("'" ..ftest5 .. "' ->" ..e..err)



