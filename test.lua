#!/usr/bin/env lua

local parser = require "parser"
local parse = parser.parse

--success tests
test1 = "s"
r, e = parse(test1)
assert(e==nil)
print("'" ..test1 .. "' -> matched successfully")
print("tokens:" ..r)

test2 = " s = 1"
r, e = parse(test2)
assert(e==nil)
print("'" ..test2 .. "' -> matched successfully")
print("tokens:" ..r)

test3 = " s =     100000e3"
r, e = parse(test3)
assert(e==nil)
print("'" ..test3 .. "' -> matched successfully")
print("tokens:" ..r)

test4 = " 444444 "
r, e = parse(test4)
assert(e==nil)
print("'" ..test4 .. "' -> matched successfully")
print("tokens:" ..r)

test5 = " 8+7*(88+9)"
r, e = parse(test5)
assert(e==nil)
print("'" ..test5 .. "' -> matched successfully")
print("tokens:" ..r)

test6 = " id = 8+7*(88+9)"
r, e = parse(test6)
assert(e==nil)
print("'" ..test6 .. "' -> matched successfully")
print("tokens:" ..r)

test7 = " id   = 8+7*(88+9) + ((7e2*3) -(88.4+5.3))"
r, e = parse(test7)
assert(e==nil)
print("'" ..test7 .. "' -> matched successfully")
print("tokens:" ..r)

test8 = "id = (8)((7)) "
r, e = parse(test8)
assert(e==nil)
print("'" ..test8 .. "' -> matched successfully")
print("tokens:" ..r)

--failed tests
ftest1 = " 88 + "
r, e, err = parse(ftest1)
assert(err==parser.terror.termErr)
print("'" ..ftest1 .. "' ->" ..e..err)

ftest2 = " 88 * "
r, e, err = parse(ftest2)
assert(err==parser.terror.factorErr)
print("'" ..ftest2 .. "' ->" ..e..err)

ftest3 = " id   = 8+7*(88+9) + ((7e2*3 -(88.4+5.3))"
r, e, err = parse(ftest3)
assert(err==parser.terror.CloseBrMissing)
print("'" ..ftest3 .. "' ->" ..e..err)

ftest4 = " id   ="
r, e, err = parse(ftest4)
assert(err==parser.terror.expErr)
print("'" ..ftest4 .. "' ->" ..e..err)

ftest5 = " id = (())"
r, e, err = parse(ftest5)
assert(err==parser.terror.expErr)
print("'" ..ftest5 .. "' ->" ..e..err)



