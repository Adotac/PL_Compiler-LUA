local lexer = require 'lexical_analyzer'
local syntax = require 'syntax_analyzer'
local semantic = require 'semantic_analyzer'

LEX = lexer:new(nil)
SA = syntax:new(nil)
SE = semantic:new(nil)

-- str = 'int a = 2 + 1;'

print("Enter code: ")
local str = io.read()

-- tok = LEX:Tokenizer(str)

SE:AnalyzeCode(str)


