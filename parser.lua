#!/usr/bin/env lua

local lpeg = require 'lpeglabel'
local re = require 'relabel'
local tostring = require 'ml'.tstring
lpeg.locale(lpeg)

local P,R,S,B,V,C,Ct,Cmt,Cp,Cc,T = lpeg.P,lpeg.R,lpeg.S,lpeg.B,lpeg.V,lpeg.C,lpeg.Ct,lpeg.Cmt,
								   lpeg.Cp,lpeg.Cc,lpeg.T
function token (tok)
	return V"spaces" * tok
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

VARS = {}
function eval(num1, operator, num2)
    if operator == '+' then
        return num1 + num2
    elseif operator == '-' then
        return num1 - num2
    elseif operator == '*' then
        return num1 * num2
    elseif operator == '/' then
        return num1 / num2
    elseif operator == '=' then
        VARS[num1] = num2
        return num1 .. "=" .. num2    
    else
        return num1
    end
end
function getValue(var)
	return VARS[var]
end	

function interpret( ... )
	local args = {...}
	local out = ""
	for i=1,#args do
		out = out .. args[i]
	end
	print(out)
	return out
end

local grammar = P {
	"program",
	program = (V"Cmd"/interpret + V"Exp"/interpret)^0,
	Cmd =  V"var" * token(C(P("="))) * (V"Exp"+T"expErr")/eval,
	Exp = V"Term" * ( token(C(S('+-'))) * (V"Term"+T"termErr") )^0 /eval,
	Term = V"Factor" * ( token(C(S('*/'))) * (V"Factor"+T"factorErr") )^0 /eval,
	Factor = V"num" + V"var"/getValue + ( token(P("(")) * (V"Exp"+T"expErr") * (token(P(")")) + T"CloseBrMissing") )/eval,
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



