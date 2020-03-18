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

local terror = {
	ExpErr = "Error matching 'SimpleExp'",
	termErr = "Error matching 'Term'",
	factorErr = "Error matching 'Factor'",
	CloseBrMissing = "Error missing closing bracket"
}


local grammar = P {
	"program",
	program = (V"Cmd" + V"Exp")^-1,
	Cmd = V"var" * token(P("=")) * V"Exp",
	Exp = V"Term" * (token(S('+-')) * (V"Term"+T"termErr") )^0,
	Term = V"Factor" * (token(S('*/')) * (V"Factor"+T"factorErr") )^0,
	Factor = V"num" + V"var" + (token(P("(")) * V"Exp" * (token(P(")")) + T"CloseBrMissing")),
	num = token(pm * digits * maybe(dot*digits) * maybe(pow*pm*digits)) ,
	var = token((lpeg.alpha+P'_') * (lpeg.alnum+P'_')^0) ,
	spaces = P(lpeg.space)^0,
}

local function mymatch(g, s)
  local r, e, pos = g:match(s)
  if not r then
    local line, col = re.calcline(s, pos)
    local msg = "Error at line " .. line .. " (col " .. col .. "): "
    return r, msg .. terror[e]
  end 
  return r,e
end

function parse(str)
	--print(str) 
	local r,e = mymatch(grammar,str)
	return r,e
end	

local out = {
parse = parse,
}
return out



