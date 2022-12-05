local tokType = {}

function Enum(tbl)
    local length = #tbl
    for i = 1, length do
        local v = tbl[i]
        tbl[v] = i
    end

    return tbl
end

function tokType.getTokTypes()
    local TokenTypes = Enum {
        "LPUNCTUATION", "RPUNCTUATION", "PUNCTUATION",
        "LPARA", "RPARA",
        "COMMA", "DOUBLE_QUOTE", "POINT",
        "DATATYPE", "IDENTIFIER", "KEYWORD",
        "OPERATOR", "EQUALS",
        "CONSTANT", "NUMBER", "STRING",
        "COLON", "TERMINATOR"
    }

    return TokenTypes
end

return tokType
