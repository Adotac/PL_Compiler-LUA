local lexer = require 'lexical_analyzer'
local syntax = require 'syntax_analyzer'
local linkedlist = require 'LinkedList'
local enumTokens = require 'tokType'
local bnf = require 'BNF'

local bnfTokens = bnf.getBNF()
local TokenType = enumTokens.getTokTypes()

LEX = lexer:new(nil)
SA = syntax:new(nil)

SLIST = linkedlist()

local function int2float(n1, n2)
    local temp1 = n1 + 0.0
    local temp2 = (n2 + 0.0)
    while temp2 > 1 do
        temp2 = temp2 / 10
    end

    return temp1 + temp2
end
  

function TypeCheck(parseStack, tokens)
    local l = parseStack.head
    local t = tokens.head
    local dataType = l.data

    if t == nil then
        print("---no tokens---")
        return
    end
    t = t.next.next
    l = l.next.next
    while l do

        if l == nil then
            return
        end

        if t.data.tokType == TokenType.DOUBLE_QUOTE then
            t = t.next
        end

        if l.data == bnfTokens["="] or t.data.tokType == TokenType.OPERATOR then
            t = t.next
            l = l.next
        end
        
        if t.data.tokType == TokenType.TERMINATOR or l.data == bnfTokens[";"] then
            break
        end

        if dataType == bnfTokens.INTEGRAL_TYPE and l.data ~= bnfTokens.INTEGRAL_L  then
            return "Error type value, implicit type literal value on an Integral data type.", false
        elseif dataType == bnfTokens.BOOLEAN_TYPE and l.data ~= bnfTokens.BOOLEAN_L then
            return "Error type value, implicit type literal value on a boolean data type.", false
        elseif  dataType == bnfTokens.STRING_TYPE and l.data ~= bnfTokens.STRING_L then
            return "Error type value, implicit type literal value on a string data type.", false
        end

        t = t.next
        l = l.next
        
    end

    return "No type Errors...", true
end

function SymbolTable(parseStack, tokens, error)
    local l = parseStack.head
    local t = tokens.head
    local dataType = t.data.tokVal

    local id = t.next.data.tokVal
    local valueResult = "null"
    local nTemp1, nTemp2, opTemp = "null", 0, nil
    local nFlag1 = false

    if t == nil then
        print("\n---error symbol table---")
        return
    end
    t = t.next.next
    l = l.next.next
    while l do

        if l == nil then
            return
        end


        if t.data.tokType == TokenType.DOUBLE_QUOTE then
            t = t.next
        end

        if l.data == bnfTokens["="] then
            t = t.next
            l = l.next
        end
        
        local ntemp = nil

        if t.data.tokType == TokenType.OPERATOR then
            opTemp = t.data.tokVal
            t = t.next
            l = l.next
        end

        if t.data.tokType == TokenType.TERMINATOR then
            break
        end
        
        if l.data == bnfTokens.INTEGRAL_L then
            ntemp = tonumber(t.data.tokVal)
        elseif l.data == bnfTokens.FLOAT_L  then
            local lSide = tonumber(t.data.tokVal)
            local rSide = 0
            if l.next.data == bnfTokens["."] and t.next.data.tokType == TokenType.POINT then
                l = l.next
                t = t.next
                rSide = tonumber(t.data.tokVal)
            end
            ntemp = int2float(lSide, rSide)

        elseif l.data == bnfTokens.STRING_L then
            ntemp = t.next.data.tokVal
            t = t.next
            l = l.next
        elseif l.data == bnfTokens.BOOLEAN_L then
            ntemp = t.data.tokVal
            t = t.next
            l = l.next
        end

        if not nFlag1 then
            nFlag1 = true
            nTemp1 = ntemp
        else
            nTemp2 = ntemp
            break
        end

        t = t.next
        l = l.next
    end

    if dataType == "int" or dataType == "float" then
        if opTemp == "+" then
            valueResult = nTemp1 + nTemp2
        elseif opTemp == "-" then
            valueResult = nTemp1 - nTemp2
        elseif opTemp == "*" then
            valueResult = nTemp1 * nTemp2
        elseif opTemp == "/" then
            valueResult = nTemp1 / nTemp2

            if dataType == "int" then
                valueResult = math.floor(valueResult)
            end
        else
            valueResult = nTemp1
        end
    elseif dataType == "String" then
        if opTemp == "+" then
            valueResult = nTemp1 .. nTemp2
        else
            valueResult = nTemp1
        end
    else
        valueResult = nTemp1

    end
    

    print("-------------------SYMBOL TABLE--------------------")
    print("|    variable","|      type","|      value","|")
    print("|",id,"|",dataType,"|",valueResult,"|")
    print("----------------------------------------------------")

end

-- meta class
Semantic_Analyzer = {}
-- base class method



function Semantic_Analyzer:new(obj)
    obj = obj or {}
    self.__index = self
    return setmetatable(obj, self)
end


function Semantic_Analyzer:AnalyzeCode(str)
    local tokens, stack, ptree, message, success = SA:SyntaxParser(str)
    local check, check_res = TypeCheck(stack, tokens)

    SymbolTable(stack, tokens, check_res)

    print("\n")

    print(success)
    print(message)
    -- print(ptree)
    print(check)
end




return Semantic_Analyzer