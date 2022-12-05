local b = {}

function Enum(tbl)
    local length = #tbl
    for i = 1, length do
        local v = tbl[i]
        tbl[v] = i
    end

    return tbl
end

function b.getBNF()
    local BNF = Enum {
        --Declarations
        "VAR_DECN",
        "DTYPE",
        "VAR_DECS", "V_DEC",
        "VAR_INIT", "VAR_ID",
        "IDENTIFIER",
        --Types
        "NUMERIC_TYPE", "BOOLEAN_TYPE",
        "INTEGRAL_TYPE", --byte | short | int | long | char
        "FLOAT_TYPE", --float | double
        "STRING_TYPE",
        --Expressions
        "EXP",
        "ASSIGN_EXP", "CONST_EXP",
        
        "OPER_EXP",
        "+","-","*","/",
        "ADD_EXP", "MULTI_EXP",
        "UNARY_EXP",

        --Tokens
        "LITERAL",
        "INTEGRAL_L", "FLOAT_L", "BOOLEAN_L", "CHAR_L", "STRING_L", "NULL_L",
        
        -- (non BNF purpose, just tokens in the grammar)
        "=", ".", ",",";",
    }

    return BNF
end

return b
