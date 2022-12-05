local enumTokens = require 'tokType'
local check = require 'Checker'
local linkedlist = require 'LinkedList'
local TokenType = enumTokens.getTokTypes()
-- print(TokenType.COLON)

-- local functions
function GetString(str, ind)
    local j = ind
    while (j < #str) do
        local subTemp = string.sub(str, ind, j)
        local charTemp = string.sub(str, j,j)
        if (string.match(charTemp, ".") or string.match(charTemp, "%s")) and not string.match(charTemp, "\"") then
            j = j + 1
            if (j >= #str) then
                return subTemp
            end
        else
            if string.match(charTemp, "%s") or charTemp == "\"" then
                subTemp = string.sub(str, ind, j-1)
            end
            return subTemp
        end
    end
    return string.sub(str, ind, j)
end

function GetWord(str, ind)
    local j = ind
    local subTemp = string.sub(str, ind, j)
    while (j < #str) do
        
        local charTemp = string.sub(str, j,j)
        -- print(charTemp)
        if (string.match(charTemp, "%w") and not string.match(charTemp, "%s")) then
        subTemp = string.sub(str, ind, j)
            
            j = j + 1

            if (j > #str-1) then
                -- print(subTemp)
                return subTemp
            end
        else
            if string.match(charTemp, "%s") or charTemp == ";" then
                subTemp = string.sub(str, ind, j-1)
            end

            -- print(subTemp)
            return subTemp
        end
    end
    -- print(subTemp)
    return subTemp
end

function IsNumeric(str)
    if not (str == nil) and (str:match("[-+]?%d*.?%d+")) and not (str:match("%a")) then
        return true
    else
        return false
    end
end

-- meta class
Lexical_Analyzer = {}
-- base class method

function Lexical_Analyzer:new(obj)
    obj = obj or {}
    self.__index = self
    return setmetatable(obj, self)
end

-- base class methods
function Lexical_Analyzer:Tokenizer(sInput) --string input 's'
    local list = linkedlist()
    local stringFlag = false
    -- io.write('\nlexical ', sInput, '\n')
    -- io.write('\nString input length: ', #sInput, '\n')
    local i=1
    while i <= #sInput do -- init, max/min value, increment/no increment)
        local wTemp = GetWord(sInput, i)
        -- print(wTemp)
        if string.sub(sInput, i,i) == "(" then
            -- table.insert(temp, Token:new(TokenType.LPARA, "("))
            list:insertTail({tokType = TokenType.LPARA, tokVal = "("}) -- {next = list, value = {tokType = TokenType.LPARA, tokVal = "("}}
            
            i = i + 1
            
        elseif  string.sub(sInput, i,i) == ")" then
            -- table.insert(temp, Token:new(TokenType.RPARA, ")"))
            list:insertTail({tokType = TokenType.RPARA, RPARA = ")"}) -- {next = list, value = {tokType = TokenType.RPARA, tokVal = ")"}}
            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "[" then
            -- table.insert(temp, Token:new(TokenType.LPUNCTUATION, "["))
            list:insertTail({tokType = TokenType.LPUNCTUATION, tokVal = "["}) -- {next = list, value = {tokType = TokenType.LPUNCTUATION, tokVal = "["}}
            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "]" then
            -- table.insert(temp, Token:new(TokenType.RPUNCTUATION, "]"))
            list:insertTail({tokType = TokenType.RPUNCTUATION, tokVal = "]"}) -- {next = list, value = {tokType = TokenType.RPUNCTUATION, tokVal = "]"}}
            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "}" then
            -- table.insert(temp, Token:new(TokenType.LPUNCTUATION, "{"))
            list:insertTail({tokType = TokenType.LPUNCTUATION, tokVal = "{"}) -- {next = list, value = {tokType = TokenType.LPUNCTUATION, tokVal = "{"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "{" then
            -- table.insert(temp, Token:new(TokenType.RPUNCTUATION, "}"))
            list:insertTail({tokType = TokenType.RPUNCTUATION, tokVal = "}"}) -- {next = list, value = {tokType = TokenType.RPUNCTUATION, tokVal = "}"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "+" then
            -- table.insert(temp, Token:new(TokenType.OPERATOR, "+"))
            list:insertTail({tokType = TokenType.OPERATOR, tokVal = "+"}) -- {next = list, value = {tokType = TokenType.OPERATOR, tokVal = "+"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "-" then
            -- table.insert(temp, Token:new(TokenType.OPERATOR, "-"))
            list:insertTail({tokType = TokenType.OPERATOR, tokVal = "-"}) -- {next = list, value = {tokType = TokenType.OPERATOR, tokVal = "-"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "*" then
            -- table.insert(temp, Token:new(TokenType.OPERATOR, "*"))
            list:insertTail({tokType = TokenType.OPERATOR, tokVal = "*"}) -- {next = list, value = {tokType = TokenType.OPERATOR, tokVal = "*"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "/" then
            -- table.insert(temp, Token:new(TokenType.OPERATOR, "/"))
            list:insertTail({tokType = TokenType.OPERATOR, tokVal = "/"}) -- {next = list, value = {tokType = TokenType.OPERATOR, tokVal = "/"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "<" then
            -- table.insert(temp, Token:new(TokenType.OPERATOR, "<"))
            list:insertTail({tokType = TokenType.OPERATOR, tokVal = "<"}) -- {next = list, value = {tokType = TokenType.OPERATOR, tokVal = "<"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == ">" then
            -- table.insert(temp, Token:new(TokenType.OPERATOR, ">"))
            list:insertTail({tokType = TokenType.OPERATOR, tokVal = ">"}) -- {next = list, value = {tokType = TokenType.OPERATOR, tokVal = ">"}}

            i = i + 1
            
            -- --------------------------------------------
        elseif  string.sub(sInput, i,i) == "," then
            -- table.insert(temp, Token:new(TokenType.COMMA, ","))
            list:insertTail({tokType = TokenType.COMMA, tokVal = ","}) -- {next = list, value = {tokType = TokenType.COMMA, tokVal = ","}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "." then
            -- table.insert(temp, Token:new(TokenType.POINT, "."))
            list:insertTail({tokType = TokenType.POINT, tokVal = "."}) -- {next = list, value = {tokType = TokenType.POINT, tokVal = "."}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == '\"' then
            -- table.insert(temp, Token:new(TokenType.DOUBLE_QUOTE, "\""))
            list:insertTail({tokType = TokenType.DOUBLE_QUOTE, tokVal = "\""}) -- {next = list, value = {tokType = TokenType.DOUBLE_QUOTE, tokVal = "\""}}

            i = i + 1
            
            if not stringFlag then
                wTemp = GetString(sInput, i)
                i = i + #wTemp
                stringFlag = true
                -- table.insert(temp, Token:new(TokenType.CONSTANT, wTemp))
                list:insertTail({tokType = TokenType.STRING, tokVal = wTemp}) -- {next = list, value = {tokType = TokenType.CONSTANT, tokVal = wTemp}}

            else
                stringFlag = false
            end

            

        elseif  string.sub(sInput, i,i) == "\'" then
            -- table.insert(temp, Token:new(TokenType.PUNCTUATION, "\'"))
            list:insertTail({tokType = TokenType.PUNCTUATION, tokVal = "\'"}) -- {next = list, value = {tokType = TokenType.PUNCTUATION, tokVal = "\'"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == ":" then
            -- table.insert(temp, Token:new(TokenType.COLON, ":"))
            list:insertTail({tokType = TokenType.COLON, tokVal = ":"}) -- {next = list, value = {tokType = TokenType.COLON, tokVal = ":"}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == "=" then
            -- table.insert(temp, Token:new(TokenType.EQUALS, "="))
            list:insertTail({tokType = TokenType.EQUALS, tokVal = "="}) -- {next = list, value = {tokType = TokenType.EQUALS, tokVal = "="}}

            i = i + 1
            
        elseif  string.sub(sInput, i,i) == ";" then
            -- table.insert(temp, Token:new(TokenType.TERMINATOR, ";"))
            list:insertTail({tokType = TokenType.TERMINATOR, tokVal = ";"}) -- {next = list, value = {tokType = TokenType.TERMINATOR, tokVal = ";"}}

            i = i + 1
            
        else
            if string.sub(sInput, i,i):match("%s") then
                i = i + 1
            else
                if wTemp ~= "" then
                    if check.isDataType(wTemp) then
                        list:insertTail({tokType = TokenType.DATATYPE, tokVal = wTemp}) -- {next = list, value = {tokType = TokenType.DATATYPE, tokVal = wTemp}}
                        i = i + #wTemp
                    elseif check.isKeyword(wTemp) then
                        -- table.insert(temp, Token:new(TokenType.KEYWORD, wTemp))
                        list:insertTail({tokType = TokenType.KEYWORD, tokVal = wTemp}) -- {next = list, value = {tokType = TokenType.KEYWORD, tokVal = wTemp}}
                        i = i + #wTemp
                    elseif IsNumeric(wTemp) then
                        list:insertTail({tokType = TokenType.NUMBER, tokVal = wTemp}) -- {next = list, value = {tokType = TokenType.CONSTANT, tokVal = wTemp}}

                        i = i + #wTemp
                    elseif wTemp == "true" or wTemp == "false" then
                        -- table.insert(temp, Token:new(TokenType.CONSTANT, wTemp))
                        list:insertTail({tokType = TokenType.CONSTANT, tokVal = wTemp}) -- {next = list, value = {tokType = TokenType.CONSTANT, tokVal = wTemp}}

                        i = i + #wTemp
                    else
                        -- table.insert(temp, Token:new(TokenType.IDENTIFIER, wTemp))
                        list:insertTail({tokType = TokenType.IDENTIFIER, tokVal = wTemp}) -- {next = list, value = {tokType = TokenType.IDENTIFIER, tokVal = wTemp}}

                        i = i + #wTemp
                    end
                else
                    print("No detected token")
                end
            end       
        end
    end

    print("Token Linked List")
    local l = list.head
    while l do

        if l == nil then
            return
        end
        print(l.data.tokVal, " | ", TokenType[l.data.tokType])
        l = l.next
        
    end

    return list
end

return Lexical_Analyzer