local enumTokens = require 'tokType'
local TokenType = enumTokens.getTokTypes()
-- meta class
local Token = {}
local Token_mt = {__index = Token}
-- base class method

function Token:new(typ, val)
    -- obj = {}
    self.__index = Token

    self.type = typ
    self.value = val

    return setmetatable({}, Token_mt)
end

function Token:__toString()
    return string.format("\n %q : <%s>", TokenType[self.type], self.value)
end

return Token