#!/usr/bin/env lua

local parser = require "parser"
local parse = parser.parse

--success tests
test1 = "s=7*7"
r, e = parse(test1)
print(r)
assert(r=="s=49")
print("'" ..test1 .. "' -> matched successfully")

test2 = " s = 1"
r, e = parse(test2)
assert(r=="s=1")
print("'" ..test2 .. "' -> matched successfully")

test3 = " s =     100000e3"
r, e = parse(test3)
assert(r=="s=100000000.0")
print("'" ..test3 .. "' -> matched successfully")

test4 = " 444444 "
r, e = parse(test4)
assert(r=="444444")
print("'" ..test4 .. "' -> matched successfully")

test5 = " 8+7*(88+9)"
r, e = parse(test5)
assert(r=="687")
print("'" ..test5 .. "' -> matched successfully")

test6 = " id = 8+7*(88+9)"
r, e = parse(test6)
assert(r=="id=687")
print("'" ..test6 .. "' -> matched successfully")

test7 = " id   = 8+7*(88+9)+((7e2*2) -(88+5))"
r, e = parse(test7)
assert(r=="id=687")
print("'" ..test7 .. "' -> matched successfully")

test8 = "id = (8) * ((7)) "
r, e = parse(test8)
assert(r=="id=56")
print("'" ..test8 .. "' -> matched successfully")

test9 = "a=4 b=7"
r, e = parse(test9)
assert(r=="a=4")
print("'" ..test9 .. "' -> matched successfully")

test10 = "a=4 b=a+4"
r, e = parse(test10)
assert(r=="a=4")
print("'" ..test10 .. "' -> matched successfully")

test11 = "a = 3 * 2   b = a + 1"
r, e = parse(test11)
assert(r=="a=6")
print("'" ..test11 .. "' -> matched successfully")

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



