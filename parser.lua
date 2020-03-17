#!/usr/bin/env lua

local lpeg = require 'lpeglabel'
local re = require 'relabel'
lpeg.locale(lpeg)

local P,R,S,B,V,C,Ct,Cmt,Cp,Cc,T = lpeg.P,lpeg.R,lpeg.S,lpeg.B,lpeg.V,lpeg.C,lpeg.Ct,lpeg.Cmt,
								   lpeg.Cp,lpeg.Cc,lpeg.T
function token (tok)
	return V"spaces" * tok * V"spaces"
end
function maybe(p) return p^-1 end
local digits = R'09'^1
local pm = maybe(S'+-')
local dot = ('.')
local pow = S'eE'

local grammar = P {
	"program",
	program = (V"Cmd" + V"Exp")^0,
	Cmd = V"var" * token(P("=")) * V"Exp",
	ExpDash = token(S('+-')) * V"ExpDash",
	Exp = V"Term" * V"ExpDash",
	TermDash = token(S('*/')) * V"TermDash",
	Term = V"Factor" * V"TermDash",
	Factor = V"num" + V"var" + (token(P("(")) * V"Exp" * token(P(")"))),
	num = token(pm * digits * maybe(dot*digits) * maybe(pow*pm*digits)),
	var = token((lpeg.alpha+P'_') * (lpeg.alnum+P'_')^0),
	spaces = P(lpeg.space)^0,
}


function parse(str)
	print(str) 
	local r, e, sfail = grammar:match(str)
	return r,e
end	

local re = {
parse = parse,
}
return re



