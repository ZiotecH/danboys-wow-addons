-- Stolen from DevTool, thanks guys. :)
local _, addonTable = ... -- make use of the default addon namespace
local me = "DBDT"

---@class DBDT : AceAddon-3.0 @define The main addon object for the DevTool addon
addonTable.DBDT = LibStub("AceAddon-3.0"):NewAddon("DBDT")
local DBDT = addonTable.DBDT

-- add global reference to the addon object
_G["DBDT"] = addonTable.DBDT
local DBDebugTable = {}
DBDT["DBDebugTable"] = DBDebugTable
DBDT["DBDebugTable"]["Saved Colors"] = 0
local fontList = {}
local SharedMedia = false
DBDT["PrintDebug"] = false
DBDT["ColorTable"] = {}
DBDT["sindent"] = "▸"
local ColorTable = DBDT["ColorTable"]
local si = DBDT["sindent"]
local t = true
local f = false

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
local DB_Dependencies = {
    ["DevTool"] = false,
    ["WeakAuras"] = false,
    ["!BugGrabber"] = false,
}

for key, value in pairs(DB_Dependencies) do
    DB_Dependencies[key] = (C_AddOns.IsAddOnLoaded(key) or false)
end

DBDT["DB_Dependencies"] = DB_Dependencies


local dbdtstart = "=== DBDT ==="
local dbdtend = "=== END ==="

-- Set min/max to known good numbers
DBDT["DBIntegers"] = {["min"] = -1e15,["max"] = 1e15} 
local DB_Integers = DBDT["DBIntegers"]


-- Some global variable stuff
local bCT = {
    [true] = 1,
    [false] = 0,
}
DBDT["bCT"] = bCT

-- Toggle PrintDebug
function DBDT:TDebug()
    DBDT["PrintDebug"] = (not  DBDT["PrintDebug"])
    DBDT:DBPrint(
        tostring(DBDT["PrintDebug"]),
        f,
        f,
        DBDT:GenDebugString("DBDT","TDebug"),
        f
    )
end

-- ???
local function genMinMax(vmin,vmax)
    return (
        {
            ["min"] = vmin,
            ["max"] = vmax,
        }
    )
end

function dp(InputData)
    DBDT:DBPrint(InputData,true,true,DBDT:GenDebugString("DBDT","Console",type(InputData)))
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
        retMsg = tostring(function_name)
    else
        returnObj = functions
        retMsg = nil
    end

    DBDT:DBPrint(
        returnObj,
        true,
        true,
        DBDT:GenDebugString("DBDT","Help",retMsg),
        false
    )
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

function DBDT:Boolcheck(payload)
    return (payload and DBDT:Nilcheck(payload))
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

function DBDT:Timestamp()
    local s1 = DBCol:GC("DarkGray"):Get()
    return "|c"..s1.."["..date("%X").."]|r"
end
-- Printing data
local function dtad(payload, message, multi)
    multi = DBDT:Nilcheck(multi,"boolean")
    if not DBDT:Typecheck(multi,"boolean") then
        multi = false
    end

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
        DBDT:DBPrint(
            {
                ["ItemID"] = itemID,
                ["ItemData"] = tmp
            },
            true,
            true,
            DBDT:GenDebugString("DBDT","ItemInfo",itemID),
            false
        )
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

function DBDT:PadSpace(v1)
    local ret = ""
    if (v1 > 0) then
        for v2 = 1,v1 do
            ret = ret.." "
        end
    elseif (v1 == 1) then
        ret = " "
    end
    return ret
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
    local correctformat = (object and true)
    local hasmessage = (message and true)
    if correctformat then
        local generatedString = DBDT:Timestamp().." "..tostring(object).."["..tostring(id).."]"
        if hasmessage then
            generatedString = generatedString.." - "..tostring(message)
        end
        return generatedString
    end
end
local function gds(s1,a1,o1)
    return DBDT:GenDebugString(s1,a1,o1)
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

function DBDT:HF(value)
  value = DBDT:Nilcheck(value,"number")
  if DBDT:EQ(value,0) then
    return "00"
  else
    return string.format("%2X",value)
  end
end

function DBDT:ColorHelper(red,green,blue,alpha)
  -- Clamp and Nilcheck
  red   = DBDT:Clamp(DBDT:Nilcheck(red,"number"),0,255)
  green = DBDT:Clamp(DBDT:Nilcheck(green,"number"),0,255)
  blue  = DBDT:Clamp(DBDT:Nilcheck(blue,"number"),0,255)
  alpha = DBDT:Clamp(DBDT:Nilcheck(alpha,"number"),0,255)
  
  
  -- Hexadecimal colors
  local hr = DBDT:HF(red)
  local hg = DBDT:HF(green)
  local hb = DBDT:HF(blue)
  local ha = DBDT:HF(alpha)
  
  local ReturnTable = {}
  -- Hexadecimal Table
  ReturnTable["hex"] = {
    ["argb"] = ha..hr..hg..hb,
    ["rgba"] = hr..hg..hb..ha,
  }
  
  -- RGBA Table
  ReturnTable["rgba"] = {
    ["red"]     = red,
    ["green"]   = green,
    ["blue"]    = blue,
    ["alpha"]   = alpha,
  }
  
  -- TextColor String
  ReturnTable["string"] = {
    ["start"]   = "|c"..ReturnTable["hex"]["argb"],
    ["end"]     = "|r",
  }
  
  -- Normalised RGBA
  ReturnTable["normalised"] = {
    ["red"]     = DBDT:Clamp((red/255),0,1),
    ["green"]   = DBDT:Clamp((green/255),0,1),
    ["blue"]    = DBDT:Clamp((blue/255),0,1),
    ["alpha"]   = DBDT:Clamp((alpha/255),0,1),
  }

  function ReturnTable:GetHex()
    return ReturnTable["hex"]["argb"]
  end
  function ReturnTable:GetNorm()
    return ReturnTable["normalised"]["red"],ReturnTable["normalised"]["green"],ReturnTable["normalised"]["blue"],ReturnTable["normalised"]["alpha"]
  end
  function ReturnTable:GetString()
    return ReturnTable["string"]["start"],ReturnTable["string"]["end"]
  end
  function ReturnTable:GetRGB()
    return ReturnTable["rgba"]["red"],ReturnTable["rgba"]["green"],ReturnTable["rgba"]["blue"],ReturnTable["rgba"]["alpha"]
  end
  function ReturnTable:Get()
    return ReturnTable:GetHex()
  end
  
  return ReturnTable
end

function DBDT:ColorString(ColorTable,InputString)
    return ColorTable["string"]["start"]..InputString..ColorTable["string"]["end"]
end

function DBDT:AddColor(red,green,blue,alpha,name)
  DBDT["ColorTable"][name] = DBDT:ColorHelper(red,green,blue,alpha)
  DBDT["DBDebugTable"]["Saved Colors"] = DBDT["DBDebugTable"]["Saved Colors"] + 1
end

function DBDT:GetNormalisedColor(ColorTable)
    local r = ColorTable["normalised"]["red"]
    local g = ColorTable["normalised"]["green"]
    local b = ColorTable["normalised"]["blue"]
    local a = ColorTable["normalised"]["alpha"]

    return r,g,b,a
end

function DBDT:GetColor(name)
    local exists = DBDT:Nilcheck((DBDT["ColorTable"][name] and true),"boolean")
    if exists then
        return DBDT["ColorTable"][name]
    else
        return false
    end
end

function DBDT:TestColor(name)
    if DBDT:Nilcheck(name) then
        local tmpCol = DBDT:GetColor(name)
        if tmpCol then
            DBDT:DBPrint(
                tmpCol["string"]["start"] .. "Testing the color \"" .. name .. "\"." .. tmpCol["string"]["end"],
                _,
                _,
                gds("DBDT","TestColor")
            )
        end
    else
        DBDT:DBPrint(
            true,_,_,"TESTING "..tostring(DBDT["DBDebugTable"]["Saved Colors"]).." COLORS"
        )
        for colname,_ in pairs(DBDT["ColorTable"]) do
            DBDT:TestColor(colname)
        end
    end
end

function DBDT:TestFont(font)
    DevTool["codefont"] = DBDT:GetFont(font)
    DBDT:DBPrint(
        {
            ["Font"] = DBDT:GetFont(font),
            ["Indent"] = si,
            ["TestStrings"] = {
                [1] = "DBDT[TestFont] - "..font,
                [2] = "DBDT"..si.."TestFont - "..font,
                [3] = "DBDT"..si.."TestFont"..si.." "..font,
            },
            ["codefont"] = DevTool["codefont"]
        },
        true,
        true,
        DBDT:GenDebugString("DBDT","TestFont"),
        false
    )
end

function DBDT:CountChildren(t1)
    local count = 0
    if DBDT:Typecheck(t1,"table") then
        for _ in pairs(t1) do
            count = count + 1
        end
    end
    return count
end

function DBDT:Increment(n1,n2)
    n1 = DBDT:Nilcheck(n1,"number")
    n2 = DBDT:Nilcheck(n2,"number")
    return (n1 + n2)
end

function DBDT:Indent(n1,ts)
    n1 = DBDT:Nilcheck(n1,"number")
    ts = DBDT:Boolcheck(ts)
    local ret = tostring(DBDT:PadSpace(n1))..DBDT["sindent"]
    if ts then
        ret = ret.." "
    end
end


-- Export global functions
function Nilcheck(a1,s1)
   return DBDT:Nilcheck(a1,s1)
end
function Typecheck(a1,s1)
   return DBDT:Typecheck(a1,a1)
end
function Numcheck(a1)
   return DBDT:Numcheck(a1)
end
function SetPrecision(n1,n2)
   return DBDT:SetPrecision(n1,n2)
end
function Split(s1,s2)
   return DBDT:Split(s1,s2)
end
function SetPower(n1,n2)
   return DBDT:SetPower(n1,n2)
end
function GetPercent(n1,n2)
   return DBDT:GetPercent(n1,n2)
end
function RTC(n1,n2)
   return DBDT:RTC(n1,n2)
end
function EQ(a1,a2)
   return DBDT:EQ(a1,a2)
end
function NE(a1,a2)
   return DBDT:NE(a1,a2)
end
function inc(n1,n2)
   return DBDT:Increment(n1,n2)
end

--function gds(s1,a1,o1)
--    return DBDT:GenDebugString(s1,a1,o1)
--end

-- FINISHING UP VARIABLES
DB_Integers = DBDT:FindMinMax(5000)["value"]

-- Tell EVERYONE we're online.
_G["dbdt_loaded"] = true

-- EOF