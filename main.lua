-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )
local storyboard = require "storyboard"

local options ={
   effect ="fade", 
   time=400,
   params={
   var1= "init",
   sample_var= 1233456}
}

storyboard.gotoScene("battle", options)