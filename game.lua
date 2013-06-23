module(..., package.seeall)
 local minesPercentage = 0
 local mines = {}
 local rectangles = {}
 local rectanglesHash = {}
 local discovered = 0
 local bigRect = nil


function isMine(x, y)
	return mines[x..y] ~= null
end

function countSorroundingMines(x, y)
	local count = 0
	if(isMine(x-1,y-1)) then
		count = count + 1 
	end
	if(isMine(x-1,y)) then
		count = count + 1 
	end
	if(isMine(x-1,y+1)) then
		count = count + 1 
	end
	if(isMine(x,y-1)) then
		count = count + 1 
	end
	if(isMine(x,y+1)) then
		count = count + 1 
	end
	if(isMine(x+1,y)) then
		count = count + 1 
	end
	if(isMine(x+1,y-1)) then
		count = count + 1 
	end
	if(isMine(x+1,y+1)) then
		count = count + 1 
	end
	return count
end

function onGameComplete(event)
	if event.action == "clicked" then
		if event.index == 1 then
			bigRect:removeSelf()
			bigRect = nil
			restart(minesPercentage)
		else
			os.exit()
		end	
	end
end

function removeRectangle(rectangle)
	rectanglesHash[rectangle.i..rectangle.j] = nil
	for i=1, #rectangles, 1 do
		if rectangles[i] == rectangle then
			rectangles[i] = nil
		end
	end  
	rectangle:removeSelf() 
	rectangle = nil
end

function showAllBombs()
	for i=1, #rectangles, 1 do
		if rectangles[i]~= nil and rectangles[i].x ~= nil then
			if mines[rectangles[i].i..rectangles[i].j] ~= nil then
				local image = display.newImageRect( "bomb.jpg",50,50)
				image:setReferencePoint( display.CenterReferencePoint )
				image.x = rectangles[i].x
				image.y = rectangles[i].y
				removeRectangle(rectangles[i])
			end
		end
	end
end

function showSurroundingMines(rectangle)
	if(rectangle == nil) then
		return
	end
	local count = countSorroundingMines(rectangle.i, rectangle.j)
	local text = display.newText(count, rectangle.x, rectangle.y, native.systemFont, 32)  
	removeRectangle(rectangle) 
	if count == 0 then
		showSurroundingMines(rectanglesHash[(rectangle.i-1)..(rectangle.j-1)])
		showSurroundingMines(rectanglesHash[(rectangle.i-1)..(rectangle.j)])
		showSurroundingMines(rectanglesHash[(rectangle.i-1)..(rectangle.j+1)])
		showSurroundingMines(rectanglesHash[(rectangle.i)..(rectangle.j-1)])
		showSurroundingMines(rectanglesHash[(rectangle.i)..(rectangle.j+1)])
		showSurroundingMines(rectanglesHash[(rectangle.i+1)..(rectangle.j-1)])
		showSurroundingMines(rectanglesHash[(rectangle.i+1)..(rectangle.j)])
		showSurroundingMines(rectanglesHash[(rectangle.i+1)..(rectangle.j+1)])
	end 
end

function initializeMineMatrix(sizeX,sizeY)
	numberOfMines = sizeX * sizeY * minesPercentage / 100
	for i=0, numberOfMines, 1 do
		randomX = math.random(sizeX)
		randomY = math.random(sizeY) 
		while(mines[randomX..randomY] ~= null) do
			randomX = math.random(sizeX)
			randomY = math.random(sizeY) 
		end
		mines[randomX..randomY] = {x=randomX, y=randomY}
	end
end

function discover(event)
	if(isMine(event.target.i,event.target.j)) then
		showAllBombs()
		native.showAlert( "KABOOOOOOM!!", "You have lost!", { "Restart", "Quit" }, onGameComplete )
	else
		showSurroundingMines(event.target)	
	end
end

function drawBoard()
	local x=30
	local iGlobal = 0
	local jGlobal = 0
	for i = 0, display.contentWidth, 1 do
		y = 10
		if(x+50 <= display.contentWidth - 10) then
			for j = 0, display.contentHeight, 1 do
				if(y+50 <= display.contentHeight) then
					local rect = display.newRect(x, y, 50, 50)
					rect:setFillColor(120, 120, 120)
					rect:addEventListener( "tap", discover);
					rect.i = i
					rect.j = j
					table.insert(rectangles, rect)
					rectanglesHash[i..j] = rect
					y = y + 60	
					jGlobal = j
				end
	            
			end		 	
			x = x+60  
			iGlobal = i
		end	      
	end
	return (iGlobal+1), (jGlobal+1)
end

function restart(minePercentage)
	bigRect = display.newRect(
	    0, 0, display.contentWidth, display.contentHeight+10
	  )
    bigRect:setFillColor(0, 0, 0);
    
	minesPercentage = tonumber(minePercentage)

	mines = {}
	rectangles = {}
	rectanglesHash = {}
	discovered = 0
   
	xSize, ySize = drawBoard();
	initializeMineMatrix(xSize, ySize)
end