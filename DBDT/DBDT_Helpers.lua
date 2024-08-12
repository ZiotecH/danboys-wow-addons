-- Stolen from DevTool, thanks guys. :)
local _, addonTable = ... -- make use of the default addon namespace

---@class DBDT : AceAddon-3.0 @define The main addon object for the DevTool addon
addonTable.DBDT = LibStub("AceAddon-3.0"):NewAddon("DBDT")
local DBDT = addonTable.DBDT

-- add global reference to the addon object
_G["DBDT"] = addonTable.DBDT

-- DB_Dependencies setup
local DB_Dependencies = {["DevTool"] = false, ["WeakAuras"] = false}
for key, value in pairs(DB_Dependencies) do
    DB_Dependencies[key] = ((_G[key] and true) or false)
end
_G["DB_Dependencies"] = DB_Dependencies
local dbdtstart = "=== DBDT ==="
local dbdtend = "=== END ==="

local function genMinMax(vmin,vmax)
    return ({
        ["min"] = vmin,
        ["max"] = vmax,
    })
end
-- USAGE
function DBDT:PrintHelp()
    local types = {"string","boolean","number","table"}
    local sany = "any"
    local sstring = "string"
    local snumber = "number"
    local stable = "table"
    local sboolean = "boolean"
    local bools = {true,false}
    local genericMinMax = {
        ["min"] = (-math.huge + 1),
        ["max"] = (math.huge - 1),
    }
    local functions = {
        ["Nilcheck"] = {
            ["payload"] = {
                ["value"] = sany,
                ["type"] = sany,
            },
            ["returntype"] = {
                ["value"] = types,
                ["type"] = sstring,
            }
        },
        ["Typecheck"] = {
            ["payload"] = {
                ["value"] = sany,
                ["type"] = sany,
            },
            ["wantedtype"] = {
                ["value"] = types,
                ["type"] = sstring
            }
        },
        ["Numcheck"] = {
            ["payload"] = {
                ["value"] = sany,
                ["type"] = sany,
            }
        },
        ["Clamp"] = {
            ["value"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
            ["vmin"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
            ["vmax"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            }
        },
        ["Lerp"] = {
            ["val1"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
            ["val2"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber
            },
            ["progress"] = {
                ["value"] = genMinMax(0,1),
                ["type"] = snumber
            },
        },
        ["SetPrecision"] = {
            ["value"] = {
                ["value"] = genMinMax(0,(math.huge-1)),
                ["type"] = snumber,
            }
        },
        ["Split"] = {
            ["inputString"] = {
                ["value"] = sany,
                ["type"] = sstring,
            },
            ["separator"] = {
                ["value"] = sany,
                ["type"] = sstring,
            }
        },
        ["DBPrint"] = {
            ["payload"] = {
                ["value"] = sany,
                ["type"] = types
            },
            ["printStart"] = {
                ["value"] = bools,
                ["type"] = sboolean
            },
            ["printEnd"] = {
                ["value"] = bools,
                ["type"] = sboolean
            },
            ["message"] = {
                ["value"] = sany,
                ["type"] = sstring,
            },
            ["multi"] = {
                ["value"] = bools,
                ["type"] = sboolean
            },
        },
        ["SetPower"] = {
            ["num"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
            ["target"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
        },
        ["GetPercent"] = {
            ["current"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
            ["max"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
        },
        ["GetDistance"] = {
            ["value"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
            ["target"] = {
                ["value"] = genericMinMax,
                ["type"] = snumber,
            },
        },
    }

    DBDT:DBPrint(functions,true,true,"DBDT - Help",false)
end

-- GLOBAL HELPER FUNCTIONS
function DBDT:Nilcheck(payload,returntype)
    -- Set returntype default to boolean
    if returntype == nil then
        returntype = "boolean"
    end

    -- table for returntypes
    local typeTable = {
        ["string"] = "",
        ["number"] = 0,
        ["boolean"] = false,
        ["table"] = {}
    }

    -- nilcheck the payload
    if payload == nil then
        payload = typeTable[returntype]
    end

    -- return the payload
    return payload
end

function DBDT:Typecheck(payload,wantedtype)
    return (type(payload) == wantedtype)
end

function DBDT:Numcheck(payload)
    -- Check if type isn't number and return 0, else return payload clamped to non-infinite.
    if (DBDT:Typecheck(payload,"number") == false) then
        return 0
    else
        return DBDT:Clamp(payload,(-math.huge+1),(math.huge-1))
    end
end

function DBDT:Clamp(value,vmin,vmax)
    -- Nilcheck
    value = DBDT:Nilcheck(value, "number")
    vmin = DBDT:Nilcheck(vmin, "number")
    vmax = DBDT:Nilcheck(vmax, "number")
    
    -- Sanity
    if vmin == vmax then
        vmin = 0
        vmax = 1
    end
    
    --Set value
    value = math.max(value,vmin)
    value = math.min(value,vmax)
    return value
end

function DBDT:Lerp(val1, val2, progress)
    val1 = DBDT:Nilcheck(val1)
    val2 = DBDT:Nilcheck(val2)
    progress = DBDT:Nilcheck(progress)
    local correct = (DBDT:Typecheck(val1,"number") and DBDT:Typecheck(val2,"number") and DBDT:Typecheck(progress,"number"))
    if correct then
        progress = DBDT:Clamp(progress,0,1)
        return (1 - progress) * val1 + progress * val2
    else
        return val1
    end
end

function DBDT:SetPrecision(value,precision)
    value = DBDT:Nilcheck(value)
    precision = DBDT:Nilcheck(precision)

    if not DBDT:Typecheck(precision,"number") then
        precision = 4
    end

    return (tonumber(string.format("%."..tostring(precision).."f", value)))
end

function DBDT:Split(inputString, separator)
    inputString = DBDT:Nilcheck(inputString)
    separator = DBDT:Nilcheck(separator)
    local invalidSeparator = ( (not separator) or (not DBDT:Typecheck(separator,"string")) )
    
    local returnTable = {}
    local index = 0
    
    if invalidSeparator then
        separator = ","
    end

    if DBDT:Typecheck(inputString,"string") then
        for match in string.gmatch(inputString, "([^" .. separator .. "]+)") do
            index = index + 1
            returnTable[index] = match
        end
    end
    -- debug
    if tDebug then
    end
    -- return
    return returnTable
end

-- Printing data
local function dtad(payload, message, multi)
    multi = (DBDT:Nilcheck(multi,"boolean") and Typecheck(multi,"boolean"))

    if (DBDT:Typecheck(payload,"table") and multi) then
        for key, value in pairs(payload) do
            DevTool:AddData(value, message)
        end
    elseif payload ~= nil then
        DevTool:AddData(payload, message)
    end
end

function DBDT:DBPrint(payload, printStart, printEnd, message, multi)
    printStart = DBDT:Nilcheck(printStart)
    printEnd = DBDT:Nilcheck(printEnd)

    if DB_Dependencies["DevTool"] then
        multi = DBDT:Nilcheck(multi,"boolean")
        dtad(payload, message, multi)
    elseif payload ~= nil then
        -- Print Start?
        if printStart then DEFAULT_CHAT_FRAME:AddMessage(dbdtstart,1,1,1) end
        -- Print each element of a table
        if type(payload) == "table" then
            for key, value in pairs(payload) do
                DEFAULT_CHAT_FRAME:AddMessage(" ▸ " .. tostring(key) .. ": " .. tostring(value))
            end
        -- Print payload as string
        else
            DEFAULT_CHAT_FRAME:AddMessage(" ▸ " .. tostring("payload"))
        end
        -- Print End?
        if printEnd then DEFAULT_CHAT_FRAME:AddMessage("=== END ===",1,1,1) end
    end
end

function DBDT:SetPower(num, target)
    return math.max(math.ceil(num/target)*target,target)
end

function DBDT:GetPercent(current,max)
    return string.format("%d",DBDT:Clamp(current/max,0,1)*100)
end

function DBDT:GetDistance(value,target)
    value = math.abs(value-target)
    return value
end

function DBDT:ItemInfo(itemID)
    if DBDT:Typecheck(itemID,"number") then
        local tmp={}
        tmp["itemName"],tmp["itemLink"],tmp["itemQuality"],tmp["itemLevel"],tmp["itemMinLevel"],tmp["itemType"],tmp["itemSubType"],tmp["itemStackCount"],tmp["itemEquipLoc"],tmp["itemTexture"],tmp["sellPrice"],tmp["classID"],tmp["subclassID"],tmp["bindType"],tmp["expansionID"],tmp["setID"],tmp["isCraftingReagent"] = GetItemInfo(itemID)
        DBDT:DBPrint({["ItemID:"] = itemID,["ItemData"] = tmp}, true, true, "DBDT - ItemInfo", false)
    end
end