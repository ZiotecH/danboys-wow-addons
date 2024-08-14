-- Stolen from DevTool, thanks guys. :)
local _, addonTable = ... -- make use of the default addon namespace

---@class DBDT : AceAddon-3.0 @define The main addon object for the DevTool addon
addonTable.DBDT = LibStub("AceAddon-3.0"):NewAddon("DBDT")
local DBDT = addonTable.DBDT

-- add global reference to the addon object
_G["DBDT"] = addonTable.DBDT
local DBDebugTable = {}
DBDT["DBDebugTable"] = DBDebugTable
local fontList = {}
local SharedMedia = false
DBDT["PrintDebug"] = false
local PrintDebug = DBDT["PrintDebug"]
DBDT["ColorTable"] = {}
local ColorTable = DBDT["ColorTable"]
local sindent = " ▸ "

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
    DBDT["PrintDebug"] = (true and not PrintDebug)
    PrintDebug = DBDT["PrintDebug"]
    DBDT:DBPrint(
        {
            ["Global"] = DBDT["PrintDebug"],
            ["Local"] = PrintDebug
        },
        true,
        true,
        DBDT:GenDebugString("DBDT","TDebug"),
        false
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
  
  return ReturnTable
end

function DBDT:ColorString(ColorTable,InputString)
    return ColorTable["string"]["start"]..InputString..ColorTable["string"]["end"]
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

-- Dynamic gen stuff
-- Generate dynamic min/max
DB_Integers = DBDT:FindMinMax(5000)["value"]

-- COLOR TABLE
-- To the extent possible I'll try to keep these close to the HTML standard
-- Live wikipedia URL;
-- https://en.wikipedia.org/wiki/Web_colors
-- WayBack [2024-08-12];
-- https://web.archive.org/web/20240812064856/https://en.wikipedia.org/wiki/Web_colors

-- All colors have the alpha component set to FF or it's equivalent in the table.
-- AddColor is meant for adding colors to the DBDT["ColorTable"].
-- Use DBDT:ColorHelper(red,greeb,blue,alpha) for a table based on your desired color.
-- Reference DBDT["ColorTable"][<color>] if you want to use any of the official ones.


-- =========================================================================
-- This is a long and annoying way to do it, use the DBCol functions instead
-- They are just wrappers for DBDT:ColorHelper, DBDT:GetNormalisedColor and 
-- DBDT:ColorString. They're called DBCol:CH, DBCol:GN and DBCol:CS 
-- respectively.
-- =========================================================================


-- Examples;
-- ### Sending a message ###
-- 
-- ## Arbitrary Color ##
-- local r,g,b,a = DBDT:GetNormalisedColor(DBDT:ColorHelper(142,86,249,255))
-- DEFAULT_CHAT_FRAME:AddMessage("My Message",r,g,b,a)
--
-- ## Existing Color ##
-- local r,g,b,a = DBDT:GetNormalisedColor(["ColorTable"]["Salmon"])
-- DEFAULT_CHAT_FRAME:AddMessage("Salmon Message",r,g,b,a)
--
-- ### Formatting text ###
--
-- ## Arbitrary Color ##
-- local MyColor = DBDT:ColorHelper(142,86,249,255)
-- local MyString = MyColor["string"]["start"].."My string"..MyColor["string"]["end"]
-- ## OR ##
-- local MyFirstColor = DBDT:ColorHelper(142,86,249,255)["hex"]["argb"]
-- local MyString = "|c"..MyFirstColor.."My string|r"
-- local MySecondString = "|c"..DBDT:ColorHelper(221,160,221,225)["hex"]["argb"].."My second string|r"
--
-- ## Existing Color ##
-- local OldLace = DBDT["ColorTable"]["OldLace"]
-- local MyString = OldLace["string"]["start"].."My string"..OldLace["string"]["end"]
-- ## OR ##
-- local MyString = "|c"..DBDT["ColorTable"]["hex"]["argb"].."My string|r"
--
--
-- ### Using DBDT:ColorText(ColorTable,InputString) ###
--
-- ## Arbitrary Color ##
-- local MyString = DBDT:ColorText(DBDT:ColorHelper(142,86,249,255), "My string")
--
-- ## Existing Color ##
-- local MyString = DBDT:ColorText(DBDT["ColorTable"]["Orchid"], "My string")

-- End of examples

-- Base Colors
DBDT:AddColor(0,0,0,255,"Black")                         -- (000000)
DBDT:AddColor(255,255,255,255,"White")                   -- (FFFFFF)
DBDT:AddColor(255,0,0,255,"Red")                         -- (FF0000)
DBDT:AddColor(0,128,0,255,"Green")                       -- (008000)
DBDT:AddColor(0,0,255,255,"Blue")                        -- (0000FF)
-- Official colors, see links above


-- Pink colors
DBDT:AddColor(219,112,147,255,"MediumVioletRed")         -- (C71585)
DBDT:AddColor(199,21,133,255,"DeepPink")                 -- (FF1493)
DBDT:AddColor(255,20,147,255,"PaleVioletRed")            -- (DB7093)
DBDT:AddColor(255,105,180,255,"HotPink")                 -- (FF69B4)
DBDT:AddColor(255,182,193,255,"LightPink")               -- (FFB6C1)
DBDT:AddColor(255,192,203,255,"Pink")                    -- (FFC0CB)
-- Red colors
DBDT:AddColor(139,0,0,255,"DarkRed")                     -- (8B0000)
DBDT:AddColor(178,34,34,255,"FireBrick")                 -- (B22222)
DBDT:AddColor(220,20,60,255,"Crimson")                   -- (DC143C)
DBDT:AddColor(205,92,92,255,"IndianRed")                 -- (CD5C5C)
DBDT:AddColor(240,128,128,255,"LightCoral")              -- (F08080)
DBDT:AddColor(250,128,114,255,"Salmon")                  -- (FA8072)
DBDT:AddColor(233,150,122,255,"DarkSalmon")              -- (E9967A)
DBDT:AddColor(255,160,122,255,"LightSalmon")             -- (FFA07A)
-- Orange colors
DBDT:AddColor(255,69,0,255,"OrangeRed")                  -- (FF4500)
DBDT:AddColor(255,99,71,255,"Tomato")                    -- (FF6347)
DBDT:AddColor(255,140,0,255,"DarkOrange")                -- (FF8C00)
DBDT:AddColor(255,127,80,255,"Coral")                    -- (FF7F50)
DBDT:AddColor(255,165,0,255,"Orange")                    -- (FFA500)
-- Yellow colors
DBDT:AddColor(189,183,107,255,"DarkKhaki")               -- (BDB76B)
DBDT:AddColor(255,215,0,255,"Gold")                      -- (FFD700)
DBDT:AddColor(240,230,140,255,"Khaki")                   -- (F0E68C)
DBDT:AddColor(255,218,185,255,"PeachPuff")               -- (FFDAB9)
DBDT:AddColor(255,255,0,255,"Yellow")                    -- (FFFF00)
DBDT:AddColor(238,232,170,255,"PaleGoldenrod")           -- (EEE8AA)
DBDT:AddColor(255,228,181,255,"Moccasin")                -- (FFE4B5)
DBDT:AddColor(255,239,213,255,"PapayaWhip")              -- (FFEFD5)
DBDT:AddColor(250,250,210,255,"LightGoldenrodYellow")    -- (FAFAD2)
DBDT:AddColor(255,250,205,255,"LemonChiffon")            -- (FFFACD)
DBDT:AddColor(255,255,224,255,"LightYellow")             -- (FFFFE0)
-- Brown colors
DBDT:AddColor(128,0,0,255,"Maroon")                      -- (800000)
DBDT:AddColor(165,42,42,255,"Brown")                     -- (A52A2A)
DBDT:AddColor(139,69,19,255,"SaddleBrown")               -- (8B4513)
DBDT:AddColor(160,82,45,255,"Sienna")                    -- (A0522D)
DBDT:AddColor(210,105,30,255,"Chocolate")                -- (D2691E)
DBDT:AddColor(184,134,11,255,"DarkGoldenrod")            -- (B8860B)
DBDT:AddColor(205,133,63,255,"Peru")                     -- (CD853F)
DBDT:AddColor(188,143,143,255,"RosyBrown")               -- (BC8F8F)
DBDT:AddColor(218,165,32,255,"Goldenrod")                -- (DAA520)
DBDT:AddColor(244,164,96,255,"SandyBrown")               -- (F4A460)
DBDT:AddColor(210,180,140,255,"Tan")                     -- (D2B48C)
DBDT:AddColor(222,184,135,255,"BurlyWood")               -- (DEB887)
DBDT:AddColor(245,222,179,255,"Wheat")                   -- (F5DEB3)
DBDT:AddColor(255,222,173,255,"NavajoWhite")             -- (FFDEAD)
DBDT:AddColor(255,228,196,255,"Bisque")                  -- (FFE4C4)
DBDT:AddColor(255,235,205,255,"BlanchedAlmond")          -- (FFEBCD)
DBDT:AddColor(255,248,220,255,"Cornsilk")                -- (FFF8DC)
-- Purple, violet, and magenta colors
DBDT:AddColor(75,0,130,255,"Indigo")                     -- (4B0082)
DBDT:AddColor(128,0,128,255,"Purple")                    -- (800080)
DBDT:AddColor(139,0,139,255,"DarkMagenta")               -- (8B008B)
DBDT:AddColor(148,0,211,255,"DarkViolet")                -- (9400D3)
DBDT:AddColor(72,61,139,255,"DarkSlateBlue")             -- (483D8B)
DBDT:AddColor(138,43,226,255,"BlueViolet")               -- (8A2BE2)
DBDT:AddColor(153,50,204,255,"DarkOrchid")               -- (9932CC)
DBDT:AddColor(255,0,255,255,"Fuchsia")                   -- (FF00FF)
DBDT:AddColor(255,0,255,255,"Magenta")                   -- (FF00FF)
DBDT:AddColor(106,90,205,255,"SlateBlue")                -- (6A5ACD)
DBDT:AddColor(123,104,238,255,"MediumSlateBlue")         -- (7B68EE)
DBDT:AddColor(186,85,211,255,"MediumOrchid")             -- (BA55D3)
DBDT:AddColor(147,112,219,255,"MediumPurple")            -- (9370DB)
DBDT:AddColor(218,112,214,255,"Orchid")                  -- (DA70D6)
DBDT:AddColor(238,130,238,255,"Violet")                  -- (EE82EE)
DBDT:AddColor(221,160,221,255,"Plum")                    -- (DDA0DD)
DBDT:AddColor(216,191,216,255,"Thistle")                 -- (D8BFD8)
DBDT:AddColor(230,230,250,255,"Lavender")                -- (E6E6FA)
-- Blue colors
DBDT:AddColor(25,25,112,255,"MidnightBlue")              -- (191970)
DBDT:AddColor(0,0,128,255,"Navy")                        -- (000080)
DBDT:AddColor(0,0,139,255,"DarkBlue")                    -- (00008B)
DBDT:AddColor(0,0,205,255,"MediumBlue")                  -- (0000CD)
DBDT:AddColor(65,105,225,255,"RoyalBlue")                -- (4169E1)
DBDT:AddColor(70,130,180,255,"SteelBlue")                -- (4682B4)
DBDT:AddColor(30,144,255,255,"DodgerBlue")               -- (1E90FF)
DBDT:AddColor(0,191,255,255,"DeepSkyBlue")               -- (00BFFF)
DBDT:AddColor(100,149,237,255,"CornflowerBlue")          -- (6495ED)
DBDT:AddColor(135,206,235,255,"SkyBlue")                 -- (87CEEB)
DBDT:AddColor(135,206,250,255,"LightSkyBlue")            -- (87CEFA)
DBDT:AddColor(176,196,222,255,"LightSteelBlue")          -- (B0C4DE)
DBDT:AddColor(173,216,230,255,"LightBlue")               -- (ADD8E6)
DBDT:AddColor(176,224,230,255,"PowderBlue")              -- (B0E0E6)
-- Cyan colors
DBDT:AddColor(0,128,128,255,"Teal")                      -- (008080)
DBDT:AddColor(0,139,139,255,"DarkCyan")                  -- (008B8B)
DBDT:AddColor(32,178,170,255,"LightSeaGreen")            -- (20B2AA)
DBDT:AddColor(95,158,160,255,"CadetBlue")                -- (5F9EA0)
DBDT:AddColor(0,206,209,255,"DarkTurquoise")             -- (00CED1)
DBDT:AddColor(248,209,204,255,"MediumTurquoise")         -- (F8D1CC)
DBDT:AddColor(64,224,208,255,"Turquoise")                -- (40E0D0)
DBDT:AddColor(0,255,255,255,"Aqua")                      -- (00FFFF)
DBDT:AddColor(0,255,255,255,"Cyan")                      -- (00FFFF)
DBDT:AddColor(127,255,212,255,"Aquamarine")              -- (7FFFD4)
DBDT:AddColor(175,238,238,255,"PaleTurquoise")           -- (AFEEEE)
DBDT:AddColor(224,255,255,255,"LightCyan")               -- (E0FFFF)
-- Green colors
DBDT:AddColor(0,100,0,255,"DarkGreen")                   -- (006400)
DBDT:AddColor(85,107,47,255,"DarkOliveGreen")            -- (556B2F)
DBDT:AddColor(34,139,34,255,"ForestGreen")               -- (228B22)
DBDT:AddColor(46,139,87,255,"SeaGreen")                  -- (2E8B57)
DBDT:AddColor(128,128,0,255,"Olive")                     -- (808000)
DBDT:AddColor(107,142,35,255,"OliveDrab")                -- (6B8E23)
DBDT:AddColor(60,179,113,255,"MediumSeaGreen")           -- (3CB371)
DBDT:AddColor(50,205,50,255,"LimeGreen")                 -- (32CD32)
DBDT:AddColor(0,255,0,255,"Lime")                        -- (00FF00)
DBDT:AddColor(0,255,127,255,"SpringGreen")               -- (00FF7F)
DBDT:AddColor(0,250,154,255,"MediumSpringGreen")         -- (00FA9A)
DBDT:AddColor(143,188,143,255,"DarkSeaGreen")            -- (8FBC8F)
DBDT:AddColor(102,205,170,255,"MediumAquamarine")        -- (66CDAA)
DBDT:AddColor(154,205,50,255,"YellowGreen")              -- (9ACD32)
DBDT:AddColor(124,252,0,255,"LawnGreen")                 -- (7CFC00)
DBDT:AddColor(127,255,0,255,"Chartreuse")                -- (7FFF00)
DBDT:AddColor(144,238,144,255,"LightGreen")              -- (90EE90)
DBDT:AddColor(173,255,47,255,"GreenYellow")              -- (ADFF2F)
DBDT:AddColor(152,251,152,255,"PaleGreen")               -- (98FB98)
-- White colors
DBDT:AddColor(255,228,225,255,"MistyRose")               -- (FFE4E1)
DBDT:AddColor(250,235,215,255,"AntiqueWhite")            -- (FAEBD7)
DBDT:AddColor(250,240,230,255,"Linen")                   -- (FAF0E6)
DBDT:AddColor(245,245,220,255,"Beige")                   -- (F5F5DC)
DBDT:AddColor(245,245,245,255,"WhiteSmoke")              -- (F5F5F5)
DBDT:AddColor(255,240,245,255,"LavenderBlush")           -- (FFF0F5)
DBDT:AddColor(253,245,230,255,"OldLace")                 -- (FDF5E6)
DBDT:AddColor(240,248,255,255,"AliceBlue")               -- (F0F8FF)
DBDT:AddColor(255,245,238,255,"Seashell")                -- (FFF5EE)
DBDT:AddColor(248,248,255,255,"GhostWhite")              -- (F8F8FF)
DBDT:AddColor(240,255,240,255,"Honeydew")                -- (F0FFF0)
DBDT:AddColor(255,250,240,255,"FloralWhite")             -- (FFFAF0)
DBDT:AddColor(240,255,255,255,"Azure")                   -- (F0FFFF)
DBDT:AddColor(245,255,250,255,"MintCream")               -- (F5FFFA)
DBDT:AddColor(255,250,250,255,"Snow")                    -- (FFFAFA)
DBDT:AddColor(255,255,240,255,"Ivory")                   -- (FFFFF0)
-- Gray and black colors
DBDT:AddColor(47,79,79,255,"DarkSlateGray")              -- (2F4F4F)
DBDT:AddColor(105,105,105,255,"DimGray")                 -- (696969)
DBDT:AddColor(112,128,144,255,"SlateGray")               -- (708090)
DBDT:AddColor(128,128,128,255,"Gray")                    -- (808080)
DBDT:AddColor(119,136,153,255,"LightSlateGray")          -- (778899)
DBDT:AddColor(169,169,169,255,"DarkGray")                -- (A9A9A9)
DBDT:AddColor(192,192,192,255,"Silver")                  -- (C0C0C0)
DBDT:AddColor(211,211,211,255,"LightGray")               -- (D3D3D3)
DBDT:AddColor(220,220,220,255,"Gainsboro")               -- (DCDCDC)


-- Non-Offical Colors
-- My strange names
DBDT:AddColor(255,50,0,255,"ROrange")                    -- (FF3200) | Kind of in-between red and orange
DBDT:AddColor(255,150,0,255,"YOrange")                   -- (FF9600) | Kind of in-between orange and yellow
DBDT:AddColor(215,255,0,255,"Yeen")                      -- (D7FF00) | Kind of in-between yellow and (true) green
DBDT:AddColor(0,255,125,255,"Glue")                      -- (00FF7D) | Kind of in-between (true)green and blue
DBDT:AddColor(240,30,100,255,"Ponk")                     -- (F01E64) | Personal favourite pink
DBDT:AddColor(120,15,50,255,"DarkPonk")                  -- (780F32) | Darker version of ponk
DBDT:AddColor(120,30,100,255,"Porp")                     -- (781E64) | Personal preference for purple
-- Slightly modified colors
DBDT:AddColor(255,50,0,255,"OrangeRed2")                 -- (FF6400) | Slightly brighter than "OrangeRed"
DBDT:AddColor(255,240,0,255,"Yellow2")                   -- (FFF000) | Slightly redder yellow
DBDT:AddColor(0,185,0,255,"Green2")                      -- (00B900) | Slightly modifed green
DBDT:AddColor(0,255,200,255,"Cyan2")                     -- (00FFC8) | Personal preference for cyan

_G["DBCol"] = {}
function DBCol:CH(red,green,blue,alpha)
    return DBDT:ColorHelper(red,green,blue,alpha)
end
function DBCol:CS(ColorTable,InputString)
    return DBDT:ColorString(ColorTable,InputString)
end
function DBCol:GN(ColorTable)
    return DBDT:GetNormalisedColor(ColorTable)
end
function DBCol:GC(name)
    return DBDT:GetColor(name)
end

-- EOF