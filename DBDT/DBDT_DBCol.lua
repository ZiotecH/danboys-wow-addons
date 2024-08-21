-- Explanation;
    -- Dynamic gen stuff
    -- Generate dynamic min/max

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

    -- Load relevant globals
-- End Explanation

local t,f = true,false
local me = "DBCol"
local ct1 = DBDT["ColorTable"] --?
local dbt = DBDT["DBDebugTable"]

-- Set up global table
_G["DBCol"] = {}
-- Local functions
local function gds(a1,o1)
    return DBDT:GenDebugString(me,a1,o1)
end

-- Global functions
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
function DBCol:TC(name)
    DBDT:TestColor(name)
end
-- DBCol Only
-- Print Examples
function DBCol:PE(category)
    local obj = "Print Examples"
    if DBDT:Stringcheck(category) then
        if DBDT:Boolcheck(DBCol["ColorTable"][category]) then
            for Name,Data in pairs(DBCol["ColorTable"][category]) do
                DBDT:DBPrint(Data["Example"],false,false,gds(obj,Name))
            end
        else
            DBDT:DBPrint(false,false,false,gds(obj,category))
        end
    else
        DBDT:DBPrint(false,false,false,gds(obj,"Invalid Input"))
    end
end



-- Color Init Function
function DBCol:Init()
    local obj = "Init"
    DBDT["ColorTable"] = {}
    dbt["Saved Colors"] = 0
    -- Add colors
        -- Base Colors
        DBDT:AddColor(0,0,0,255,"Black","Standard")                         -- (000000)
        DBDT:AddColor(255,255,255,255,"White","Standard")                   -- (FFFFFF)
        DBDT:AddColor(255,0,0,255,"Red","Standard")                         -- (FF0000)
        DBDT:AddColor(0,128,0,255,"Green","Standard")                       -- (008000)
        DBDT:AddColor(0,0,255,255,"Blue","Standard")                        -- (0000FF)
        -- Official colors, see links above


        -- Pink colors
        DBDT:AddColor(219,112,147,255,"MediumVioletRed","Standard")         -- (C71585)
        DBDT:AddColor(199,21,133,255,"DeepPink","Standard")                 -- (FF1493)
        DBDT:AddColor(255,20,147,255,"PaleVioletRed","Standard")            -- (DB7093)
        DBDT:AddColor(255,105,180,255,"HotPink","Standard")                 -- (FF69B4)
        DBDT:AddColor(255,182,193,255,"LightPink","Standard")               -- (FFB6C1)
        DBDT:AddColor(255,192,203,255,"Pink","Standard")                    -- (FFC0CB)
        -- Red colors
        DBDT:AddColor(139,0,0,255,"DarkRed","Standard")                     -- (8B0000)
        DBDT:AddColor(178,34,34,255,"FireBrick","Standard")                 -- (B22222)
        DBDT:AddColor(220,20,60,255,"Crimson","Standard")                   -- (DC143C)
        DBDT:AddColor(205,92,92,255,"IndianRed","Standard")                 -- (CD5C5C)
        DBDT:AddColor(240,128,128,255,"LightCoral","Standard")              -- (F08080)
        DBDT:AddColor(250,128,114,255,"Salmon","Standard")                  -- (FA8072)
        DBDT:AddColor(233,150,122,255,"DarkSalmon","Standard")              -- (E9967A)
        DBDT:AddColor(255,160,122,255,"LightSalmon","Standard")             -- (FFA07A)
        -- Orange colors
        DBDT:AddColor(255,69,0,255,"OrangeRed","Standard")                  -- (FF4500)
        DBDT:AddColor(255,99,71,255,"Tomato","Standard")                    -- (FF6347)
        DBDT:AddColor(255,140,0,255,"DarkOrange","Standard")                -- (FF8C00)
        DBDT:AddColor(255,127,80,255,"Coral","Standard")                    -- (FF7F50)
        DBDT:AddColor(255,165,0,255,"Orange","Standard")                    -- (FFA500)
        -- Yellow colors
        DBDT:AddColor(189,183,107,255,"DarkKhaki","Standard")               -- (BDB76B)
        DBDT:AddColor(255,215,0,255,"Gold","Standard")                      -- (FFD700)
        DBDT:AddColor(240,230,140,255,"Khaki","Standard")                   -- (F0E68C)
        DBDT:AddColor(255,218,185,255,"PeachPuff","Standard")               -- (FFDAB9)
        DBDT:AddColor(255,255,0,255,"Yellow","Standard")                    -- (FFFF00)
        DBDT:AddColor(238,232,170,255,"PaleGoldenrod","Standard")           -- (EEE8AA)
        DBDT:AddColor(255,228,181,255,"Moccasin","Standard")                -- (FFE4B5)
        DBDT:AddColor(255,239,213,255,"PapayaWhip","Standard")              -- (FFEFD5)
        DBDT:AddColor(250,250,210,255,"LightGoldenrodYellow","Standard")    -- (FAFAD2)
        DBDT:AddColor(255,250,205,255,"LemonChiffon","Standard")            -- (FFFACD)
        DBDT:AddColor(255,255,224,255,"LightYellow","Standard")             -- (FFFFE0)
        -- Brown colors
        DBDT:AddColor(128,0,0,255,"Maroon","Standard")                      -- (800000)
        DBDT:AddColor(165,42,42,255,"Brown","Standard")                     -- (A52A2A)
        DBDT:AddColor(139,69,19,255,"SaddleBrown","Standard")               -- (8B4513)
        DBDT:AddColor(160,82,45,255,"Sienna","Standard")                    -- (A0522D)
        DBDT:AddColor(210,105,30,255,"Chocolate","Standard")                -- (D2691E)
        DBDT:AddColor(184,134,11,255,"DarkGoldenrod","Standard")            -- (B8860B)
        DBDT:AddColor(205,133,63,255,"Peru","Standard")                     -- (CD853F)
        DBDT:AddColor(188,143,143,255,"RosyBrown","Standard")               -- (BC8F8F)
        DBDT:AddColor(218,165,32,255,"Goldenrod","Standard")                -- (DAA520)
        DBDT:AddColor(244,164,96,255,"SandyBrown","Standard")               -- (F4A460)
        DBDT:AddColor(210,180,140,255,"Tan","Standard")                     -- (D2B48C)
        DBDT:AddColor(222,184,135,255,"BurlyWood","Standard")               -- (DEB887)
        DBDT:AddColor(245,222,179,255,"Wheat","Standard")                   -- (F5DEB3)
        DBDT:AddColor(255,222,173,255,"NavajoWhite","Standard")             -- (FFDEAD)
        DBDT:AddColor(255,228,196,255,"Bisque","Standard")                  -- (FFE4C4)
        DBDT:AddColor(255,235,205,255,"BlanchedAlmond","Standard")          -- (FFEBCD)
        DBDT:AddColor(255,248,220,255,"Cornsilk","Standard")                -- (FFF8DC)
        -- Purple, violet, and magenta colors
        DBDT:AddColor(75,0,130,255,"Indigo","Standard")                     -- (4B0082)
        DBDT:AddColor(128,0,128,255,"Purple","Standard")                    -- (800080)
        DBDT:AddColor(139,0,139,255,"DarkMagenta","Standard")               -- (8B008B)
        DBDT:AddColor(148,0,211,255,"DarkViolet","Standard")                -- (9400D3)
        DBDT:AddColor(72,61,139,255,"DarkSlateBlue","Standard")             -- (483D8B)
        DBDT:AddColor(138,43,226,255,"BlueViolet","Standard")               -- (8A2BE2)
        DBDT:AddColor(153,50,204,255,"DarkOrchid","Standard")               -- (9932CC)
        DBDT:AddColor(255,0,255,255,"Fuchsia","Standard")                   -- (FF00FF)
        DBDT:AddColor(255,0,255,255,"Magenta","Standard")                   -- (FF00FF)
        DBDT:AddColor(106,90,205,255,"SlateBlue","Standard")                -- (6A5ACD)
        DBDT:AddColor(123,104,238,255,"MediumSlateBlue","Standard")         -- (7B68EE)
        DBDT:AddColor(186,85,211,255,"MediumOrchid","Standard")             -- (BA55D3)
        DBDT:AddColor(147,112,219,255,"MediumPurple","Standard")            -- (9370DB)
        DBDT:AddColor(218,112,214,255,"Orchid","Standard")                  -- (DA70D6)
        DBDT:AddColor(238,130,238,255,"Violet","Standard")                  -- (EE82EE)
        DBDT:AddColor(221,160,221,255,"Plum","Standard")                    -- (DDA0DD)
        DBDT:AddColor(216,191,216,255,"Thistle","Standard")                 -- (D8BFD8)
        DBDT:AddColor(230,230,250,255,"Lavender","Standard")                -- (E6E6FA)
        -- Blue colors
        DBDT:AddColor(25,25,112,255,"MidnightBlue","Standard")              -- (191970)
        DBDT:AddColor(0,0,128,255,"Navy","Standard")                        -- (000080)
        DBDT:AddColor(0,0,139,255,"DarkBlue","Standard")                    -- (00008B)
        DBDT:AddColor(0,0,205,255,"MediumBlue","Standard")                  -- (0000CD)
        DBDT:AddColor(65,105,225,255,"RoyalBlue","Standard")                -- (4169E1)
        DBDT:AddColor(70,130,180,255,"SteelBlue","Standard")                -- (4682B4)
        DBDT:AddColor(30,144,255,255,"DodgerBlue","Standard")               -- (1E90FF)
        DBDT:AddColor(0,191,255,255,"DeepSkyBlue","Standard")               -- (00BFFF)
        DBDT:AddColor(100,149,237,255,"CornflowerBlue","Standard")          -- (6495ED)
        DBDT:AddColor(135,206,235,255,"SkyBlue","Standard")                 -- (87CEEB)
        DBDT:AddColor(135,206,250,255,"LightSkyBlue","Standard")            -- (87CEFA)
        DBDT:AddColor(176,196,222,255,"LightSteelBlue","Standard")          -- (B0C4DE)
        DBDT:AddColor(173,216,230,255,"LightBlue","Standard")               -- (ADD8E6)
        DBDT:AddColor(176,224,230,255,"PowderBlue","Standard")              -- (B0E0E6)
        -- Cyan colors
        DBDT:AddColor(0,128,128,255,"Teal","Standard")                      -- (008080)
        DBDT:AddColor(0,139,139,255,"DarkCyan","Standard")                  -- (008B8B)
        DBDT:AddColor(32,178,170,255,"LightSeaGreen","Standard")            -- (20B2AA)
        DBDT:AddColor(95,158,160,255,"CadetBlue","Standard")                -- (5F9EA0)
        DBDT:AddColor(0,206,209,255,"DarkTurquoise","Standard")             -- (00CED1)
        DBDT:AddColor(248,209,204,255,"MediumTurquoise","Standard")         -- (F8D1CC)
        DBDT:AddColor(64,224,208,255,"Turquoise","Standard")                -- (40E0D0)
        DBDT:AddColor(0,255,255,255,"Aqua","Standard")                      -- (00FFFF)
        DBDT:AddColor(0,255,255,255,"Cyan","Standard")                      -- (00FFFF)
        DBDT:AddColor(127,255,212,255,"Aquamarine","Standard")              -- (7FFFD4)
        DBDT:AddColor(175,238,238,255,"PaleTurquoise","Standard")           -- (AFEEEE)
        DBDT:AddColor(224,255,255,255,"LightCyan","Standard")               -- (E0FFFF)
        -- Green colors
        DBDT:AddColor(0,100,0,255,"DarkGreen","Standard")                   -- (006400)
        DBDT:AddColor(85,107,47,255,"DarkOliveGreen","Standard")            -- (556B2F)
        DBDT:AddColor(34,139,34,255,"ForestGreen","Standard")               -- (228B22)
        DBDT:AddColor(46,139,87,255,"SeaGreen","Standard")                  -- (2E8B57)
        DBDT:AddColor(128,128,0,255,"Olive","Standard")                     -- (808000)
        DBDT:AddColor(107,142,35,255,"OliveDrab","Standard")                -- (6B8E23)
        DBDT:AddColor(60,179,113,255,"MediumSeaGreen","Standard")           -- (3CB371)
        DBDT:AddColor(50,205,50,255,"LimeGreen","Standard")                 -- (32CD32)
        DBDT:AddColor(0,255,0,255,"Lime","Standard")                        -- (00FF00)
        DBDT:AddColor(0,255,127,255,"SpringGreen","Standard")               -- (00FF7F)
        DBDT:AddColor(0,250,154,255,"MediumSpringGreen","Standard")         -- (00FA9A)
        DBDT:AddColor(143,188,143,255,"DarkSeaGreen","Standard")            -- (8FBC8F)
        DBDT:AddColor(102,205,170,255,"MediumAquamarine","Standard")        -- (66CDAA)
        DBDT:AddColor(154,205,50,255,"YellowGreen","Standard")              -- (9ACD32)
        DBDT:AddColor(124,252,0,255,"LawnGreen","Standard")                 -- (7CFC00)
        DBDT:AddColor(127,255,0,255,"Chartreuse","Standard")                -- (7FFF00)
        DBDT:AddColor(144,238,144,255,"LightGreen","Standard")              -- (90EE90)
        DBDT:AddColor(173,255,47,255,"GreenYellow","Standard")              -- (ADFF2F)
        DBDT:AddColor(152,251,152,255,"PaleGreen","Standard")               -- (98FB98)
        -- White colors
        DBDT:AddColor(255,228,225,255,"MistyRose","Standard")               -- (FFE4E1)
        DBDT:AddColor(250,235,215,255,"AntiqueWhite","Standard")            -- (FAEBD7)
        DBDT:AddColor(250,240,230,255,"Linen","Standard")                   -- (FAF0E6)
        DBDT:AddColor(245,245,220,255,"Beige","Standard")                   -- (F5F5DC)
        DBDT:AddColor(245,245,245,255,"WhiteSmoke","Standard")              -- (F5F5F5)
        DBDT:AddColor(255,240,245,255,"LavenderBlush","Standard")           -- (FFF0F5)
        DBDT:AddColor(253,245,230,255,"OldLace","Standard")                 -- (FDF5E6)
        DBDT:AddColor(240,248,255,255,"AliceBlue","Standard")               -- (F0F8FF)
        DBDT:AddColor(255,245,238,255,"Seashell","Standard")                -- (FFF5EE)
        DBDT:AddColor(248,248,255,255,"GhostWhite","Standard")              -- (F8F8FF)
        DBDT:AddColor(240,255,240,255,"Honeydew","Standard")                -- (F0FFF0)
        DBDT:AddColor(255,250,240,255,"FloralWhite","Standard")             -- (FFFAF0)
        DBDT:AddColor(240,255,255,255,"Azure","Standard")                   -- (F0FFFF)
        DBDT:AddColor(245,255,250,255,"MintCream","Standard")               -- (F5FFFA)
        DBDT:AddColor(255,250,250,255,"Snow","Standard")                    -- (FFFAFA)
        DBDT:AddColor(255,255,240,255,"Ivory","Standard")                   -- (FFFFF0)
        -- Gray and black colors
        DBDT:AddColor(47,79,79,255,"DarkSlateGray","Standard")              -- (2F4F4F)
        DBDT:AddColor(105,105,105,255,"DimGray","Standard")                 -- (696969)
        DBDT:AddColor(112,128,144,255,"SlateGray","Standard")               -- (708090)
        DBDT:AddColor(128,128,128,255,"Gray","Standard")                    -- (808080)
        DBDT:AddColor(119,136,153,255,"LightSlateGray","Standard")          -- (778899)
        DBDT:AddColor(169,169,169,255,"DarkGray","Standard")                -- (A9A9A9)
        DBDT:AddColor(192,192,192,255,"Silver","Standard")                  -- (C0C0C0)
        DBDT:AddColor(211,211,211,255,"LightGray","Standard")               -- (D3D3D3)
        DBDT:AddColor(220,220,220,255,"Gainsboro","Standard")               -- (DCDCDC)


        -- Non-Offical Colors
        -- My strange names
        DBDT:AddColor(255,50,0,255,"ROrange","Danboy")                    -- (FF3200) | Kind of in-between red and orange
        DBDT:AddColor(255,150,0,255,"YOrange","Danboy")                   -- (FF9600) | Kind of in-between orange and yellow
        DBDT:AddColor(215,255,0,255,"Yeen","Danboy")                      -- (D7FF00) | Kind of in-between yellow and (true) green
        DBDT:AddColor(0,255,125,255,"Glue","Danboy")                      -- (00FF7D) | Kind of in-between (true)green and blue
        DBDT:AddColor(240,30,100,255,"Ponk","Danboy")                     -- (F01E64) | Personal favourite pink
        DBDT:AddColor(120,15,50,255,"DarkPonk","Danboy")                  -- (780F32) | Darker version of ponk
        DBDT:AddColor(120,30,100,255,"Porp","Danboy")                     -- (781E64) | Personal preference for purple
        -- Slightly modified colors
        DBDT:AddColor(255,50,0,255,"OrangeRed2","Danboy")                 -- (FF6400) | Slightly brighter than "OrangeRed"
        DBDT:AddColor(255,240,0,255,"Yellow2","Danboy")                   -- (FFF000) | Slightly redder yellow
        DBDT:AddColor(0,185,0,255,"Green2","Danboy")                      -- (00B900) | Slightly modifed green
        DBDT:AddColor(0,255,200,255,"Cyan2","Danboy")                     -- (00FFC8) | Personal preference for cyan

        -- My Faction Colors
        --

        -- Reputation Table Colors
        DBDT:AddColor(255,220,100,255,"FactionHeader","Reputation Headers")
        DBDT:AddColor(100,125,255,255,"FactionSubHeader","Reputation Headers")
        DBDT:AddColor(100,255,140,255,"FactionTitle","Reputation Headers")
        DBDT:AddColor(95,128,50,255,"FactionSubTitle","Reputation Headers")
        DBDT:AddColor(175,30,30,255,"EmptyHeader","Reputation Headers")

        -- Standing Level Colors
        DBDT:AddColor(255,0,0,255,"Hated","Standing")
        DBDT:AddColor(255,125,0,255,"Hostile","Standing")
        DBDT:AddColor(255,199,0,255,"Unfriendly","Standing")
        DBDT:AddColor(255,255,0,255,"Neutral","Standing")
        DBDT:AddColor(199,255,0,255,"Friendly","Standing")
        DBDT:AddColor(125,255,0,255,"Honored","Standing")
        DBDT:AddColor(0,255,125,255,"Revered","Standing")
        DBDT:AddColor(0,255,255,255,"Exalted","Standing")
        DBDT:AddColor(255,255,255,255,"Maxed","Standing")


        -- WoW-Item Colors
        for key, value in pairs(DBDT["CONSTANTS"]["QualityColors"]) do 
            local t1 = value["rgba"]
            DBDT:AddColor(t1["red"],t1["green"],t1["blue"],t1["alpha"],DBDT["StringTables"]["QualityID"][key],"Quality")
        end
    -- End AddColors

    -- Update own color table
    DBCol["ColorTable"] = {}
    for key,value in pairs(DBDT["ColorTable"]) do
        local tmpCat = false
        if value["Category"] then
            tmpCat = value["Category"]
            DBDT:Tablecheck(tmpCat,DBCol["ColorTable"],true)
            DBCol["ColorTable"][tmpCat][key] = value
        end
    end

    if DBDT["PrintDebug"] then
        DBDT:DBPrint(
            {
                ["Full Table"] = DBDT["ColorTable"],
                ["Categories"] = DBCol["Category"],
            },
            true,
            true,
            gds(obj,tostring(DBDT["Saved Colors"]).." saved colors")
        )
    end

    if not _G["Color"] then
        _G["Color"] = _G["DBCol"]
    end

end