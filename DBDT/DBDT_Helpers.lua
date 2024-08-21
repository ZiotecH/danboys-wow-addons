-- Stolen from DevTool, thanks guys. :)
local _, addonTable = ... -- make use of the default addon namespace

---@class DBDT : AceAddon-3.0 @define DBDT_Main
addonTable.DBDT = LibStub("AceAddon-3.0"):NewAddon("DBDT")
local DBDT = addonTable.DBDT

-- add global reference to the addon object
_G["DBDT"] = addonTable.DBDT
local me = DBDT["name"]
local DBDebugTable = {}
DBDT["DBDebugTable"] = DBDebugTable
DBDT["DBDebugTable"]["Saved Colors"] = 0
DBDT["DBDebugTable"]["Character Info"] = {}
local fontList = {}
local SharedMedia = false
DBDT["PrintDebug"] = false                           --? <- PRINTDEBUG IS HERE :)
DBDT["ColorTable"] = {}
DBDT["StringTables"] = {}
DBDT["sindent"] = "▸"
DBDT["ListOfHearthstones"] = {}
local ColorTable = DBDT["ColorTable"]
local si = DBDT["sindent"]
local t = true
local f = false
local buildInfo = {}
DBDT["BuildInfo"] = buildInfo
DBDebugTable["Console_Enabled"] = false

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
    ["Clique"] = false,
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
    DBDT["PrintDebug"] = DBDT:Not(DBDT["PrintDebug"])
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
    local s1 = "Received "..type(InputData)..":"
    DBDT:DBPrint(InputData,t,t,DBDT:GenDebugString(me,"Console",s1))
end


function DBDT:InitVars(n1,payload)
    n1 = DBDT:Numcheck(n1)
    local t1 = {}

    if n1 == 0 then return nil
    elseif n1 == 1 then return payload
    else
      for n2 = 1,n1 do 
        table.insert(t1,payload)
      end
      return unpack(t1)
    end

    return false
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
    -- Todo: Fill list :)
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
-- Todo: Find out if it's possible
-- Todo: And move these further down
function DBDT:CastHearth()
    -- TODO:
    -- ! Add support for checking if player has normal hearthstone

    -- TODO:
    -- * Iterate through known hearthstone toys and add to list if player has them
    -- * Pick one at random and use it
    return false
end

function DBDT:GetHearths()
    return false
end

function DBDT:Not(payload)
    -- Bool => !Bool
    if type(payload) == "boolean" then return (true and not payload)
    -- Nil => true
    elseif payload == nil then return true
    -- Table,String,Number => false
    else return false
    end
end

function DBDT:Flip(payload)
    local type = type(payload)
    local count = 0
    if type == "boolean"    then return (true and not payload)  end
    if type == "number"     then return (payload * -1)          end
    if type == "string"     then return string.reverse(payload) end
    if type == "table"      then return payload                 end --??
    return true
end

function DBDT:Nilcheck(payload,returnValue,returnType)
    -- Set returntype default to boolean
    if returnType == nil then returnType = "boolean" end
    local ValueRequested = (true and (returnValue ~= nil))
    local PayloadIsNil = (payload == nil)

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
        ["nil"] = nil, -- For special cases
    }
    if returnType ~= "nil" and typeTable[returnType] == nil then
        returnType = "boolean"
    end

    -- See if value requested
    if PayloadIsNil then
        if ValueRequested then
            payload = returnValue
        else
            payload = typeTable[returnType]
        end
    end

    -- return the payload
    return payload
end

function DBDT:Typecheck(payload,wantedtype)
    return (type(payload) == wantedtype)
end

function DBDT:SetType(payload,wantedType)
    if DBDT:EQ(DBDT:Typecheck(payload,wantedType),false) then
        return DBDT:Nilcheck(payload,nil,wantedType)
    else
        return payload
    end
end

function DBDT:Boolcheck(payload,passthrough)
    passthrough = DBDT:Nilcheck(passthrough,true)
    -- If payload is nil we always return false
    if (payload == nil) then return false
    elseif (type(payload) == "boolean") then
        if passthrough then
            -- Return the passed boolean
            return payload
        else
            -- Return confirmation that passed value *is* boolean
            return true
        end
    -- If payload is a string or table, return true
    else return true
    end
end

function DBDT:Numcheck(payload,fallback)
    if DBDT:Not(DBDT:Typecheck(fallback,"number")) then
        fallback = 0
    end
    -- Check if type isn't number and return 0, else return payload clamped to non-infinite.
    if DBDT:EQ(DBDT:Typecheck(payload,"number"),false) then
        if DBDT:EQ(DBDT:Typecheck(payload,"string"),true) then
            fallback = DBDT:Numcheck(tonumber(payload),fallback)
        end
        return fallback
    else
        return DBDT:Clamp(payload,(DB_Integers["min"]),(DB_Integers["max"]))
    end
end

function DBDT:Stringcheck(payload,fallback)
    payload = DBDT:Nilcheck(payload)
    fallback = DBDT:Nilcheck(fallback)
    if DBDT:Boolcheck(payload,false) then
        if DBDT:Typecheck(payload,"string") then
            return payload
        else
            return fallback
        end
    end
    return fallback
end

function DBDT:Tablecheck(Table,Parent,Create)
    -- Sanity check
    Table = DBDT:Nilcheck(Table)
    Parent = DBDT:Nilcheck(Parent)
    Create = DBDT:Boolcheck(Create)
    -- Check if Parent[Table] and if the user requests it create it should it not.
    if DBDT:Typecheck(Table,"string") then
        if DBDT:Typecheck(Parent,"table") then
            if ((DBDT:Boolcheck(Parent[Table]) == false) and Create) then
                Parent[Table] = {}
                return true
            end
        end
        return DBDT:Boolcheck(Table)
    end

    -- Should never happen
    return false
end

function DBDT:TestValue(payload,reverse,ReportFailure,Category)
    ReportFailure = DBDT:Boolcheck(ReportFailure)
    Category = DBDT:Stringcheck(Category,"UNKNOWN")
    reverse = DBDT:Boolcheck(reverse)
    local ValidPayload = DBDT:Nilcheck(payload,"INVALID_PAYLOAD_INPUT")
    local ReturnBoolean = DBDT:Boolcheck(payload)

    -- Does the user wish to check for the lack of existance? 
    if reverse then
        ReturnBoolean = DBDT:EQ(ReturnBoolean,false)
    end

    -- Print result to DevTool/Chat
    if DBDT["PrintDebug"] then
        DBDT:DBPrint(ReturnBoolean,false,false,DBDT:GenDebugString(me,"Test","Testing if "..tostring(payload).." exists."),false)
    end

    if (DBDT:EQ(ValidPayload,"INVALID_PAYLOAD_INPUT") and ReportFailure) then
        DBDT:Tablecheck("Reports",DBDebugTable,true)
        DBDT:Tablecheck("Tests",DBDebugTable["Reports"],true)
        DBDT:Tablecheck(Category,DBDebugTable["Reports"]["Tests"],true)
        DBDT:Report("TestValue",ReturnBoolean,Category)
    end

    -- Return True/False
    return ReturnBoolean
end

function DBDT:Report(Sender,Payload,Category)
    DBDT:Tablecheck("Reports",DBDebugTable,true)
    Category = DBDT:Stringcheck(Category,"Misc")
    
    local ChangedSender = false
    local ChangedPayload= false
    local NewSender  = DBDT:Stringcheck(Sender,"Invalid")
    local NewPayload = DBDT:Nilcheck(Payload,"Invalid")
    if DBDT:NE(Sender,NewSender) then ChangedSender = true end
    if DBDT:NE(Payload,NewPayload) then ChangedPayload = true end
    local ValidReport = ((DBDT:NE(Sender,"Invalid") and ChangedSender) and (DBDT:NE(Payload,"Invalid") and ChangedPayload))

    local Target = nil

    if ValidReport then
        DBDT:Tablecheck(Category, DBDebugTable["Reports"],true)
        Target = DBDebugTable["Reports"][Category]
        table.insert(Target,{["Sender"] = Sender,["Timestamp"]=DBDT:Timestamp(),["Report"]=Payload})
    else
        DBDT:Warn("Report","Invalid report!")
    end
end

function DBDT:Warn(Sender,Message)
    Message = "|cFFFA8072"..Message.."|r"
    Sender = DBDT:Nilcheck(Sender,"Unknown Source")
    if (DBDT:EQ(Sender,"Unknown Source") and false) then end
    DBDT:DBPrint(" ",false,false,Message,false)
end

function DBDT:Clamp(value,vmin,vmax)
    -- Nilcheck
    value = DBDT:Nilcheck(value,0)
    vmin  = DBDT:Nilcheck(vmin,DB_Integers["min"])
    vmax  = DBDT:Nilcheck(vmax,DB_Integers["max"])
    if DBDT["PrintDebug"] and false then --! Disabled for now
        DBDT:DBPrint(
            {
                ["value"]= {
                    ["Value"] = value,
                    ["Type"] = type(value)
                },
                ["vmin"] = {
                    ["Value"] = vmin,
                    ["Type"] = type(vmin)
                },
                ["vmax"] = {
                    ["Value"] = vmax,
                    ["Type"] = type(vmax)
                },
            },
            false,
            false,
            DBDT:GenDebugString(me,"Clamp"),
            false
        )
    end
    -- Todo: Learn how to not miss critical stuff :)
    if (DBDT:NE(type(value),"number") or DBDT:NE(type(vmin),"number") or DBDT:NE(type(vmax),"number")) then
        return 0
    end
    
    -- Sanity
    if DBDT:EQ(vmin,vmax) then
        vmin = DB_Integers["min"]
        vmax = DB_Integers["max"]
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

function DBDT:SetPrecision(value,precision,AsString)
    AsString = DBDT:Boolcheck(AsString)
    value = DBDT:Numcheck(value)
    precision = DBDT:Numcheck(precision,4)
    local ReturnString = (string.format("%."..tostring(precision).."f", value))
    if AsString then return ReturnString else return tonumber(ReturnString) end
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

function DBDT:Timestamp(StringColor)
    local s1 = "FFA9A9A9" -- Fallback to DarkGray
    StringColor = DBDT:Stringcheck(StringColor, "DarkGray")
    if DBDT:Boolcheck(DBDT:GetColor(StringColor),false) then s1 = DBDT:GetColor(StringColor):Get() end
    return "|c"..s1.."["..date("%X").."]|r"
end

function DBDT:TableHasValue(t1,v1)
    local b1 = false
    if DBDT:Boolcheck(v1,false) and DBDT:Typecheck(t1,"table") then
        for k1,v2 in pairs(t1) do
            b1 = (b1 or (v1 == v2))
        end
    end
    return b1
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

function DBDT:ItemInfo(itemID,doReturn)
    doReturn = DBDT:Boolcheck(doReturn)
    if DBDT:Typecheck(itemID,"number") then
        if C_Item.DoesItemExistByID(itemID) then
            local tmp={}
            tmp["itemName"],tmp["itemLink"],tmp["itemQuality"],tmp["itemLevel"],tmp["itemMinLevel"],tmp["itemType"],tmp["itemSubType"],tmp["itemStackCount"],tmp["itemEquipLoc"],tmp["itemTexture"],tmp["sellPrice"],tmp["classID"],tmp["subclassID"],tmp["bindType"],tmp["expansionID"],tmp["setID"],tmp["isCraftingReagent"] = C_Item.GetItemInfo(DBDT:Clamp(itemID,1,DB_Integers["max"]))
            -- Set Numbers
            local n1,n2,n3,n4,n5,n6,n7 = DBDT:Numcheck(tmp["bindType"]),DBDT:Numcheck(tmp["classID"]),DBDT:Numcheck(tmp["subclassID"]),DBDT:Numcheck(tmp["itemLevel"]),DBDT:Numcheck(tmp["itemQuality"]),DBDT:Numcheck(tmp["expansionID"]),DBDT:Numcheck(tmp["sellPrice"])
            -- Init Strings
            local s1,s2,s3,s4,s5,s6,s7 = DBDT:InitVars(7,false)
            -- Set Strings
            if n1 then s1 = DBDT:Bin(n1) end
            if n7 then s4 = GetMoneyString(n1) end
            if n6 then s5 = DBDT:Exp(n6) end
            if n5 then s6 = DBDT:Qua(n5) end
            if DBDT:Nilcheck(tmp["itemName"]) then s7 = tmp["itemName"] end
            if DBDT:Nilcheck(tmp["itemType"]) then s2 = tmp["itemType"] end
            if DBDT:Nilcheck(tmp["itemSubType"]) then s3 = tmp["itemSubType"] end
            -- Set Booleans
            local b1,b2 = DBDT:Nilcheck(tmp["isCraftingReagent"]), (true and DBDT:Nilcheck(tmp["setID"]))

            local TempTable = {
                ["ItemID"] = itemID,
                ["RawData"] = tmp,
                ["Name"] = s7,
                ["Strings"] = {
                    ["Bound"] = s1,
                    ["itemType"] = s2,
                    ["itemSubType"] = s3,
                    ["Price"] = s4,
                    ["Expansion"] = s5,
                    ["Quality"] = s6,
                },
                ["Numbers"] = {
                    ["bindID"] = n1,
                    ["classID"] = n2,
                    ["subclassID"] = n3,
                    ["itemLevel"] = n4,
                    ["itemQuality"] = n5,
                    ["expansionID"] = n6,
                    ["value"] = n7,
                },
                ["Booleans"] = {
                    ["Crafting Reagent"] = b1,
                    ["Is Set Item"] = b2,
                },
            }
            if DBDT:Nilcheck(s7) then
                if doReturn then
                    return TempTable
                else
                    DBDT:DBPrint(
                        TempTable,
                        true,
                        true,
                        DBDT:GenDebugString("DBDT","ItemInfo",tostring(s7).."["..tostring(itemID).."]"),
                        false
                    )
                end
            else
                if doReturn then return false else DBDT:DBPrint(false,t,t,DBDT:GenDebugString(me,"ItemInfo","Item returns nil"),f) end
            end
        end
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

function DBDT:BuffInfo(unitToken,index)
    -- Set unitToken to passed value or "player" 
    unitToken = DBDT:Nilcheck(unitToken,"player")
    index = DBDT:Numcheck(index)
    local AuraTable = {
        ["Buffs"] = {},
        ["Debuffs"] = {}
    }

    if index == 0 then
        for i=0,1000 do
            local Buff_Data     = DBDT:Nilcheck(  C_TooltipInfo.GetUnitBuff(unitToken,i)    )
            local Debuff_Data   = DBDT:Nilcheck(  C_TooltipInfo.GetUnitDebuff(unitToken,i)  )
            if Buff_Data then AuraTable["Buffs"][Buff_Data["id"]] = Buff_Data           end
            if Debuff_Data then AuraTable["Debuffs"][Debuff_Data["id"]] = Debuff_Data     end
        end
    else
        local Buff_Data     = DBDT:Nilcheck(C_Tooltip.GetUnitBuff(unitToken,index)   )
        local Debuff_Data   = DBDT:Nilcheck(C_Tooltip.GetUnitDebuff(unitToken,index) )
        if Buff_Data    then AuraTable["Buffs"][Buff_Data["id"]]     = Buff_Data    end
        if Debuff_Data  then AuraTable["Debuffs"][Debuff_Data["id"]] = Debuff_Data  end
    end

    if AuraTable["Buffs"]   == {} then AuraTable["Buffs"]   = false end
    if AuraTable["Debuffs"] == {} then AuraTable["Debuffs"] = false end

    return AuraTable
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
    if DBDT:Boolcheck(object,false) then
        local generatedString = DBDT:Timestamp().." "..tostring(object)
        if DBDT:Boolcheck(id,false) then generatedString = generatedString.." ["..tostring(id).."]" end
        if DBDT:Boolcheck(message) then generatedString = generatedString.." - "..tostring(message) end
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
  value = DBDT:Numcheck(value)
  if DBDT:EQ(value,0) then
    return "00"
  else
    return string.format("%2X",value)
  end
end

function DBDT:ColorHelper(red, green, blue, alpha, FriendlyName, Category)
    -- Clamp and Nilcheck
    red = DBDT:Clamp(DBDT:Numcheck(red), 0, 255)
    green = DBDT:Clamp(DBDT:Numcheck(green), 0, 255)
    blue = DBDT:Clamp(DBDT:Numcheck(blue), 0, 255)
    alpha = DBDT:Clamp(DBDT:Numcheck(alpha), 0, 255)

    
    -- Hexadecimal colors
    local hr = DBDT:HF(red)
    local hg = DBDT:HF(green)
    local hb = DBDT:HF(blue)
    local ha = DBDT:HF(alpha)
    
    local ReturnTable = {}
    ReturnTable["Name"] = DBDT:Stringcheck(FriendlyName,nil)
    ReturnTable["Category"] = DBDT:Stringcheck(Category,false)
    -- Hexadecimal Table
    ReturnTable["hex"] = {
        ["argb"] = ha .. hr .. hg .. hb,
        ["rgba"] = hr .. hg .. hb .. ha
    }

    -- RGBA Table
    ReturnTable["rgba"] = {
        ["red"] = red,
        ["green"] = green,
        ["blue"] = blue,
        ["alpha"] = alpha
    }

    -- TextColor String
    ReturnTable["string"] = {
        ["start"] = "|c" .. ReturnTable["hex"]["argb"],
        ["end"] = "|r"
    }

    -- Normalised RGBA
    ReturnTable["normalised"] = {
        ["red"] = DBDT:Clamp((red / 255), 0, 1),
        ["green"] = DBDT:Clamp((green / 255), 0, 1),
        ["blue"] = DBDT:Clamp((blue / 255), 0, 1),
        ["alpha"] = DBDT:Clamp((alpha / 255), 0, 1)
    }

    function ReturnTable:GetHex()
        return ReturnTable["hex"]["argb"]
    end

    function ReturnTable:GetNorm()
        return ReturnTable["normalised"]["red"],
               ReturnTable["normalised"]["green"],
               ReturnTable["normalised"]["blue"],
               ReturnTable["normalised"]["alpha"]
    end

    function ReturnTable:GetString()
        return ReturnTable["string"]["start"], ReturnTable["string"]["end"]
    end

    function ReturnTable:GetRGB()
        return ReturnTable["rgba"]["red"], ReturnTable["rgba"]["green"], ReturnTable["rgba"]["blue"], ReturnTable["rgba"]["alpha"]
    end

    function ReturnTable:Get()
        return ReturnTable:GetHex()
    end

    function ReturnTable:Format(InputText)
        if DBDT:Nilcheck(InputText) then
            return ReturnTable["string"]["start"] ..tostring(InputText)..ReturnTable["string"]["end"]
        end
    end

    ReturnTable["Example"] = ReturnTable:Format("Example String")

    return ReturnTable
end

function DBDT:ColorString(ColorTable,InputString)
    return ColorTable["string"]["start"]..InputString..ColorTable["string"]["end"]
end

function DBDT:AddColor(red,green,blue,alpha,name,category)
  DBDT["ColorTable"][name] = DBDT:ColorHelper(red,green,blue,alpha,name,category)
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
                true,
                _,
                _,
                DBDT:Timestamp().." "..tmpCol["string"]["start"] .. "Testing the color \"" .. name .. "\"." .. tmpCol["string"]["end"]
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
    n1 = DBDT:Numcheck(n1)
    ts = DBDT:Boolcheck(ts)
    local ret = DBDT:PadSpace(n1)..DBDT["sindent"]
    if ts then
        ret = ret.." "
    end
    return ret
end

function DBDT:Exp(ExpansionID)
    return DBDT["StringTables"]["ExpansionID"][ExpansionID]
end

function DBDT:Qua(QualityID)
    return DBDT["StringTables"]["QualityID"][QualityID]
end

function DBDT:Bin(BindID)
    return DBDT["StringTables"]["BindID"][BindID]
end

function DBDT:ItemCheck(ItemInfo)
    return DBDT["BlankItem"]
end

function DBDT:GetSpec(class,spec,DoPrint)
    DoPrint = DBDT:Boolcheck(DoPrint)
    class = DBDT:Stringcheck(class,false)
    spec = DBDT:Stringcheck(spec,false)
    local ReturnData = false
    if DBDT:Boolcheck(class) then
        if DBDT:Boolcheck(spec) then
            ReturnData = DBDT:Nilcheck(DBDT["StringTables"]["ExportStrings"]["Specs"][class][spec])
        else
            ReturnData = DBDT:Nilcheck(DBDT["StringTables"]["ExportStrings"]["Specs"][class])
        end
    else
        ReturnData = DBDT["StringTables"]["ExportStrings"]["Specs"]
    end
    if DoPrint then
        DEFAULT_CHAT_FRAME:AddMessage(ReturnData)
    else
        return ReturnData
    end
end

function DBDT:SetSpec(class,spec)
    -- Remove before use
    if true then return false end
    --
    if DBDT:Nilcheck(class) then
        if DBDT:Nilcheck(spec) then
            C_ClassTalents.RequestNewConfig("Danboy's "..tostring(spec).." "..tostring(class))
            local ConfigID = C_ClassTalents.GetActiveConfigID()
            -- TODO: Figure this out lol
        end
    end
end

function DBDT:PrintFullBuild(print)
    print = DBDT:Boolcheck(print,true)
    local a,b,c,d,e,f = GetBuildInfo()
    local PT = {
        ["GetBuildInfo"] = {
            ["Build Version"] = a,
            ["Build Number"] = b,
            ["Build Date"] = c,
            ["Interface Version"] = d,
            ["Localized Version"] = e,
            ["Build Info"] = f,
        },
        ["Is64BitClient"] = Is64BitClient(),
        ["IsBetaBuild"] = IsBetaBuild(),
        ["IsDebugBuild"] = IsDebugBuild(),
        ["IsLinuxClient"] = IsLinuxClient(),
        ["IsMacClient"] = IsMacClient(),
        ["IsPublicBuild"] = IsPublicBuild(),
        ["IsTestBuild"] = IsTestBuild(),
        ["IsWindowsClient"] = IsWindowsClient(),
        ["SupportsClipCursor"] = SupportsClipCursor(),
    }

    DBDT["BuildInfo"] = PT
    if DBDT:Boolcheck(print) then
        DBDT:DBPrint(PT,f,f,gds(me,"PrintFullBuild"),f)
    end
end

function DBDT:SetDungeonDifficulty(difficultyID)
    local isNumber,isString = DBDT:Typecheck(difficultyID,"number"),DBDT:Typecheck(difficultyID,"string")
    local CurrentDifficultyID = GetDungeonDifficultyID()
    local changed = false
    local diffIndex = false
    if isNumber then 
        if DBDT:Clamp(difficultyID,1,3) ~= CurrentDifficultyID then
            SetDungeonDifficultyID(difficultyID)
            changed = true
        end
    elseif isString then
        local diffIndex = DBDT["StringTables"]["DifficultyID"][difficultyID]
        if DBDT:Clamp(diffIndex,1,3) ~= CurrentDifficultyID then
            SetDungeonDifficultyID(diffIndex)
            changed = true
        end
    end

    if DBDT["PrintDebug"] then
        DBDT:DBPrint(
            {
                ["Old Difficulty"] = CurrentDifficultyID,
                ["New Difficulty"] = (diffIndex or difficultyID),
                ["Changed"] = changed,
            },
            f,
            f,
            gds(me,"SetDungeonDifficulty"),
            f
        )
    end
end

function DBDT:SetRaidDifficulty(difficultyID)
    local isNumber,isString = DBDT:Typecheck(difficultyID,"number"),DBDT:Typecheck(difficultyID,"string")
    local CurrentLegacyDifficultyID = GetLegacyRaidDifficultyID()
    local CurrentRaidDifficultyID = GetRaidDifficultyID()
    local changed = false
    local diffIndex = false
    if isNumber then 
        if DBDT:Clamp(difficultyID,1,3) ~= (CurrentLegacyDifficultyID or CurrentRaidDifficultyID) then
            SetLegacyRaidDifficultyID(difficultyID)
            SetRaidDifficultyID(difficultyID)
            changed = true
        end
    elseif isString then
        local diffIndex = DBDT["StringTables"]["DifficultyID"][difficultyID]
        if DBDT:Clamp(diffIndex,1,3) ~= (CurrentLegacyDifficultyID or CurrentRaidDifficultyID) then
            SetLegacyRaidDifficultyID(diffIndex)
            SetRaidDifficultyID(diffIndex)
            changed = true
        end
    end

    if DBDT["PrintDebug"] then
        DBDT:DBPrint(
            {
                ["Old Difficulty"] = {
                    ["Legacy"] = CurrentLegacyDifficultyID,
                    ["Raid"] = CurrentRaidDifficultyID,
                },
                ["New Difficulty"] = (diffIndex or difficultyID),
                ["Changed"] = changed,
            },
            f,
            f,
            gds(me,"SetRaidDifficulty"),
            f
        )
    end
end

function DBDT:GetNumFactions()
    return (C_Reputation.GetNumFactions() + 1)
end

function DBDT:ExpandAllFactionHeaders()
    C_Reputation.ExpandAllFactionHeaders()
    local n1 = 0
    for i=0,3 do
        n1 = DBDT:GetNumFactions()
        for x=0,n1 do
            C_Reputation.ExpandFactionHeader(x)
        end
    end
end

function DBDT:CloneTable(SourceTable)
    local ReturnTable = {}
    if (DBDT:Typecheck(SourceTable,"table") and SourceTable ~= {}) then
        for k,v in pairs(SourceTable) do
            ReturnTable[k] = v
        end
    else
        ReturnTable = false
    end
    return ReturnTable
end

function DBDT:GenerateFactionIndex(FactionTable)
end

function DBDT:GetAllKnownFactions()
    local oldSort = C_Reputation.GetReputationSortType()
    C_Reputation.SetReputationSortType(2)
    DBDT:ExpandAllFactionHeaders()
    local RootTable = {
        ["Other"] = {},
        ["Guild"] = {},
        ["Classic"] = {},
        ["The Burning Crusade"] = {},
        ["Wrath of the Lich King"] = {},
        ["Cataclysm"] = {},
        ["Mists of Pandaria"] = {},
        ["Warlords of Draenor"] = {},
        ["Legion"] = {},
        ["Battle for Azeroth"] = {},
        ["Shadowlands"] = {},
        ["Dragonflight"] = {},
        ["The War Within"] = {},
        ["Inactive"] = {},
    }
    local CurrentTable = {}
    local NumFactions = DBDT:GetNumFactions()
    local CurrentName = false
    local CurrentIsHeader = false
    local CurrentFactionID = false
    local PrevMainHeader = false
    local PrevSubHeader = false
    local ColorData = {
        ["FactionHeader"] = DBDT:GetColor("FactionHeader")["string"],
        ["FactionSubHeader"] = DBDT:GetColor("FactionSubHeader")["string"],
        ["FactionTitle"] = DBDT:GetColor("FactionTitle")["string"],
        ["FactionSubTitle"] = DBDT:GetColor("FactionSubTitle")["string"],
        ["EmptyHeader"] = DBDT:GetColor("EmptyHeader")["string"],
    }
    

    -- Headers
    for i=1,NumFactions do
        CurrentTable = C_Reputation.GetFactionDataByIndex(i)
        
        CurrentFactionID = CurrentTable["factionID"]
        CurrentName = CurrentTable["name"]
        CurrentIsHeader = CurrentTable["isHeader"]
        local NameString = DBDT["sindent"].." "..CurrentName.." ("..tostring(CurrentFactionID)..")"

        if CurrentIsHeader and DBDT:Nilcheck(RootTable[CurrentName]) then
            RootTable[CurrentName] = nil
            CurrentName = ColorData["FactionHeader"]["start"]..CurrentName..ColorData["FactionHeader"]["end"]
            RootTable[CurrentName] = {}
            PrevMainHeader = CurrentName
            PrevSubHeader = false
        elseif CurrentIsHeader then
            CurrentName = ColorData["FactionSubHeader"]["start"]..DBDT["sindent"].." "..CurrentName..ColorData["FactionSubHeader"]["end"]
            PrevSubHeader = CurrentName
            RootTable[PrevMainHeader][CurrentName] = {}
        elseif PrevSubHeader then
            NameString = ColorData["FactionSubTitle"]["start"]..NameString..ColorData["FactionSubTitle"]["end"]
            RootTable[PrevMainHeader][PrevSubHeader][NameString] = CurrentTable
        else
            NameString = ColorData["FactionTitle"]["start"]..NameString..ColorData["FactionTitle"]["end"]
            RootTable[PrevMainHeader][NameString] = CurrentTable
        end
    end

    for _,v in pairs(DBDT["StringTables"]["ReputationHeaders"]) do
        if DBDT:Nilcheck(RootTable[v]) then
            RootTable[v] = nil
            RootTable[ColorData["EmptyHeader"]["start"]..v..ColorData["EmptyHeader"]["end"]] = false
        end
    end
        
    --C_Reputation.CollapseAllFactionHeaders()
    C_Reputation.SetReputationSortType(oldSort)
    DBDT:DBPrint(RootTable,f,f,gds(me,"GetAllKnownFactions"),f)
end

function DBDT:QuestComplete(QuestID,DoPrint)
    DoPrint = DBDT:Boolcheck(DoPrint)
    QuestID = DBDT:Numcheck(QuestID)
    local CTable = {
        [true] = "Green",
        [false] = "Red",
    }
    if NE(QuestID,0) then
        local QResult = C_QuestLog.IsQuestFlaggedCompleted(QuestID)
        local QName = DBDT:Nilcheck(C_QuestLog.GetTitleForQuestID(QuestID),"Unknown")
        if DBDT["PrintDebug"] then
            DBDT:DBPrint(
                {
                    ["QResult"] = QResult,
                    ["QuestID"] = QuestID,
                    ["DoPrint"] = DoPrint,
                },
                false,
                false,
                DBDT:GenDebugString(me,"QuestComplete",tostring(QuestID)),
                false
            )
        end
        if DoPrint then DEFAULT_CHAT_FRAME:AddMessage(QName.." completed: "..DBDT:GetColor(CTable[QResult]):Format(tostring(QResult))) end
    else
        DBDT:Report("DBDT",{["Invalid QuestID"]=QuestID},"QuestComplete")
    end
end

function DBDT:QC(QuestID)
    DBDT:QuestComplete(QuestID,true)
end

function DBDT:Dump(src)
    if DBDT:Typecheck(src,"string") == false then src = nil end
    DBDT:DBPrint(
        {
            ["Debug Table"] = DBDT["DBDebugTable"],
            ["Data"] = {
                ["StringTables"] = DBDT["StringTables"],
                ["FactionData"] = DBDT["FactionData"],
                ["CONSTANTS"] = DBDT["CONSTANTS"],
            },
            ["Booleans"] = {
                ["PrintDebug"] = DBDT["PrintDebug"],
                ["Dependencies"] = DBDT["DB_Dependencies"],
            },
            ["BuildInfo"] = DBDT["BuildInfo"],
            ["Integers"] = DBDT["DBIntegers"],
            ["Color Table ("..tostring(DBDebugTable["Saved Colors"])..")"] = {
                ["Full Table"] = DBDT["ColorTable"],
                ["Categorised"] = DBCol["ColorTable"],

            },

        }
        ,t,t,gds("DBDT","Dump",src),f
    )
end

-- Added helper for Reload(), becuase it refues to work?
function DBDT:CallReload(WaitTime)
    WaitTime = DBDT:Numcheck(WaitTime,0.5)
    C_Timer.After(WaitTime,ReloadUI)
end

-- Mainly for the future RepTracker.
function DBDT:GenFactionData(factionID,expansionID,factionName,zoneIDs,allegiance)
    factionID = DBDT:Clamp(DBDT:Numchecked(factionID),0,DB_Integers["max"])
    expansionID = DBDT:Clamp(DBDT:Numchecked(expansionID),0,11)
    factionName = DBDT:Nilcheck(factionName)
    zoneIDs = DBDT:Nilcheck(zoneIDs,"table")
    allegiance = DBDT:Stringcheck(allegiance)
    local isSaved = false
    local FDT
    local t1 = nil
    local fetchedData = nil
    
    -- Make sure the factionID is above 0, because y'kno..
    if factionID > 0 then
        fetchedData = C_Reputation.GetFactionDataByID(factionID)
        isSaved = DBDT:Boolcheck(FDT[factionID])
        if isSaved then
            DBDT:DBPrint(FDT[factionID],f,f,gds(me,"GenFactionData","Faction "..tostring(factionID).." already saved."))
            return false
        else
            if DBDT:Nilcheck(fetchedData) then
                t1 = FDT[factionID]
                t1["Expansion"] = {
                    ["Name"] = DBDT:Exp(expansionID),
                    ["ID"] = expansionID,
                }
                t1["Name"] = (factionName or fetchedData["name"])
                t1["ZoneIDs"] = (zoneIDs or {[1] = false})
                t1["Allegiance"] = (allegiance or "Neutral")
                return t1
            else
                return false
            end
        end
    end

end

-- Temporary, will change later
function DBDT:ZoneIDHelper(zoneID,checkChildren)
    --Failsafe
    zoneID = DBDT:Clamp(DBDT:Nilcheck(zoneID,"number"),1,DB_Integers["max"])
    checkChildren = DBDT:Boolcheck(checkChildren)

    return {
        [zoneID] = checkChildren
    }
end

-- Test
function DBDT:GrabCharInfo(unitToken)
    unitToken = DBDT:Stringchecked(unitToken,"player")
    
    local name,server = UnitFullName(unitToken)
    local CI = DBDT["DBDebugTable"]["Character Info"]
    DBDT:Tablecheck(server,CI,true)
    if DBDT:Tablecheck(name,CI[server]) then
        DBDT:DBPrint(f,f,f,gds(me,"GrabCharInfo","Table already exists."),f)
    else
        CI[server][name] = {}
        CI = CI[server][name]
        CI["Name"],CI["Level"],CI["Class"],CI["Race"] = name,UnitLevel(unitToken),UnitClass(unitToken),UnitRace(unitToken)
    end
end

function DBDT:ToggleConsoleKey(key)
    key = DBDT:Stringcheck(key,false)
    if DBDT:Boolcheck(DBDebugTable["Console_Enabled"]) then
        SetConsoleKey("nil")
        DBDebugTable["Console_Enabled"] = false
    else
        if key then
            SetConsoleKey(tostring(key))
        else
            SetConsoleKey("x")
        end
        DBDebugTable["Console_Enabled"] = true
    end
    DBDT:DBPrint(DBDebugTable["Console_Enabled"],f,f,gds(me,"ToggleConsoleKey","Enabled:"))
end


-- Export global functions
    if DBDT:TestValue(DBDT:EQ(Not,nil), false, true, "DB Global Init") then
        function Not(a1)
            return DBDT:Not(a1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Flip,nil), false, true, "DB Global Init") then
        function Flip(a1)
            return DBDT:Flip(a1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Nilcheck,nil), false, true, "DB Global Init") then
        function Nilcheck(a1,s1,s2)
           return DBDT:Nilcheck(a1,s1,s2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Typecheck,nil), false, true, "DB Global Init") then
        function Typecheck(a1,s1)
           return DBDT:Typecheck(a1,a1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(SetType,nil), false, true, "DB Global Init") then
        function SetType(a1,s1)
            return DBDT:SetType(a1,s1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Numcheck,nil), false, true, "DB Global Init") then
        function Numcheck(a1)
           return DBDT:Numcheck(a1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Boolcheck,nil), false, true, "DB Global Init") then
        function Boolcheck(a1,b1)
            return DBDT:Boolcheck(a1,b1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Tablecheck,nil), false, true, "DB Global Init") then
        function Tablecheck(a1,t1,b1)
            return DBDT:Tablecheck(a1,t1,b1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Stringcheck,nil), false, true, "DB Global Init") then
        function Stringcheck(a1,s1)
            return DBDT:Stringcheck(a1,s1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(SetPrecision,nil), false, true, "DB Global Init") then
        function SetPrecision(n1,n2)
           return DBDT:SetPrecision(n1,n2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Split,nil), false, true, "DB Global Init") then
        function Split(s1,s2)
           return DBDT:Split(s1,s2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(SetPower,nil), false, true, "DB Global Init") then
        function SetPower(n1,n2)
           return DBDT:SetPower(n1,n2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(GetPercent,nil), false, true, "DB Global Init") then
        function GetPercent(n1,n2)
           return DBDT:GetPercent(n1,n2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(RTC,nil), false, true, "DB Global Init") then
        function RTC(n1,n2)
           return DBDT:RTC(n1,n2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(EQ,nil), false, true, "DB Global Init") then
        function EQ(a1,a2)
           return DBDT:EQ(a1,a2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(NE,nil), false, true, "DB Global Init") then
        function NE(a1,a2)
           return DBDT:NE(a1,a2)
        end
    end
    
    if DBDT:TestValue(DBDT:EQ(inc,nil), false, true, "DB Global Init") then
        function inc(n1,n2)
           return DBDT:Increment(n1,n2)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Test,nil), false, true, "DB Global Init") then
        function Test(a1,b1,b2,s1)
            return DBDT:TestValue("a1",b1,b2,s1)
        end
    end

    if DBDT:TestValue(DBDT:EQ(Timestamp,nil), false, true, "DB Global Init") then
        function Timestamp()
            return DBDT:Timestamp()
        end
    end

        -- Factions
    if DBDT:TestValue(DBDT:EQ(GetAllKnownFactions,nil), false, true, "DB Global Init") then
        function GetAllKnownFactions()
            DBDT:GetAllKnownFactions()
        end
    end

        -- Dungeon/Raid
    if DBDT:TestValue(DBDT:EQ(DDiff,nil), false, true, "DB Global Init") then
        function DDiff(difficultyID)
            DBDT:SetDungeonDifficulty(difficultyID)
        end
    end

    if DBDT:TestValue(DBDT:EQ(RDiff,nil), false, true, "DB Global Init") then
        function RDiff(difficultyID)
            DBDT:SetRaidDifficulty(difficultyID)
        end
    end
-- End Global Aliases

--function gds(s1,a1,o1)
--    return DBDT:GenDebugString(s1,a1,o1)
--end

-- FINISHING UP VARIABLES
DB_Integers = DBDT:FindMinMax(5000)["value"]

-- Tell EVERYONE we're online.
_G["dbdt_loaded"] = true

-- EOF