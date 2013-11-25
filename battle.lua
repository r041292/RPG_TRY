local widget = require "widget"
local storyboard = require "storyboard"
local scene = storyboard.newScene()
local stage = display.getCurrentStage()
storyboard.disableAutoPurge = true


local options_item ={
   effect ="fade", 
   time=400,
   params={
   jugador_id= 1,
   }
}

print(display.contentWidth)
print(display.contentHeight)
print(display.screenOriginY)


local function onButtonEvent( event )
   local phase = event.phase
   local target = event.target
      if ( "began" == phase ) then
      print( target.id .. " pressed" )
      if(target.id=="attack") then
         print "do attack thingie"
         storyboard.removeScene( "battle" )
      else if(target.id=="Item")then
         print "open item menu"
         storyboard.gotoScene("item_menu", options_item)
      end
      end
      target:setLabel( "Pressed" ) --set a new label
      
   elseif ( "ended" == phase ) then
      print( target.id .. " released" )
      target:setLabel( target.baseLabel )  --reset the label
   end
   return true
end


local function buttonMaker(id,fil,col)
  local button
  
    button = widget.newButton{
   id= id,
   left = 115*col,
   top = display.contentHeight-200/fil,
   width = 79,
   height = 30,
   defaultFile="img/button/1-1.png",
   overFile="img/button/1-2.png",
   label = id,
   labelAlign = "center",
   font = "Arial",
   fontSize = 35,
   labelColor = { default = {255,255,255}, over = {0,255,0} },
   isEnabled = true,
   isVisible = true,
   onEvent = onButtonEvent
}
  button.baseLabel=id

return button
end



function scene:createScene( event )
   local group = scene.view

   local background = display.newImage( "img/bg/dbszabo1.jpg", display.contentCenterX, display.contentCenterY,true )

   local myText = display.newText( "BATTLE!", display.contentCenterX, display.contentWidth / 4, "Zapfino", 40 )
   myText:setFillColor( 0, 110/255, 110/255 )

   group:insert(background)
   group:insert(myText)

   stage:insert(background)
   --stage:insert(myText)
   stage:insert(storyboard.stage)

   local menuBG=display.newRect(0,display.contentHeight-101,display.contentWidth*2,200)
   menuBG.strokeWidth=3
   menuBG:setFillColor( 0.5, 0.5, 0.6, 0.86 )
   menuBG:setStrokeColor(1,1,1)

   group:insert(menuBG)

   buttons={}
   buttons[1]= buttonMaker("Attack",1,0)
   buttons[3]= buttonMaker("Magic",2,0)
   buttons[4]= buttonMaker("Special",1,2)
   buttons[2]= buttonMaker("Item",2,2)
   buttons[5]= buttonMaker("Run",1,4)

   for i=1,#buttons do
      group:insert(buttons[i])
   end

end

scene:addEventListener( "createScene", scene )

function scene:willEnterScene( event )
   local group = scene.view
end

scene:addEventListener( "willEnterScene", scene )

function scene:enterScene( event )
   local group = scene.view   
 end

scene:addEventListener( "enterScene", scene )

function scene:exitScene( event )
   local group = scene.view
end
scene:addEventListener( "exitScene", scene )

return scene