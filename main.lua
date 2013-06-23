local widget = require( "widget" )
local game = require("game")

local text = display.newText("Mine Percentage", 0, 30, native.systemFont, 24)  
local defaultField = native.newTextField( 200, 30, 180, 30 )

local myButton = widget.newButton
{
    left = 400,
    top = 30,
    width = 150,
    height = 50,
    id = "button_1",
    label = "Start Game",
    onEvent = startGame,
}

local function startGame( event )
	if(defaultField.text ~= nil) then
		text:removeSelf()
		defaultField:removeSelf()
        game.restart(defaultField.text)
   end
end

local myButton = widget.newButton
{
    left = 400,
    top = 30,
    width = 150,
    height = 50,
    id = "button_1",
    label = "Start Game",
    onEvent = startGame,
}


