local widget = require "widget"

local function scrollListener( event )

   local phase = event.phase
   print( phase )

   local direction = event.direction

   -- If the scrollView has reached it's scroll limit
   if ( event.limitReached ) then
      if ( "up" == direction ) then
         print( "Reached Top Limit" )
      elseif ( "down" == direction ) then
         print( "Reached Bottom Limit" )
      elseif ( "left" == direction ) then
         print( "Reached Left Limit" )
      elseif ( "right" == direction ) then
         print( "Reached Right Limit" )
      end
   end
   return true
end

local scrollView = widget.newScrollView
{
   left = 10,
   top = 100,
   width = 300,
   height = 350,
   maskFile = "assets/scrollViewMask-350.png",
   scrollWidth = 465,
   scrollHeight = 670,
   friction = 0.972,
   listener = scrollListener,
}

local background = display.newImageRect( "img/bg/kuina1.jpg.jpg", 768, 1024 )
background.x = bg.contentWidth * 0.5
background.y = bg.contentHeight * 0.5
scrollView:insert( background )