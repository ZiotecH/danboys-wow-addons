local function HandleItem(ItemLocation)
    local itemGUID = C_Item.GetItemGUID(ItemLocation)
    if DBDT:Boolcheck(itemGUID) then
        if DBDT["QuickItemInfo"] then
            DBDT:ItemInfo(itemGUID,nil,false)
        else
            DBDT:QPrint(itemGUID,"DBDT","Hooks/Mouse_Click_Handler","HandleItem")
        end
    end
end

local function CheckHandler(_,_,EventData)
    local DebugInfo = {
        ["EventData"] = EventData,
        ["mouseFoci"] = false,
        ["generated"] = {},
        ["checks"] = {},
    }
    
    if DBDT:Typecheck(EventData,"string") then
        if DBDT:EQ(EventData,"LeftButton") then
            local mouseFoci = GetMouseFoci()
            local LeftCtrl,LeftShift = IsLeftControlKeyDown(),IsLeftShiftKeyDown()
            local modifiersHeld = DBDT:Boolcheck(LeftCtrl and LeftShift)
            
            if DBDT["PrintDebug"] then
                local mouseFoci_ChildCount = DBDT:CountChildren(mouseFoci)
                DebugInfo["generated"] = {
                    ["LeftCtrl"] = LeftCtrl,
                    ["LeftShift"] = LeftShift,
                    ["Modifiers Held"] = modifiersHeld,
                    ["Is Item"] = false,
                }
                DebugInfo["mouseFoci"] = mouseFoci
                if DBDT:Boolcheck(mouseFoci_ChildCount > 0) then
                    DBDT:Tablecheck("mouseFoci",DebugInfo["checks"],true)
                    DebugInfo["checks"]["mouseFoci"]["hasChildren"] = true
                    DebugInfo["checks"]["mouseFoci"]["numberOfChilren"] = mouseFoci_ChildCount
                    for k,v in pairs(mouseFoci) do
                        DebugInfo["checks"]["mouseFoci"]["child"..tostring(k)] = {
                            ["key"] = tostring(k),
                            ["type"] = type(v),
                            ["value"] = v,
                        }
                    end
                end
            end

            if DBDT:Boolcheck(mouseFoci[1].GetItemLocation) then
                if DBDT["PrintDebug"] then
                    DebugInfo["generated"]["Is Item"] = true
                end
                if modifiersHeld then
                    if DBDT["PrintDebug"] then
                        DebugInfo["generated"]["Modifiers Held"] = true
                    end
                    HandleItem(mouseFoci[1]:GetItemLocation())
                end
            end
        end
    end

    DBDT:Debug(DebugInfo,DBDT:GenDebugString("DBDT","Hooks/Mouse_Click_Handler","CheckHandler"))
end

local EventHook = CreateFrame("frame")
EventHook:SetScript("OnEvent",CheckHandler)
EventHook:RegisterEvent("GLOBAL_MOUSE_DOWN")
-- EventHook:RegisterEvent("PLAYER_LOGIN")