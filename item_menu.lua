require "sqlite3"
local storyboard = require "storyboard"
local widget = require "widget"
local scene = storyboard.newScene()

local scrollview
local menuBG
local backButton
local params
local item_list
local item_personaje

local function onButtonEvent( event )
   local phase = event.phase
   local target = event.target
      if ( "began" == phase ) then
      	if(target.id == "Back") then
      		print "go back"
      		storyboard.purgeScene( "item_menu" )
      		storyboard.gotoScene("battle", "fade", 300)
        else
          print ("usar item")

          for i=1,#item_personaje do
              if (item_personaje[i].id==target.id)then
                cantidad = item_personaje[i].cantidad-1
                break
              end
          end
         
          q = [[UPDATE item_player SET cantidad = ]]..cantidad..[[ WHERE id_item = ]]..target.id..[[ AND personaje = ]]..params.jugador_id..[[;]]
          print (q)
          db:exec(q)

          storyboard.purgeScene( "item_menu" )
         storyboard.gotoScene("battle", "fade", 300)
      	end
      print( target.id .. " pressed" )
      target:setLabel( "Pressed" ) --set a new label
   elseif ( "ended" == phase ) then
      print( target.id .. " released" )
      target:setLabel( target.baseLabel )  --reset the label
   end
   return true
end

local function  scrollListener( event )
  local phase = event.phase
  local direction = event.direction

  if event.limitReached then
    if "right" == direction then
        print ("right limit")
        elseif "left" == direction then
        print ("left limit")
    end
  end

  return true
end

local function buttonMaker(id,name,cantidad,fil,col)
  local button
  if(id~="Back")then
    button = widget.newButton{
   id= id,
   left = 115*col,
   top = 70*fil,
   width = 79,
   height = 30,
   defaultFile="img/button/1-1.png",
   overFile="img/button/1-2.png",
   label = name.." x "..cantidad,
   labelAlign = "center",
   font = "Arial",
   fontSize = 35,
   labelColor = { default = {255,255,255}, over = {0,255,0} },
   isEnabled = true,
   isVisible = true,
   onEvent = onButtonEvent
}
  button.baseLabel=name.."x "..cantidad
else
    button = widget.newButton{
   id= id,
   left = 300*col,
   top = 70*fil,
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
end
return button
end

function scene:createScene( event )
   local group = scene.view
   local path = system.pathForFile("data.db", system.ResourceDirectory)
  print(path)
  db = sqlite3.open( path ) 
	params = event.params
  print( params.jugador_id)

local query = "SELECT * FROM item_game WHERE id in (SELECT id_item FROM item_player WHERE personaje ="..params.jugador_id..")"

  print (query)

  item_personaje={}
  
  for row in db:nrows(query) do
    print (row.id,row.name)
    item_personaje[#item_personaje+1]={
    id= row.id,
    name= row.name,
    damage = row.damage,
    heal_hp= row.heal_hp,
    heal_mp=row.heal_mp,
    cantidad=0}
  end 

  query= "SELECT id_item,cantidad FROM item_player WHERE personaje ="..params.jugador_id

  for row in db:nrows(query) do
      id=row.id_item
      cantidad=row.cantidad

      for i=1, #item_personaje do
        if(item_personaje[i].id==id)then
          item_personaje[i].cantidad=cantidad
          break
        end
      end

  end


  scrollview = widget.newScrollView{
  left = 0,
  top = display.contentHeight-201,
  width= display.contentWidth,
  height=200,
  scrollWidth = 40000,
  scrollHeight = 1000,
  horizontalScrollDisabled = false,
  verticalScrollDisabled = true,
  listener = scrollListener,
  hideBackground=true
  }

  group:insert(scrollview)

	menuBG=display.newRect(0,100,40000,196)
	menuBG.strokeWidth=3
	menuBG:setFillColor( 0.3, 0.3, 0.3, 0.6 )
	menuBG:setStrokeColor(1,1,1,1)
	menuBG.isVisible=true

  print(scrollview.left)
	
  scrollview:insert( menuBG )
  
  item_list={}

  for i=1,#item_personaje do
      x=((i-1)%3)
      y=math.floor((i-1)/3)
      item_list[i]=buttonMaker(item_personaje[i].id,item_personaje[i].name,item_personaje[i].cantidad,x,y)
  end

      x=((#item_list)%3)
      y=math.floor((#item_list)/3)
      item_list[#item_list+1]=buttonMaker("Back","","",x,y)

  for i=1,#item_list do
  scrollview:insert(item_list[i])
  end
  
  scrollview:toFront()
	--group:toFront()
 
end

scene:addEventListener( "createScene", scene )



function scene:willEnterScene( event )
  local group = scene.view
  	 menuBG.isVisible=true
end

scene:addEventListener( "willEnterScene", scene )



function scene:enterScene( event )
	local group = self.view
 end

scene:addEventListener( "enterScene", scene )



function scene:exitScene( event )
   print("exit item menu")
   if db and db:isopen() then
    db:close()
   end
end
scene:addEventListener( "exitScene", scene )

return scene