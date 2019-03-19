function love.load ()
	love.window.setMode (800, 600)
	love.graphics.setNewFont(30)
	y_second=0
	velocity=2
	y_first=0
	HigthOfRectangle=90
	circleX=400
	circleY=300
	circleR=20
	circleVelocityX=2
	circleVelocityY=2
	multy=1
	isGameOver=false
end

function love.update (dt)
	if isGameOver then 
		return
	end
	if circleY>=600-circleR then
		circleVelocityY=circleVelocityY*-1
	end
	if circleY<=circleR then
		circleVelocityY=circleVelocityY*-1
	end

	if circleX<=20+circleR then
		if circleY+circleR < y_first+HigthOfRectangle and circleY+circleR > y_first then
			circleVelocityX=circleVelocityX*-1
		else
			isGameOver = true
		end
	end
	if circleX>=780-circleR then
		if circleY+circleR < y_second+HigthOfRectangle and circleY+circleR > y_second then
			circleVelocityX=circleVelocityX*-1
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
	if y_first<600-HigthOfRectangle then
		if love.keyboard.isDown ('down') then
			y_first=y_first+velocity*2*multy
		end
	end
	if y_second>0 then
		if love.keyboard.isDown ('w') then
			y_second=y_second-velocity*2*multy
		end
	end
	if y_second<600-HigthOfRectangle then
		if love.keyboard.isDown ('s') then
			y_second=y_second+velocity*2*multy
		end	
	end
end

function love.draw ()
	love.graphics.setBackgroundColor(242/255, 220/255, 224/255)
	love.graphics.setColor(133/255,100/255,123/255)
	love.graphics.rectangle("fill", 0, y_first, 20, HigthOfRectangle)
	love.graphics.rectangle("fill", 780, y_second, 20, HigthOfRectangle)
	love.graphics.setColor(133/255,100/255,123/255)
	love.graphics.circle("fill", circleX, circleY, circleR)
	if isGameOver
	 then if circleX>=700 
		then love.graphics.print("game over. right player lost", 200, 300)
		else love.graphics.print("game over. left player lost", 200, 300)
		end
	end
end