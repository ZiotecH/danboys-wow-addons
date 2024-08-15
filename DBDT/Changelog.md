# Comprehensive Changelog

## 2024-08-15 (hash added with next udpate)

* `DBDT.toc`
  * Updated Interface to `110002`
  * Changed version from `0.1a` to `0.1b`
  * Added OptionalDep `!BugGrabber`
  * Added `DBDT_Col.lua`

* `DBDT_Main.lua`
  * Added shorthands `t,f` for `true,false`
  * Added alias `gds` for `DBDT:GenDebugString()`
  * `DBDT:PrintInit()`
    * Added check for `DevTool` and clumped all debug data into one table if so
    * Removed bloat from fallback mode
  * Added check for `global_bools`
  * Added `SlashCmdList`
    * Added `/db` as `SLASH_DBDT1`
    * Added command for `dp(a1)`
    * Added command for `DBDT:TDebug()`
    * Added command for `DBDT:ItemInfo(n1)`
    * Added fallback for invalid commands
  * Added function `Init()`
    * Moved `DBDT:PrintInit()` here
    * Added a call for `DBCol:Init()`
  * Changed init section to call `Init()`

* `DBDT_Helpers.lua`
  * Added `me` as alias for `"DBDT"`
  * Added `"Saved Colors"` to `DBDT["DBDebugTable"]`
  * Removed `"Count"` from `DBDT["ColorTable]`
  * Moved `sindent` to `DBDT["sindent"]`, removed whitespace.
  * Added `si` as alias for `DBDT["sindent"]`
  * Added shorthands `t,f` for `true,false`
  * Added `["!BugGrabber"]` to `DB_Dependencies`

  * `DBDT:TDebug()`
     * Removed local copy of `DBDT["PrintDebug"]`
     * Changed `DBPrint()` call to match.

  * Added global function `dp(InputData)`
     * Function prints whatever is passed via `DBDT:DBPrint()` with "Console" as the ID.

  * Added `DBDT:Boolcheck(payload)`
     * Returns `false` if `payload` is `nil` or `false`
     * Returns `true` otherwise

  * Added `DBDT:Timestamp()`
     * Returns a timestamp in the format `[00:00:00]` with the color `DarkGray`
   
  * Added `DBDT:PadSpace(v1)`
     * Returns `v1` many blank spaces

  * `DBDT:GenDebugString()`
     * Changed `correctformat` from `(object and id)` to just `(object and true)`
     * Added a timestamp to the generated string

  * Added `gds` as alias for `DBDT:GenDebugString()`

  * `DBDT:ColorHelper()`
     * Added functions to resulting table
       * `GetHex()` returns `["hex"]["argb"]`
       * `GetNorm()` returns each value of `["normalised"]`
       * `GetRGB()` returns each value of `["rgba"]`
       * `Get()` returns `["hex"]["argb]`
    
  * Added `DBDT:AddColor(r,g,b,a)`
    * Adds the specified color to the `DBDT["ColorTable]`
    * Updates `DBDT["DBDebugTable]["Saved Colors"]`
  
  * Added `DBDT:TestColor(name)`
    * Prints a line with the specified color if it exists
    * Displays all existing colors if no name is passed
  
  * Added `DBDT:TestFont(font)`
    * Changes `DevTool`'s font to the specified one and prints lines with the indent
  
  * Added `DBDT:CountChildren(t1)`
    * If `t1` is a table it returns the number of elements.
    * Does _NOT_ recurse.

  * Added `DBDT:Increment(n1,n2)`
    * Checks if passed values exist, else sets to `0`
    * Adds `n1` to `n2` and returns the result.

  * Added `DBDT:Indent(n1,ts)`
    * Checks if `n1` is a Number, returns `0` if not
    * Clamps `n1` to `minVal` and `maxVal` if `inf`
    * Checks if `t1` is a bool
    * Adds a trailing space if `ts` is `true`
    * Returns the `DBDT["sindent"]` with `v1` padding

  * Added global aliases for some functions
    * `Nilcheck()` = `DBDT:Nilcheck()`
    * `Typecheck()` = `DBDT:Typecheck()`
    * `Numcheck()` = `DBDT:Numcheck()`
    * `Boolcheck()` = `DBDT:Boolcheck()`
    * `SetPrecision()` = `DBDT:SetPrecision()`
    * `Split()` = `DBDT:Split()`
    * `SetPower()` = `DBDT:SetPower()`
    * `GetPercent()` = `DBDT:GetPercent()`
    * `RTC()` = `DBDT:RTC()`
    * `EQ()` = `DBDT:EQ()`
    * `NE()` = `DBDT:NE()`
    * `inc()` = `DBDT:Increment()`

  * Added call to `DBDT:FindMinMax(5000)["value"]` to set `DB_Integers` accordingly.
  * Added `_G["dbdt_loaded"] = true` to announce to other AddOns that we're up and running

  * Moved all color-related things to `DBDT_DBCol.lua`

* `DBDT_DBCol.lua`
  * Created file
  * Added `bDebug = false` for potential future use
  * Added local alias `colTable` for `DBDT["ColorTable"]`
  * Added local alias `dbTable` for `DBDT["DBDebugTable]`
  * Added function `cDebug()` to update `bDebug`
  * Added shorthands `t,f` for `true,false`
  * Added local alias `gds` for `DBDT:GenDebugString`
  * Added function `DBCol:Init()`
    * Clears `DBDT["ColorTable]`
    * Resets `DBDT["DBDebugTable]["Saved Colors"]` to `0`
    * Moved all `DBDT:AddColor` calls into `DBCol:Init()`
    * Updates `DBCol["ColorTable"]` to match `DBDT["ColorTable"]`
    * Calls `cDebug()`
    * Prints `DBDT["ColorTable"]` if `bDebug` is `true`