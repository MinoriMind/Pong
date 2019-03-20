function love.mousepressed (_, _, button, _)
	if button==1 and currentState=="menu" then 
		currentState = "game"
		circleVelocityX=2
		circleVelocityY=2
		circleX=windowWidth/2
		circleY=windowHigth/2
		y_second=0
		y_first=0
		isGameOver=false
	end
end
function love.touchpressed (_, x, y)
	if currentState=="menu" then 
		currentState = "game"
		circleVelocityX=2
		circleVelocityY=2
		circleX=windowWidth/2
		circleY=windowHigth/2
		y_second=0
		y_first=0
		isGameOver=false
	end
	if x<=windowWidth/2 then
	y_first = y - HigthOfRectangle/2
		if y<=HigthOfRectangle/2 then y_first=0
		end
		if y>=windowHigth-HigthOfRectangle/2 then y_first=windowHigth-HigthOfRectangle
		end
	else
	y_second = y - HigthOfRectangle/2
		if y<=HigthOfRectangle/2 then y_second=0
		end
		if y>=windowHigth-HigthOfRectangle/2 then y_second=windowHigth-HigthOfRectangle
		end
	end
end

function love.touchmoved (_, x, y)
	if x<=windowWidth/2 then
	y_first = y - HigthOfRectangle/2
		if y<=HigthOfRectangle/2 then y_first=0
		end
		if y>=windowHigth-HigthOfRectangle/2 then y_first=windowHigth-HigthOfRectangle
		end
	else
	y_second = y - HigthOfRectangle/2
		if y<=HigthOfRectangle/2 then y_second=0
		end
		if y>=windowHigth-HigthOfRectangle/2 then y_second=windowHigth-HigthOfRectangle
		end
	end
end

function love.load ()
	windowWidth, windowHigth = love.graphics.getDimensions()
	love.window.setMode (windowWidth, windowHigth)
	love.graphics.setNewFont(30)
	y_second=0
	velocity=4
	y_first=0
	HigthOfRectangle=90
	circleX=windowWidth/2
	circleY=windowHigth/2
	circleR=20
	circleVelocityX=2
	circleVelocityY=2
	multy=1
	isGameOver=false
	currentState = "menu"
end

function love.update (dt)
	if currentState == "menu" then
		return
	end
	if isGameOver then 
		return
	end
	if circleY>=windowHigth-circleR then
		circleVelocityY=circleVelocityY*-1
	end
	if circleY<=circleR then
		circleVelocityY=circleVelocityY*-1
	end

	if circleX<=20+circleR then
		if circleY+circleR < y_first+HigthOfRectangle and circleY+circleR > y_first then
			circleVelocityX=circleVelocityX*-1.2
		else
			isGameOver = true
		end
	end
	if circleX>=windowWidth-2*circleR then
		if circleY+circleR < y_second+HigthOfRectangle and circleY+circleR > y_second then
			circleVelocityX=circleVelocityX*-1.2	
		else
			isGameOver = true
		end
	end

	circleY=circleY+circleVelocityY*multy
	circleX=circleX+circleVelocityX*multy

	if y_first>0 then
		if love.keyboard.isDown ('up') then
			y_first=y_first-velocity*2*multy
		end	
	end
	if y_first<windowHigth-HigthOfRectangle then
		if love.keyboard.isDown ('down') then
			y_first=y_first+velocity*2*multy
		end
	end
	if y_second>0 then
		if love.keyboard.isDown ('w') then
			y_second=y_second-velocity*2*multy
		end
	end
	if y_second<windowHigth-HigthOfRectangle then
		if love.keyboard.isDown ('s') then
			y_second=y_second+velocity*2*multy
		end	
	end
end

function love.draw ()
if currentState == "menu" then
	love.graphics.setBackgroundColor(242/255, 200/255, 220/255)
	love.graphics.setColor(133/255,100/255,123/255)
	love.graphics.print("Start", windowWidth/2, windowHigth/2)
	if circleX>=windowWidth-100  then 
	 	love.graphics.print("Game over. Right player lost", windowWidth/3, windowHigth*5/6)
	end
	if circleX <= windowHigth-100 then
		love.graphics.print("Game over. Left player lost", windowWidth/3, windowHigth*5/6)
	end
else
	love.graphics.setBackgroundColor(242/255, 220/255, 224/255)
	love.graphics.setColor(133/255,100/255,123/255)
	love.graphics.rectangle("fill", 0, y_first, 20, HigthOfRectangle)
	love.graphics.rectangle("fill", windowWidth-20, y_second, 20, HigthOfRectangle)
	love.graphics.setColor(133/255,100/255,123/255)
	love.graphics.circle("fill", circleX, circleY, circleR)
	if isGameOver then 
		currentState = "menu"
		
	end
end
end