local TooltipWarnings = {
    ["items"] = {
        [204790] = "This item is non-vendorable despite having a value.",
    },
    ["spells"] = {},
    ["auras"] = {},
}

local dataIDColor = DBCol:GC("Violet")
local guidColor = DBCol:GC("Orchid")
local id_string = dataIDColor:Format("ID")
local id_string2 = ""
local guid_string = guidColor:Format("GUID")
local guid_string2 = ""



local function gds(msg)
    return DBDT:GenDebugString("DBDT","Injections/ItemTooltipInjector",msg)
end

local function tooltipSanity(tooltip)
    if tooltip:IsForbidden() then return false
    elseif tooltip ~= GameTooltip then return false
    else return true end
end

local function ItemTooltipInjector(tooltip,data)
    local classIDColor = DBCol:GC("DarkKhaki")
    local subclassIDColor = DBCol:GC("Tan")
    local expansionIDColor = DBCol:GC("PaleTurquoise")
    local factionIDColor = DBCol:GC("MediumPurple")
    local fastautosellColor = DBCol:GC("Cyan2")
    local locationColor = DBCol:GC("RosyBrown")
    local valueColor = DBCol:GC("Silver")
    local tfColor = {
        [true] = DBCol:GC("Chartreuse"),
        [false] = DBCol:GC("OrangeRed"),
    }
    local whiteColor = DBCol:GC("White")
        -- NIL
    local nilColor = DBCol:GC("Salmon")
    local nil_s = nilColor:Format("NIL")


    local scid = classIDColor:Format("Class")
    local sscid = subclassIDColor:Format("Subclass")
    local seid = expansionIDColor:Format("Expansion")
    local sfid = factionIDColor:Format("Faction")
    local sfas = fastautosellColor:Format("FastAutoSell")
    local sloc = locationColor:Format("Location")
    local sval = valueColor:Format("Item Value")
    local sstack = valueColor:Format("Stack Value")
    local sauc = valueColor:Format("Flippable")
    local saucp = valueColor:Format("Flip Profit")
    local swarn = nilColor:Format("Warning;")

    local BagLookup = {
        [-3] = "Reagent Bank",
        [-1] = "Main Bank Window",
        [0]  = "Backpack",
        [1]  = "Bag 1",
        [2]  = "Bag 2",
        [3]  = "Bag 3",
        [4]  = "Bag 4",
        [5]  = "Reagent Bag",
        [6]  = "Bank Bag 1",
        [7]  = "Bank Bag 2",
        [8]  = "Bank Bag 3",
        [9]  = "Bank Bag 4",
        [10] = "Bank Bag 5",
        [11] = "Bank Bag 6",
        [12] = "Bank Bag 7",
        [13] = "Warband Tab 1",
        [14] = "Warband Tab 2",
        [15] = "Warband Tab 3",
        [16] = "Warband Tab 4",
        [17] = "Warband Tab 5s",
    }
    local EquipmentLookup = {
        [0] = "Ammo", -- INVSLOT_AMMO	
        [1] = "Head", -- INVSLOT_HEAD 	
        [2] = "Neck", -- INVSLOT_NECK	
        [3] = "Shoulder", -- INVSLOT_SHOULDER
        [4] = "Body", -- INVSLOT_BODY	
        [5] = "Chest", -- INVSLOT_CHEST	
        [6] = "Waist", -- INVSLOT_WAIST	
        [7] = "Legs", -- INVSLOT_LEGS	
        [8] = "Feet", -- INVSLOT_FEET	
        [9] = "Wrist", -- INVSLOT_WRIST	
        [10] = "Hand", -- INVSLOT_HAND	
        [11] = "Finger 1", -- INVSLOT_FINGER1	
        [12] = "Finger 2", -- INVSLOT_FINGER2	
        [13] = "Trinket 1", -- INVSLOT_TRINKET1
        [14] = "Trinket 2", -- INVSLOT_TRINKET2
        [15] = "Back", -- INVSLOT_BACK	
        [16] = "Mainhand", -- INVSLOT_MAINHAND
        [17] = "Offhand", -- INVSLOT_OFFHAND	
        [18] = "Ranged", -- INVSLOT_RANGED	
        [19] = "Tabard", -- INVSLOT_TABARD	
    }

    local isRepTabard = DBDT:Boolcheck(DBDT["FactionData"]["Tabards"][data.id])

    local fas_table = {
        [true] = "Will be sold",
        [false] = "Will not be sold",
    }

    local id_s = ""
    local cid_s = ""
    local scid_s = ""
    local eid_s = ""
    local fid_s = ""
    local fas_s = ""
    local guid_s = ""
    local loc_s = ""
    local val_s = ""
    local auc_s = ""
    local aucp_s = ""
    local stack_s = ""


    local itemLocation
    local ItemExists
    local BagIndex
    local SlotIndex
    local EquipmentSlot
    local flipProfit = false
    local ahPrice = 0
    local vPrice = 0

    local importedData = {}

    if DBDT:EQ(tooltipSanity(tooltip),false) then return end
    if DBDT:Nilcheck(data.id) then
        local itemRef = false
        if DBDT:Boolcheck(data.guid) then itemRef = data.guid else itemRef = data.id end
        importedData = DBDT:ItemInfo(itemRef,false,true)
        DBDT:Debug(importedData,gds("Imported Data Result for "..tostring(itemRef)))
        
        if DBDT:Boolcheck(importedData) then
            id_s = dataIDColor:Format(tostring(data.id))
            guid_s = guidColor:Format(data.guid)
            cid_s = classIDColor:Format(DBDT:Stringcheck(importedData.RawData.itemType).." ("..tostring(importedData.RawData.classID)..")")
            scid_s = subclassIDColor:Format(DBDT:Stringcheck(importedData.RawData.itemSubType).." ("..tostring(importedData.RawData.subclassID)..")")
            eid_s = expansionIDColor:Format(DBDT:Stringcheck(DBDT["StringTables"]["ExpansionID"][importedData.RawData.expansionID]).." ("..tostring(importedData.RawData.expansionID)..")")
            -- Tabard has faction associated with it
            if isRepTabard then
                local grabbedFaction = DBDT["FactionData"]["Tabards"][data.id]
                if DBDT:Boolcheck(DBDT["FactionData"]["Factions"][grabbedFaction]) then
                    grabbedFaction = DBDT["FactionData"]["Factions"][grabbedFaction]
                else
                    grabbedFaction = C_Reputation.GetFactionDataByID(grabbedFaction)
                end
                fid_s = factionIDColor:Format(grabbedFaction.name.." ("..tostring(grabbedFaction.factionID)..")")
            end
            -- Item exists in FastAutoSell blacklist OR whitelist
            if DBDT:Boolcheck(FAS["ItemBlacklist"][data.id]) then
                fas_s = fastautosellColor:Format("Blacklisted")
            elseif DBDT:Boolcheck(FAS["ItemWhitelist"][data.id]) then
                fas_s = fastautosellColor:Format("Whitelisted")
            else
                if DBDT:Boolcheck(importedData["ItemGUID"]) then
                    fas_s = fas_table[DBDT:Boolcheck(FAS:CheckGUID(data.guid))]
                    fas_s = fastautosellColor:Format(fas_s)
                elseif DBDT:Boolcheck(importedData["ItemID"]) then
                    fas_s = fas_table[DBDT:Boolcheck(FAS:CheckItem(data.id))]
                    fas_s = fastautosellColor:Format(fas_s)
                else
                    fas_s = nil_s
                end
            end

            if DBDT:Boolcheck(DBDT["DB_Dependencies"]["Auctionator"]) then
                ahPrice = DBDT:Numcheck(Auctionator.API.v1.GetAuctionPriceByItemID("DBDT",data.id))
                vPrice = DBDT:Numcheck(importedData.RawData.sellPrice)
                if ahPrice > 0 then
                    flipProfit = DBDT:Boolcheck(ahPrice <= vPrice)
                    if flipProfit then
                        aucp_s = valueColor:Format(GetMoneyString(DBDT:Numcheck(math.abs(ahPrice - vPrice))).." (+"..DBDT:GetPercent(vPrice,ahPrice,false,true).."%)")
                    else
                        aucp_s = valueColor:Format(GetMoneyString(0))
                    end
                end
                auc_s = tfColor[flipProfit]:Format(tostring(flipProfit))
            end

            -- Check item location
            if DBDT:Boolcheck(data.guid) then
                itemLocation = C_Item.GetItemLocation(data.guid)
			    ItemExists 	 = C_Item.DoesItemExist(itemLocation)
                if ItemExists then
                    if DBDT:Boolcheck(itemLocation:IsBagAndSlot()) then
			            BagIndex	 = itemLocation["bagID"]
			            SlotIndex	 = itemLocation["slotIndex"]
                        loc_s = BagLookup[BagIndex].." - Slot "..tostring(SlotIndex)
                    elseif DBDT:Boolcheck(itemLocation:IsEquipmentSlot()) then
                        EquipmentSlot = itemLocation["equipmentSlotIndex"]
                        loc_s = EquipmentLookup[EquipmentSlot].." ("..tostring(EquipmentSlot)..")"
                    end
                    loc_s = locationColor:Format(loc_s)
                end
            else
                guid_s = nil_s
                itemLocation = false
                ItemExists = false
            end

            val_s = valueColor:Format(GetMoneyString(importedData.RawData.sellPrice))
            sstack = valueColor:Format(sstack.." ("..tostring(importedData.RawData.itemStackCount)..")")
            stack_s = valueColor:Format(GetMoneyString(importedData.RawData.sellPrice * importedData.RawData.itemStackCount))

        else
            id_s = nil_s
            cid_s = nil_s
            scid_s = nil_s
            fid_s = nil_s
            eid_s = nil_s
            fas_s = nil_s
            loc_s = nil_s
            val_s = nil_s
            stack_s = nil_s
            auc_s = nil_s
            aucp_s = nil_s
        end

        -- Add blank line
        tooltip:AddLine(" ")
        -- Item GUID
        tooltip:AddDoubleLine(guid_string,guid_s)
        -- Item ID
        tooltip:AddDoubleLine(id_string,id_s)
        -- Item exists in inventory
        if ItemExists then tooltip:AddDoubleLine(sloc,loc_s) end
        -- Item Class
        tooltip:AddDoubleLine(scid,cid_s)
        -- Item Subclass
        tooltip:AddDoubleLine(sscid,scid_s)
        -- Only if importedData exists.
        if DBDT:Boolcheck(importedData and DBDT:Not(TooltipWarnings["items"][data.id])) then
            -- Item Value
            if DBDT:Boolcheck(importedData.RawData.sellPrice > 0) then tooltip:AddDoubleLine(sval,val_s) end
            -- Stack Value
            if DBDT:Boolcheck(importedData.RawData.sellPrice > 0 and importedData.RawData.itemStackCount > 1) then tooltip:AddDoubleLine(sstack,stack_s) end
            --  Flip Profit (Dependant on Auctionator)
            --! Should only show if item isn't equipped or stored in bank/bag 
            if (DBDT["DB_Dependencies"]["Auctionator"] and DBDT:Boolcheck(importedData.RawData.sellPrice > 0) and DBDT:Boolcheck(ahPrice < vPrice)) then
                local validLoc = true
                if DBDT:Boolcheck(itemLocation) then
                    DBDT:Debug(itemLocation,DBDT:GenDebugString("DBDT","Item_Tooltips","itemLocation exists"))
                    validLoc = DBDT:Nor(itemLocation:IsBagAndSlot(),itemLocation:IsEquipmentSlot())
                end
                if validLoc then
                    tooltip:AddDoubleLine(sauc,auc_s)
                    if flipProfit then
                        tooltip:AddDoubleLine(saucp,aucp_s)
                    end
                end
            end
        end
        -- Item Expansion
        tooltip:AddDoubleLine(seid,eid_s)
        -- Item has rep?
        if isRepTabard then tooltip:AddDoubleLine(sfid,fid_s) end
        -- Add blank line
        tooltip:AddLine(" ")
        -- Item blacklisted?
        if DBDT:Boolcheck(importedData) then
            if DBDT:Boolcheck(importedData.RawData.sellPrice > 0) then
                tooltip:AddDoubleLine(sfas,fas_s)
            end
        end
        -- Item has warning?
        if DBDT:Boolcheck(TooltipWarnings[data.id]) then
            tooltip:AddLine(" ")
            tooltip:AddLine(swarn)
            tooltip:AddLine(whiteColor:Format(TooltipWarnings[data.id]))
        end
        -- Add blank line
        tooltip:AddLine(" ")
        
        DBDT:Debug({["Tooltip"]=tooltip,["Data"]=data,["Imported Data"]=importedData},DBDT:GenDebugString("Injections","Item_Tooltips",data.guid))
    end
end

local function SpellTooltipInjector(tooltip,data)
    if DBDT:EQ(tooltipSanity(tooltip),false) then return end
    if DBDT:Nilcheck(data.id) then
        id_string2 = dataIDColor:Format(tostring(data.id))
        if DBDT:Nilcheck(data.guid) then
            guid_string2 = guidColor:Format(data.guid)
            tooltip:AddDoubleLine(guid_string,guid_string2)
        end
        tooltip:AddDoubleLine(id_string,id_string2)
    end
end

local function UnitAuraTooltipInjector(tooltip,data)
    if DBDT:EQ(tooltipSanity(tooltip),false) then return end
    if DBDT:Nilcheck(data.id) then
        id_string2 = dataIDColor:Format(tostring(data.id))
        if DBDT:Nilcheck(data.guid) then
            guid_string2 = guidColor:Format(data.guid)
            tooltip:AddDoubleLine(guid_string,guid_string2)
        end
        tooltip:AddDoubleLine(id_string,id_string2)
    end
end

local function GenericTooltip(tooltip,msg)
    if DBDT:EQ(tooltipSanity(tooltip),false) then return end
    if DBDT:Nilcheck(msg) then
        tooltip:AddDoubleLine("TEST",msg)
    end
end

local function tooltipSwitch(tooltip_enum,tooltip,data)
    local call_table = {
    }
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
    SpellTooltipInjector(tooltip,data)
end)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
    ItemTooltipInjector(tooltip,data)
end)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.UnitAura, function(tooltip,data)
    UnitAuraTooltipInjector(tooltip,data)
end)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Object, function(a,b) GenericTooltip(a,"object") end)


-- LIST OF ENUMS
-- Item
-- Spell
-- Unit
-- Corpse
-- Object
-- Currency
-- BattlePet
-- UnitAura
-- AzeriteEssence
-- CompanionPet
-- Mount
-- PetAction
-- Achievement
-- EnhancedConduit
-- EquipmentSet
-- InstanceLock
-- PvPBrawl
-- RecipeRankInfo
-- Totem
-- Toy
-- CorruptionCleanser
-- MinimapMouseover
-- Flyout
-- Quest
-- QuestPartyProgress
-- Macro
-- Debug