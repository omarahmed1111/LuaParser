#!/usr/bin/env lua

local lpeg = require 'lpeglabel'
local re = require 'relabel'
local tostring = require 'ml'.tstring
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
	expErr = "Error matching 'Exp'",
	termErr = "Error matching 'Term'",
	factorErr = "Error matching 'Factor'",
	CloseBrMissing = "Error missing closing bracket",
	
}


local grammar = P {
	"program",
	program = Ct((V"Cmd" + V"Exp")^0)/tostring,
	Cmd =  V"var" * token(C(P("="))) * (V"Exp"+T"expErr"),
	Exp = V"Term" * ( token(C(S('+-'))) * (Ct(V"Term")+T"termErr") )^0,
	Term = V"Factor" * ( token(C(S('*/'))) * (Ct(V"Factor")+T"factorErr") )^0,
	Factor = V"num" + V"var" + ( token(C(P("("))) * (Ct(V"Exp")+T"expErr") * (token(C(P(")"))) + T"CloseBrMissing") ),
	num = token(C(pm * digits * maybe(dot*digits) * maybe(pow*pm*digits))/tonumber) ,
	var = token(C((lpeg.alpha+P'_') * (lpeg.alnum+P'_')^0)) ,
	spaces = P(lpeg.space)^0,
}

local function mymatch(g, s)
  local r, e, pos = g:match(s)
  --print(pos)
  if not r then
    local line, col = re.calcline(s, pos)
    local msg = "Error at line " .. line .. " (col " .. col .. "): "
    return r, msg , terror[e]
  end 
  return r,e,pos
end

function parse(str)
	--print(str) 
	local r,e,err = mymatch(grammar,str)
	return r,e,err
end	

local out = {
parse = parse,
terror=terror
}
return out



