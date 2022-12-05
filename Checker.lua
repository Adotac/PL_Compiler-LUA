local chkr = {}

local dataTypes = {}
local keywords = {}

local function dataInit()
    table.insert(dataTypes,"byte");
    table.insert(dataTypes,"short");
    table.insert(dataTypes,"int");
    table.insert(dataTypes,"long");
    table.insert(dataTypes,"float");
    table.insert(dataTypes,"double");
    table.insert(dataTypes,"char");
    table.insert(dataTypes,"String");
    table.insert(dataTypes,"boolean");
end

local function keyInit()
    table.insert(keywords,"abstract");
    table.insert(keywords,"assert");
    table.insert(keywords,"break");
    table.insert(keywords,"case");
    table.insert(keywords,"catch");
    table.insert(keywords,"class");
    table.insert(keywords,"continue");
    table.insert(keywords,"const");
    table.insert(keywords,"default");
    table.insert(keywords,"do");
    table.insert(keywords,"else");
    table.insert(keywords,"enum");
    table.insert(keywords,"exports");
    table.insert(keywords,"extends");
    table.insert(keywords,"final");
    table.insert(keywords,"finally");
    table.insert(keywords,"for");
    table.insert(keywords,"goto");
    table.insert(keywords,"if");
    table.insert(keywords,"implements");
    table.insert(keywords,"import");
    table.insert(keywords,"instanceof");
    table.insert(keywords,"interface");
    table.insert(keywords,"module");
    table.insert(keywords,"native");
    table.insert(keywords,"new");
    table.insert(keywords,"package");
    table.insert(keywords,"private");
    table.insert(keywords,"protected");
    table.insert(keywords,"public");
    table.insert(keywords,"requires");
    table.insert(keywords,"return");
    table.insert(keywords,"short");
    table.insert(keywords,"static");
    table.insert(keywords,"strictfp");
    table.insert(keywords,"super");
    table.insert(keywords,"switch");
    table.insert(keywords,"synchronized");
    table.insert(keywords,"this");
    table.insert(keywords,"throw");
    table.insert(keywords,"throws");
    table.insert(keywords,"transient");
    table.insert(keywords,"try");
    table.insert(keywords,"var");
    table.insert(keywords,"void");
    table.insert(keywords,"volatile");
    table.insert(keywords,"while");
end

dataInit()
keyInit()

function chkr.isDataType(val)
    for i = 1, #dataTypes do
        if dataTypes[i] == val then
            return true
        end
    end
    return false
end

function chkr.isKeyword(val)
    for i = 1, #keywords do
        if keywords[i] == val then
            return true
        end
    end
    return false
end


return chkr