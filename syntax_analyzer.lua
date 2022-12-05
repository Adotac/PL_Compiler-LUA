local lex = require 'lexical_analyzer'
local enumTokens = require 'tokType'
local linkedlist = require 'LinkedList'
local bnf = require 'BNF'
local TokenType = enumTokens.getTokTypes()
local bnfTokens = bnf.getBNF()
-- local Token = require 'TokenClass'
Lexer = lex:new(nil)

-- meta class
Syntax_Analyzer = {}
-- base class method
TempDataType = nil

StringStart = false
StringEnd = false
EqFlag = false
ParaStart = false
ParaEnd = false

function IsNumeric(str)
    if not (str == nil) and (str:match("[-+]?%d*.?%d+")) and not (str:match("%a")) then
        return true
    else
        return false
    end
end

function GrammarRules(lastToken, currToken)
    print("Grammar Rules PASS:", lastToken.data.tokVal)
    -- BTree = TempBTreeParent

    if currToken == nil then
        return "Token stack error", false
    end

    -- DATA TYPE TOKEN
    if lastToken.data.tokType == TokenType.DATATYPE then
        TempDataType = lastToken.data.tokVal
        -- declaration
        if currToken.data.tokType == TokenType.IDENTIFIER then

            if not currToken.data.tokVal:match("[^%w_]") then
                return GrammarRules(currToken, currToken.next)
            else
                return "Invalid variable name", false
            end
        
        else
            return "Expected an identifier", false
        end
    end

    -- IDENTIFIER TOKEN
    if lastToken.data.tokType == TokenType.IDENTIFIER then
        if currToken.data.tokType == TokenType.EQUALS then
            return GrammarRules(currToken, currToken.next)
        end

        if currToken.data.tokType == TokenType.LPARA and EqFlag then
            ParaStart = true
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.RPARA and EqFlag and ParaStart then
            ParaEnd = true
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.COMMA then
            if EqFlag then
                return "Invalid Syntax", false
            else
                return GrammarRules(currToken, currToken.next)
            end
        end
        if currToken.data.tokType == TokenType.TERMINATOR then
            local tempTail = currToken.next
            if tempTail == nil then
                return GrammarRules(currToken, currToken)
            else
                return "Invalid statement after termination", false
            end
        end
        
        if currToken.data.tokType == TokenType.OPERATOR then
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.RPARA then
            return GrammarRules(currToken, currToken.next)
        end
    end

    -- LPARA TOKEN
    if lastToken.data.tokType == TokenType.LPARA then
        ParaStart = true
        if currToken.data.tokType == TokenType.CONSTANT or currToken.data.tokType == TokenType.IDENTIFIER
            or currToken.data.tokType == TokenType.NUMBER or currToken.data.tokType == TokenType.STRING then
            return GrammarRules(currToken, currToken.next)
        end
    end
    --  RPARA TOKEN
    if lastToken.data.tokType == TokenType.RPARA and ParaStart then
        ParaEnd = false
        ParaStart = false
        if currToken.data.tokType == TokenType.CONSTANT or currToken.data.tokType == TokenType.IDENTIFIER
        or currToken.data.tokType == TokenType.NUMBER or currToken.data.tokType == TokenType.STRING then
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.OPERATOR then
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.TERMINATOR then
            local tempTail = currToken.next
            if tempTail == nil then
                return GrammarRules(currToken, currToken)
            else
                return "Invalid statement after termination", false
            end
        end
    end

    -- COMMA TOKEN
    if lastToken.data.tokType == TokenType.COMMA then
        if currToken.data.tokType == TokenType.IDENTIFIER then
            return GrammarRules(currToken, currToken.next)
        end
    end

    ------
    if lastToken.data.tokType == TokenType.CONSTANT then
        if TempDataType == "boolean" then
            if lastToken.data.tokVal == "true" or lastToken.data.tokVal == "false" then
                if currToken.data.tokType == TokenType.TERMINATOR then
                    local tempTail = currToken.next
                    if tempTail == nil then
                        return GrammarRules(currToken, currToken)
                    else
                        return "Invalid statement after terminator", false
                    end
                end
            end
        end
    end

    if lastToken.data.tokType == TokenType.STRING then
        if TempDataType == "String" then
            if currToken.data.tokType == TokenType.DOUBLE_QUOTE then
                if StringStart then
                    StringEnd = true
                    return GrammarRules(currToken, currToken.next)
                end
            end
        end
    end

    -- CONSTANT TOKEN
    if lastToken.data.tokType == TokenType.NUMBER then
        if TempDataType == "int" then
            if currToken.data.tokType == TokenType.POINT then
                return "Error variable type: should be type float or double", false
            end
            if currToken.data.tokType == TokenType.RPARA and EqFlag and ParaStart then
                ParaEnd = true
                return GrammarRules(currToken, currToken.next)
            end
            if currToken.data.tokType == TokenType.OPERATOR then
                return GrammarRules(currToken, currToken.next)
            end
            if currToken.data.tokType == TokenType.TERMINATOR then
                local tempTail = currToken.next
                if tempTail == nil then
                    return GrammarRules(currToken, currToken)
                else
                    return "Invalid statement after terminator", false
                end
            end
        end
        if TempDataType == "float" or TempDataType == "double" then
            if currToken.data.tokType == TokenType.POINT then
                local tempTail = currToken.next
                if tempTail == nil then
                    return "Invalid point syntax declaration or missing values", false
                else
                    return GrammarRules(currToken, currToken.next)
                end
            end

            if currToken.data.tokType == TokenType.TERMINATOR then
                local tempTail = currToken.next
            if tempTail == nil then
                return GrammarRules(currToken, currToken)
                else
                    return "Invalid statement after terminator", false
                end
            end

            return GrammarRules(currToken, currToken.next)
        end
        
        
    end

    -- last check for string
    if lastToken.data.tokType == TokenType.DOUBLE_QUOTE and TempDataType == "String" then
        if currToken.data.tokType == TokenType.TERMINATOR and (StringStart and StringEnd) then
            StringStart = false
            StringEnd = false
            local tempTail = currToken.next
            if tempTail == nil then
                return GrammarRules(currToken, currToken)
            else
                return "Invalid string operation", false
            end
        end
        if currToken.data.tokType == TokenType.OPERATOR and (StringStart and StringEnd)then
            if currToken.data.tokVal == "+" then
                StringStart = false
                StringEnd = false
                return GrammarRules(currToken, currToken.next)
            else
                return "Invalid string operation", false
            end
        end
        if (StringStart and not StringEnd) or not StringStart then
            if currToken.data.tokType == TokenType.STRING then
                return GrammarRules(currToken, currToken.next)
            end
        end
    end

    -- last check for floating point numbers
    if lastToken.data.tokType == TokenType.POINT then
        if TempDataType == "float" or TempDataType == "double" then
            if currToken.data.tokType == TokenType.COMMA then
                return GrammarRules(currToken, currToken.next)
            elseif currToken.data.tokType == TokenType.TERMINATOR then
                return "Invalid point syntax declaration or missing value?", false
            end

            if currToken.data.tokType == TokenType.NUMBER then
                return GrammarRules(currToken, currToken.next)
            end
        end
    end

    -- OPERATOR TOKEN
    if lastToken.data.tokType == TokenType.OPERATOR then
        if currToken.data.tokType == TokenType.NUMBER or currToken.data.tokType == TokenType.IDENTIFIER then
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.DOUBLE_QUOTE then
            StringStart = true
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.LPARA and EqFlag then
            ParaStart = true
            return GrammarRules(currToken, currToken.next)
        end
    end

    -- The last use case
    if lastToken.data.tokType == TokenType.TERMINATOR then
        if currToken.data.tokType == TokenType.TERMINATOR
        and not ParaEnd and not ParaStart
        and not StringStart and not StringEnd  then
            return "", true
        end
    end

    -- EQUAL TOKEN
    if lastToken.data.tokType == TokenType.EQUALS and not EqFlag then
        EqFlag = true
        if currToken.data.tokType == TokenType.LPARA then
            ParaStart = true
            return GrammarRules(currToken, currToken.next)
        end
        if currToken.data.tokType == TokenType.CONSTANT
        or currToken.data.tokType == TokenType.IDENTIFIER
        or currToken.data.tokType == TokenType.NUMBER
        then
            return GrammarRules(currToken, currToken.next)
        end
        -- if currToken.data.tokType == TokenType.IDENTIFIER then
        --     return GrammarRules(currToken, currToken.next)
        -- end
        if currToken.data.tokType == TokenType.DOUBLE_QUOTE then
            StringStart = true
            return GrammarRules(currToken, currToken.next)
        end
    else
        return "Invalid syntax", false
    end

    return false
end


function Build_parse_tree(tokenList, slist)
    local tree = {val = bnfTokens.VAR_DECN, left = nil, center = nil, right = nil}
    local node = tree
    local tempNode = node
    local tempDT = nil
    local tempOpHead = nil
    local equalFlag = false
    local operFlag = false
    local secondFlag = false
    local l = tokenList
    while l do

        if l == nil then
            return
        end
        -- print(l.data.tokVal, " | ", TokenType[l.data.tokType])

        if l.data.tokType == TokenType.DATATYPE then
            tempDT = l.data.tokVal
            node.left = {val = bnfTokens.DTYPE}
            node = node.left

            if l.data.tokVal == "int" or l.data.tokVal == "byte" or
            l.data.tokVal == "short" or l.data.tokVal == "long" or
            l.data.tokVal == "char"then
                node.left = {val = bnfTokens.NUMERIC_TYPE}
                node = node.left
                node.left = {val = bnfTokens.INTEGRAL_TYPE}
            elseif l.data.tokVal == "float" or l.data.tokVal == "double" then
                node.left = {val = bnfTokens.NUMERIC_TYPE}
                node = node.left
                node.left = {val = bnfTokens.FLOAT_TYPE}
            elseif l.data.tokVal == "String" then
                node.left = {val = bnfTokens.STRING_TYPE}
            elseif l.data.tokVal == "boolean" then
                node.left = {val = bnfTokens.BOOLEAN_TYPE}
            end

            slist:insertTail(node.left.val)
            node = tempNode -- return to top Node
        elseif l.data.tokType == TokenType.IDENTIFIER and equalFlag == false then
            if l.next.data.tokType == TokenType.EQUALS then --peek equal sign
                node = tempNode
                equalFlag = true
            end

            node.right = {val = bnfTokens.VAR_DECS}
            node = node.right

            tempNode = node -- re assign top node
            node.right = {val = bnfTokens[";"]}
            
            node = tempNode
            
            l = l.next -- peek next list in element
            if l.data.tokType == TokenType.EQUALS then
                
                node.left = {val = bnfTokens.V_DEC}
                node = node.left
                
                tempNode = node -- re assign top node

                node.left = {val = bnfTokens.VAR_ID}
                node = node.left
                node.left = {val = bnfTokens.IDENTIFIER}
                slist:insertTail(node.left.val)

                node = node.left

                node = tempNode -- return to top Node
                node.center = {val = bnfTokens["="]}
                slist:insertTail(node.center.val)

                node.right = {val = bnfTokens.VAR_INIT}
                node = node.right

                node.left = {val = bnfTokens.EXP}
                node = node.left

            else
                
                node.left = {val = bnfTokens.V_DEC}
                node = node.left
                if l.data.tokType == TokenType.COMMA then --peek comma sign
                    node.center = {val = bnfTokens[","]}
                end
                tempNode = node -- re assign top node

                node.left = {val = bnfTokens.VAR_ID}
                node = node.left
                node.left = {val = bnfTokens.IDENTIFIER}
                slist:insertTail(node.left.val)

                l = l.prev

            end
        elseif l.data.tokType == TokenType.TERMINATOR  then
            slist:insertTail(bnfTokens[";"])

            break -- end line
        elseif not operFlag and not secondFlag and equalFlag and l.next.data.tokType == TokenType.OPERATOR then -- peek at if there are operators
            operFlag = true
            node.left = {val = bnfTokens.ASSIGN_EXP}
            node = node.left
            node.left = {val = bnfTokens.OPER_EXP}
            node = node.left

            if l.next.data.tokVal == "+" then
                node.left = {val = bnfTokens.ADD_EXP}
                node = node.left
                node.left = {val = bnfTokens.ADD_EXP}
                node = node.left
                
                tempOpHead = node
                
                node.center = {val = bnfTokens["+"]}
                node.right = {val = bnfTokens.MULTI_EXP}
                l = l.prev

            elseif l.next.data.tokVal == "-" then
                node.left = {val = bnfTokens.ADD_EXP}
                node = node.left
                node.left = {val = bnfTokens.ADD_EXP}
                node = node.left
                
                tempOpHead = node
                
                node.center = {val = bnfTokens["-"]}
                node.right = {val = bnfTokens.MULTI_EXP}
                l = l.prev

            elseif l.next.data.tokVal == "*" then
                node.left = {val = bnfTokens.MULTI_EXP}
                node = node.left
                node.left = {val = bnfTokens.MULTI_EXP}
                node = node.left
                
                tempOpHead = node
                
                node.center = {val = bnfTokens["*"]}
                node.right = {val = bnfTokens.UNARY_EXP}
                l = l.prev
            elseif l.next.data.tokVal == "/" then
                node.left = {val = bnfTokens.MULTI_EXP}
                node = node.left
                node.left = {val = bnfTokens.MULTI_EXP}
                node = node.left
                
                tempOpHead = node
                
                node.center = {val = bnfTokens["/"]}
                node.right = {val = bnfTokens.UNARY_EXP}
                l = l.prev
            end


        elseif l.data.tokType == TokenType.CONSTANT or l.data.tokType == TokenType.NUMBER
        or l.data.tokType == TokenType.STRING
        or l.data.tokType == TokenType.IDENTIFIER
        then -- IF CONSTANTS
            if not operFlag then
                node.left = {val = bnfTokens.CONST_EXP}
                node = node.left
            else
                secondFlag = true
            end

            ::UNARY::

            node.left = {val = bnfTokens.LITERAL}
            node = node.left

            if IsNumeric(l.data.tokVal) and l.next.data.tokType == TokenType.POINT and IsNumeric(l.next.next.data.tokVal) then --peek the float value
                -- print(bnfTokens["EXP"])
                tempNode = node -- re assign top node

                node.left = {val = bnfTokens.FLOAT_L}
                -- node = node.left
                node.center = {val = bnfTokens["."]}
                -- node = node.center
                node.right = {val = bnfTokens.FLOAT_L}
                slist:insertTail(node.right.val)
                l = l.next.next
                node = node.right
            elseif IsNumeric(l.data.tokVal) then
                node.left = {val = bnfTokens.INTEGRAL_L}
                slist:insertTail(node.left.val)
            elseif l.data.tokVal == "true" or l.data.tokVal == "false" then
                node.left = {val = bnfTokens.BOOLEAN_L}
                slist:insertTail(node.left.val)
            elseif l.prev.data.tokVal == "\"" and not IsNumeric(l.data.tokVal) then
                if l.next ~= nil and l.next.data.tokVal == "\"" then
                    node.left = {val = bnfTokens.STRING_L}
                    slist:insertTail(node.left.val)
                end
            else
                node.left = {val = bnfTokens.IDENTIFIER}
                slist:insertTail(node.left.val)
            end

            node = node.left

            if secondFlag then
                operFlag = false
                secondFlag = false
                node = tempOpHead.right
                slist:insertTail(tempOpHead.center.val)

                l = l.next.next

                goto UNARY
            end
        end

        if l.next ~= nil then
            l = l.next
        else
            break
        end
        
    end

    return tree
end

local printPTreeRightCtr = 1
function PrintParseTree(PTree, level)
    local p = PTree
    local amp = 7
    if not p then
        print("---")
        return
    end

    if p.left then
        io.write("  ",string.char(205),string.char(205),string.char(205)," <", bnfTokens[p.left.val], ">")
        PrintParseTree(p.left, level+1)
    end

    if p.center then
        io.write("\n ")
        for i = printPTreeRightCtr*level*amp, 0, -1 do
            io.write("  ")
        end
        io.write( string.char(200))
        io.write("  ",string.char(205),string.char(205),string.char(205)," <", bnfTokens[p.center.val], ">")
        PrintParseTree(p.center, level+1)
    end

    if p.right then
        
        io.write("\n ")
        for i = printPTreeRightCtr*level*amp, 0, -1 do
            io.write("  ")
        end
        io.write( string.char(200))
        io.write(" ",string.char(205),string.char(205),string.char(205)," <", bnfTokens[p.right.val], ">")
        PrintParseTree(p.right, level+1)
        printPTreeRightCtr = printPTreeRightCtr + 1

    end
end

function Syntax_Analyzer:new(obj)
    obj = obj or {}
    self.__index = self
    return setmetatable(obj, self)
end

function Syntax_Analyzer:SyntaxParser(sInput)
    print(sInput)
    local tokens = Lexer:Tokenizer(sInput)

    local SLIST = linkedlist()

    
    local success = false
    local message = ""

    local parseTree = nil

    if tokens.head ~= nil then -- check head if null
        parseTree = Build_parse_tree(tokens.head, SLIST)

        -- print("HEAD SYNTAX HERE", tokens.data.tokVal)
        message, success = GrammarRules(tokens.head, tokens.head.next)
        EqFlag = false

         -- check if boolean data type
        if success then
            message = "Compilation Success"
        else
            message = "Compilation Error: \n" .. message
        end


    else
        EqFlag = false
        message = "Invalid statement"
    end

    print("Parse Tree")
    PrintParseTree(parseTree, 0)

    print("\n\nSTACK Linked List")
    local l = SLIST.head
    while l do

        if l == nil then
            return
        end
        print(bnfTokens[l.data])
        l = l.next
        
    end

    return tokens, SLIST, parseTree, message, success
end

return Syntax_Analyzer