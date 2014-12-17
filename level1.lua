-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start()
--physics.setDrawMode("hybrid")	
-- include Corona's "widget" library
local widget = require "widget"

--------------------------------------------

-- forward declarations and other locals
local _W, _H = display.contentWidth, display.contentHeight
local background
local oneJump --Button that makes character jump once
local twoJump --Button that makes character jump twice
local restart --Button that restarts game
local player --The character/player
local chaser --The thing that chases the character
local chaserSpeed = 7 --The chasers speed can be changed
local caught = false --Keeps track if chaser caught player
local gameOverText
local column1
local column2
local column3
local column4
local column5
local column6
local column7
local chooseGap = math.random(1,2) --Chooses wether the gap will be short or long
local score = 0
local scoreText
local gaps = {100,160} --The amount of space between each column
local isClickable = true --Allows click of buttons
local chooseColumn = math.random(1,2) --Chooses a column graphic
local columns = { --holds all the different images of columns
	"images/column.png",
	"images/column2.png",
	"images/column3.png",
	"images/column4.png",
	"images/column5.png",
	"images/column6.png",
	"images/column7.png",
	"images/column8.png",
}
local chosen = columns[chooseColumn] --Randomly chosen column to use for the image of each column

--Functions for the buttons
function endGame( event )
	if chaser.x > player.x-30 then
		print( "IT WORKS!!!!" )
		player.isFixedRotation = false
		player:applyLinearImpulse( 100, -100, player.x, player.y )
	end
end

function chaserTimer( event )
	if score == 10 then
		chaserSpeed = 8
		print("Chaser Speed: "..chaserSpeed)
	elseif score == 30 then
		chaserSpeed = 9
		print("Chaser Speed: "..chaserSpeed)
	elseif score == 50 then
		chaserSpeed = 10
		print("Chaser Speed: "..chaserSpeed)
	end
	chaser.x = chaser.x + chaserSpeed
end

function startPhysics( event )
	physics.start( )
end

function makeClickable( event )
	if event.phase == 'ended' then
		isClickable = true
	end
end

--Jump small gap length
function oneTouch(event)
	if event.phase == 'ended' then
		if isClickable == true then
			isClickable = false
			score = score + 1
			scoreText.text = score
			physics.pause( )
			transition.to( player, {time=100, y=player.y-25, onComplete=startPhysics  } )
			transition.to( column1, {time = 200, x = column1.x - 100})
			transition.to( column2, {time = 200, x = column2.x - 100})
			transition.to( column3, {time = 200, x = column3.x - 100})
			transition.to( column4, {time = 200, x = column4.x - 100})
			transition.to( column5, {time = 200, x = column5.x - 100})
			transition.to( column6, {time = 200, x = column6.x - 100})
			transition.to( column7, {time = 200, x = column7.x - 100})
			transition.to( chaser, {time = 200, x = chaser.x - 100})
			--[[function makeClickable( )
				isClickable = true
			end
			--timer.performWithDelay( 500, makeClickable ,1 )']]--'
		end
	end
end

--Jump big gap length
function twoTouch( event )
	if event.phase == 'ended' then
		if isClickable == true then
			isClickable = false
			score = score + 1
			scoreText.text = score
			physics.pause( )
			transition.to( player, {time=100, y=player.y-25, onComplete=startPhysics  } )
			transition.to( column1, {time = 200, x = column1.x - 160})
			transition.to( column2, {time = 200, x = column2.x - 160})
			transition.to( column3, {time = 200, x = column3.x - 160})
			transition.to( column4, {time = 200, x = column4.x - 160})
			transition.to( column5, {time = 200, x = column5.x - 160})
			transition.to( column6, {time = 200, x = column6.x - 160})
			transition.to( column7, {time = 200, x = column7.x - 160})
			transition.to( chaser, {time = 200, x = chaser.x - 160})
			--[[function makeClickable( )
				isClickable = true
			end
			--timer.performWithDelay( 500, makeClickable ,1 )
			]]--
		end
	end
end

function restartTouch( event )
	composer.gotoScene( "restart", "fade", 500 )
end

--Move the columns when they get off screen
--Also end game if player falls and speeds up the chaser
function moveColumn( event )
	if column1.x < 0 then
		chooseGap = math.random(1,2)
		column1.x = column7.x + gaps[chooseGap]
	end
	if column2.x < 0 then
		chooseGap = math.random(1,2)
		column2.x = column1.x + gaps[chooseGap]
	end
	if column3.x < 0 then
		chooseGap = math.random(1,2)
		column3.x = column2.x + gaps[chooseGap]
	end
	if column4.x < 0 then
		chooseGap = math.random(1,2)
		column4.x = column3.x + gaps[chooseGap]
	end
	if column5.x < 0 then
		chooseGap = math.random(1,2)
		column5.x = column4.x + gaps[chooseGap]
	end
	if column6.x < 0 then
		chooseGap = math.random(1,2)
		column6.x = column5.x + gaps[chooseGap]
	end
	if column7.x < 0 then
		chooseGap = math.random(1,2)
		column7.x = column6.x + gaps[chooseGap]
	end
	if player.y > _H/2+20 then
		player.isFixedRotation = false
		gameOverText.alpha = 1	
		restart.alpha = 1	
		isClickable = false
	end
end


function scene:create( event )

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	local sceneGroup = self.view

	--background = display.newRect( 0, 0, _W, _H )
	background = display.newImageRect( "images/background.png", _W, _H )
	background.x = _W/2
	background.y = _H/2
	--background:setFillColor( 9/255, 132/255, 255/255 )

	scoreText = display.newText( score, 0,0, "04B_19", 70 )
	scoreText.x = _W/2
	scoreText.y = 70
	scoreText:setFillColor( 53/255,53/255,38/255 )

	gameOverText = display.newText( "GAME OVER", _W/2, _H/2, native.systemFont, 50 )
	gameOverText.x = _W/2
	gameOverText.y = _H/2-100
	gameOverText.alpha = 0

	--player = display.newRect( 0, 0, 20, 40 )
	player = display.newImageRect( "images/chromie.png", 28, 41 )
	player.x = _W/2
	player.y = 240
	physics.addBody( player, "dynamic", {density=5, friction=1, bounce=.3 } )
	player.isFixedRotation = true
	player.collision = makeClickable

	chaser = display.newCircle( 0, 0, 10 )
	chaser.x = player.x - 200
	chaser.y = player.y+20
	physics.addBody( chaser, "static",{density=1, friction=1, bounce=1, radius=10, isSensor=true } )
	--chaser.collision = endGame

	column1 = display.newImageRect( chosen, 40, 300 )
	column1.x = player.x
	column1.y = player.y+200
	physics.addBody( column1, "static", {density=1, friction=1, bounce=0 } )

	chooseGap = math.random(1,2)
	column2 = display.newImageRect( chosen, 40, 300 )
	column2.x = column1.x + gaps[chooseGap]
	column2.y = column1.y
	physics.addBody( column2, "static", {density=1, friction=1, bounce=0 } )

	chooseGap = math.random(1,2)
	column3 = display.newImageRect( chosen, 40, 300 )
	column3.x = column2.x + gaps[chooseGap]
	column3.y = column2.y
	--column3:setFillColor( 0,1,0 )
	physics.addBody( column3, "static", {density=1, friction=1, bounce=0} )

	chooseGap = math.random(1,2)
	column4 = display.newImageRect( chosen, 40, 300 )
	column4.x = column3.x + gaps[chooseGap]
	column4.y = column3.y
	--column4:setFillColor( 0,1,0 )
	physics.addBody( column4, "static", {density=1, friction=1, bounce=0} )

	chooseGap = math.random(1,2)
	column5 = display.newImageRect( chosen, 40, 300 )
	column5.x = column4.x + gaps[chooseGap]
	column5.y = column4.y
	--column5:setFillColor( 0,1,0 )
	physics.addBody( column5, "static", {density=1, friction=1, bounce=0} )

	chooseGap = math.random(1,2)
	column6 = display.newImageRect( chosen, 40, 300 )
	column6.x = column5.x + gaps[chooseGap]
	column6.y = column5.y
	--column6:setFillColor( 0,1,0 )
	physics.addBody( column6, "static", {density=1, friction=1, bounce=0} )

	chooseGap = math.random(1,2)
	column7 = display.newImageRect( chosen, 40, 300 )
	column7.x = column6.x + gaps[chooseGap]
	column7.y = column6.y
	--column7:setFillColor( 0,1,0 )
	physics.addBody( column7, "static", {density=1, friction=1, bounce=0} )

	restart = widget.newButton{
		label="RESTART",
		font="04B_19",
		fontSize=30,
		labelColor = { default={255}, over={128} },
		defaultFile="images/defaultButton.png",
		overFile="images/overButton.png",
		width=154, height=60,
		onRelease = restartTouch -- event listener function
	}
	restart.x = _W/2
	restart.y = _H/2
	restart.alpha = 0

	oneJump = widget.newButton{
		--label="One",
		labelColor = { default={255}, over={128} },
		--defaultFile="button.png",
		--overFile="button-over.png",
		width=_W/2, height=_H,
		onRelease = oneTouch	-- event listener function
	}
	oneJump.x = _W/4
	oneJump.y = _H/2

	twoJump = widget.newButton{
		--label="Two",
		labelColor = { default={255}, over={128} },
		--defaultFile="button.png",
		--overFile="button-over.png",
		width=_W/2, height=_H,
		onRelease = twoTouch	-- event listener function
	}
	twoJump.x = _W*.75
	twoJump.y = _H/2

	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( scoreText )
	sceneGroup:insert( player )
	sceneGroup:insert( chaser )
	sceneGroup:insert( column1 )
	sceneGroup:insert( column2 )
	sceneGroup:insert( column3 )
	sceneGroup:insert( column4 )
	sceneGroup:insert( column5 )
	sceneGroup:insert( column6 )
	sceneGroup:insert( column7 )
	sceneGroup:insert( oneJump )
	sceneGroup:insert( twoJump )
	sceneGroup:insert( restart )
	sceneGroup:insert( gameOverText )

end


function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
		Runtime:addEventListener("enterFrame", moveColumn)
		Runtime:addEventListener("enterFrame", endGame)
		player:addEventListener( "collision", makeClickable )
		--chaser:addEventListener( "collision", endGame )
		timerChaser = timer.performWithDelay( 10, chaserTimer, -1 ) --Timer moves the chaser
	end
end

function scene:hide( event )
	local sceneGroup = self.view
	
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
		physics.stop()
		Runtime:removeEventListener("enterFrame", moveColumn)
		Runtime:removeEventListener("enterFrame", endGame)
		player:removeEventListener("collision", makeClickable)
		timer.cancel( timerChaser )
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
	
end

function scene:destroy( event )

	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	local sceneGroup = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene