local _, addonTable = ... -- make use of the default addon namespace

---@class DBRT : AceAddon-3.0 @define DBRT_Main
addonTable.DBRT = LibStub("AceAddon-3.0"):NewAddon("DBRT")


-- Init
local DBRT = addonTable.DBRT
_G["DBRT"] = DBRT
DBRT["Version"] = "0a"
local me = DBRT.name

-- Local aliases
local t,f = true,false
local function full_gds(Object,ID,Message)
    return DBDT:GenDebugString(Object,ID,Message)
end
local function gds(ID,Message)
    return DBDT:GenDebugString(me,ID,Message)
end


function DBRT:GetCutOff(Standing)
    local type = type(Standing)
    local valid = (EQ(type,"string") or EQ(type,"number"))
    if Not(valid) then Standing = "Hated" end 
    if EQ(type,"number") then
        Standing = DBDT["StringTables"]["StandingID"][Standing]
    end

    return DBDT:Numcheck(DBDT["CONSTANTS"]["ReputationCutOffs"][Standing])
end

function DBRT:GetRepColor(Standing)
    return DBCol["ColorTable"]["Standing"][Standing]["normalised"]
end

function DBRT:NormaliseReputationValue(InputValue)
    InputValue = DBDT:Numcheck(InputValue)
    return InputValue+42000
end

-- Globally accessible alias for NormaliseReputationValue
function DBRT:p42(n1)
    return DBRT:NormaliseReputationValue(n1)
end


-- Try setting global p42
if DBDT:TestValue("p42", true, true, "DBRT Init") then
    function p42(n1)
        return DBRT:NormaliseReputationValue(n1)
    end
end

DBDT:Report(me.." [Main]","DBRT Version ["..DBRT["Version"].."] loaded.","DBRT")