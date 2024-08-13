-- Stolen from DevTool, thanks guys. :)
local _, addonTable = ... -- make use of the default addon namespace

---@class DBDT : AceAddon-3.0 @define The main addon object for the DevTool addon
addonTable.DBDT = LibStub("AceAddon-3.0"):NewAddon("DBDT")
local DBDT = addonTable.DBDT

-- add global reference to the addon object
_G["DBDT"] = addonTable.DBDT
_G["DBDebugTable"] = DBDebugTable
local DBDebugTable = {}
local fontList = {}
local SharedMedia = false

if LibStub then
    SharedMedia = LibStub("LibSharedMedia-3.0");
    fontList = {
        ["camb"] = SharedMedia:Fetch("font", "cambria"),
        ["math"] = SharedMedia:Fetch("font", "DejaVuMathTeXGyre"),
        ["dsans"] = SharedMedia:Fetch("font", "DejaVuSans"),
        ["code"] = SharedMedia:Fetch("font", "DejaVuSansCode"),
        ["dmono"] = SharedMedia:Fetch("font", "DejaVuSansMono"),
        ["mei"] = SharedMedia:Fetch("font", "meiryo"),
        ["noto"] = SharedMedia:Fetch("font", "NotoSans"),
        ["nmono"] = SharedMedia:Fetch("font", "NotoSansMono"),
        ["rmono"] = SharedMedia:Fetch("font", "RobotoMono"),
        ["seg"] = SharedMedia:Fetch("font", "segoeui"),
        ["ubun"] = SharedMedia:Fetch("font", "Ubuntu"),
        ["umono"] = SharedMedia:Fetch("font", "UbuntuMono"),
    }
end

DBDebugTable["SharedMedia"] = SharedMedia

-- DB_Dependencies setup
local DB_Dependencies = {["DevTool"] = false, ["WeakAuras"] = false}
for key, value in pairs(DB_Dependencies) do
    DB_Dependencies[key] = (C_AddOns.IsAddOnLoaded(key) or false)
end
_G["DB_Dependencies"] = DB_Dependencies
local dbdtstart = "=== DBDT ==="
local dbdtend = "=== END ==="

-- Set min/max to known good numbers
local DB_Integers = {["min"] = -1e15,["max"] = 1e15}
_G["DB_Integers"] = DB_Integers

-- Some global variable stuff
local bCT = {
    [true] = 1,
    [false] = 0,
}
_G["DB_bct"] = bCT


-- ???
local function genMinMax(vmin,vmax)
    return ({
        ["min"] = vmin,
        ["max"] = vmax,
    })
end

-- USAGE
function DBDT:Help(function_name)
    DBDT:PrintHelp(function_name)
end

function DBDT:PrintHelp(function_name)
    local types = {"string","boolean","number","table"}
    local sany = "any"
    local sstring = "string"
    local snumber = "number"
    local stable = "table"
    local sboolean = "boolean"
    local bools = {true,false}
    local returnObj
    local retMsg = ""
    local genericMinMax = {
        ["min"] = (DB_Integers["min"]),
        ["max"] = (DB_Integers["max"]),
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
                ["value"] = genMinMax(0,DB_Integers["max"]),
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
        ["PrintHelp"] = {
            ["function_name"] = {
                ["value"] = sany,
                ["type"] = sstring,
            },
        },
        ["ItemInfo"] = {
            ["itemID"] = {
                ["value"] = genMinMax(1,DB_Integers["max"]),
                ["type"] = snumber,
            },
        },
        ["FindMinMax"] = {
            ["power"] = {
                ["value"] = genMinMax(0,DB_Integers["max"]),
                ["type"] = snumber
            }
        }
    }

    if DBDT:Nilcheck(function_name,"boolean") ~= false then
        returnObj = functions[function_name]
        retMsg = "DBDT - Help: "..function_name
    else
        returnObj = functions
        retMsg = "DBDT - Help"
    end

    DBDT:DBPrint(returnObj,true,true,retMsg,false)
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
        ["table"] = {},
        ["s"] = "",
        ["n"] = 0,
        ["b"] = false,
        ["t"] = {},
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
        return DBDT:Clamp(payload,(DB_Integers["min"]),(DB_Integers["max"]))
    end
end

function DBDT:Clamp(value,vmin,vmax)
    -- Nilcheck
    value = DBDT:Nilcheck(value, "number")
    if not DBDT:Nilcheck(vmin,"boolean") then vmin = DB_Integers["min"] end
    if not DBDT:Nilcheck(vmax,"boolean") then vmax = DB_Integers["max"] end
    
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
        tmp["itemName"],tmp["itemLink"],tmp["itemQuality"],tmp["itemLevel"],tmp["itemMinLevel"],tmp["itemType"],tmp["itemSubType"],tmp["itemStackCount"],tmp["itemEquipLoc"],tmp["itemTexture"],tmp["sellPrice"],tmp["classID"],tmp["subclassID"],tmp["bindType"],tmp["expansionID"],tmp["setID"],tmp["isCraftingReagent"] = GetItemInfo(DBDT:Clamp(itemID,1,DB_Integers["max"]))
        DBDT:DBPrint({["ItemID"] = itemID,["ItemData"] = tmp}, true, true, "DBDT - ItemInfo", false)
    end
end

function DBDT:PadNumber(inputnumber,targetpower,padbehind)
    padbehind = DBDT:Nilcheck(padbehind,"boolean")
    if DBDT:Typecheck(targetpower,"number") then
        targetpower = DBDT:Clamp(targetpower,0,1000)
    end

    
    local returnString = tostring(inputnumber)
    local numeraltarget = targetpower
    local zeroes = -1 --We assume a minimum of 0.
    if DBDT:Typecheck(inputnumber,"number") then
        while inputnumber < numeraltarget do
            zeroes = zeroes + 1
            numeraltarget = DBDT:Clamp(numeraltarget / 10,1,DB_Integers["max"])
        end
        
        while zeroes > 0 do
            if padbehind then
                returnString = returnString.."0"
            else
                returnString = "0"..returnString
            end
        end
    end

    return returnString
end

function DBDT:RecursiveTableSearch(inputtable,passedcount)
    passedcount = DBDT:Nilcheck(passedcount,"number")
    local returnTable = {}
    local count = 0
    local tmpKey = false
    local subcount = 0
    if DBDT:Typecheck(inputtable,"table") then
        for key, value in pairs(inputtable) do
            count = count + 1
                tmpKey = DBDT:Nilcheck(key)
                if tmpKey == false then
                    tmpKey = "subtable_"..DBDT:PadNumber(count,4)
                end
            if DBDT:Typecheck(value,"table") then
                subcount = subcount + 1
                returnTable[tmpKey] = DBDT:RecursiveTableSearch(value,subcount)
            else
                subcount = subcount + 1
                returnTable[tmpKey]["subvalue_"..DBDT:PadNumber(subcount,4)] = value
            end
        end
    else
        returnTable["subvalue_"..DBDT:PadNumber(passedcount,4)] = inputtable
    end
    return returnTable
end

function DBDT:Find(what,where)
    local searchTable = {
        ["found"] = false,
        ["value"] = {},
    }

    if what ~= false then
        what = DBDT:Nilcheck(what,"boolean")
        if what == false then
            return searchTable
        end
    end
    
    local valType = type(what)
    local count = 0
    local deflatedTable = DBDT:RecursiveTableSearch(where)
    for key,value in pairs(deflatedTable) do
        local submatched = false
        -- Compare
        if valType == "string" then
            submatched = (string.lower(tostring(value)) == string.lower(what))
        else
            submatched = (value == what)
        end
        -- Found something?
        if submatched then
            count = count + 1
            searchTable["found"] = (submatched or searchTable["found"])
            searchTable["value"]["match_"..DBDT:PadNumber(count,4)] = {["key"]=key,["value"]=value}
        end
    end

    return searchTable
end

function DBDT:FindMinMax(power)
    --Nilcheck
    power = DBDT:Nilcheck(power)
    if power == false then
        power = 5000
    end

    local returnTable = {
        ["value"] = 0,
        ["power"] = power
    }
    --local tmp0,tmp1,tmp2,tmp3,tmp4,tmp5,tmpPower = 0

    -- Count
    local tmp = math.huge
    while tmp == math.huge do
        tmp = math.pow(2,power)
        if tmp == math.huge then
            power = power - 1
        end
    end
    returnTable["power"] = power
    returnTable["value"] = {
        ["min"] = -tmp,
        ["max"] = tmp,
    }

    --Return
    return returnTable
end

function DBDT:RTC(value,target)
    value = DBDT:Clamp(value)
    target = DBDT:Clamp(target)

    return (math.floor(value/target)*target)
end

function DBDT:AllAbove(value,limit)
    limit = DBDT:Nilcheck(limit,"number")
    value = DBDT:Nilcheck(value)
    local retbool = false

    if not value then
        return retbool
    elseif DBDT:Typecheck(value,"table") then
        for key,value in pairs(value) do
            retbool = (retbool and (value > limit))
        end
    elseif DBDT:Typecheck(value,"number") then
        retbool = (value > limit)
    end

    return retbool
end

function DBDT:EQ(val1,val2)
    return (val1 == val2)
end

function DBDT:NE(val1,val2)
    return (val1 ~= val2)
end

function DBDT:GenDebugString(object,id,message)
    object = DBDT:Nilcheck(object)
    id = DBDT:Nilcheck(id)
    message = DBDT:Nilcheck(message)
    local correctformat = (object and id)
    local hasmessage = (message and true)
    if correctformat then
        local generatedString = tostring(object).."["..tostring(id).."]"
        if hasmessage then
            generatedString = generatedString.." - "..tostring(message)
        end
        return generatedString
    end
end

function DBDT:GetFont(sAlias)
    DBDT:Nilcheck(sAlias)
    if not sAlias then
        return nil
    end

    if (SharedMedia or false) then
        if (fontList[sAlias] or false) then
            return fontList[sAlias]
        else
            return nil
        end
    else
        return nil
    end
end

-- Dynamic gen stuff
-- Generate dynamic min/max
DB_Integers = DBDT:FindMinMax(5000)["value"]
if DBDT:NE(_G["DB_Integers"],DB_Integers) then
    _G["DB_Integers"] = DB_Integers
end