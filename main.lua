--[[
function love.mousepressed (_, _, button, _)
	if button==1 and current_state=="menu" then
		current_state = "game"
		ball.vx=2
		ball.vy=2
		ball.x=window_width/2
		ball.y=window_height/2
		game.players.right.y=0
		game.players.left.y=0
		isGameOver=false
	end
end

function love.touchpressed (_, x, y)
	if current_state=="menu" then
		current_state = "game"
		ball.vx=2
		ball.vy=2
		ball.x=window_width/2
		ball.y=window_height/2
		game.players.right.y=0
		game.players.left.y=0
		isGameOver=false
	end
	if x<=window_width/2 then
	game.players.left.y = y - PLAYER_HEIGHT/2
		if y<=PLAYER_HEIGHT/2 then game.players.left.y=0
		end
		if y>=window_height-PLAYER_HEIGHT/2 then game.players.left.y=window_height-PLAYER_HEIGHT
		end
	else
	game.players.right.y = y - PLAYER_HEIGHT/2
		if y<=PLAYER_HEIGHT/2 then game.players.right.y=0
		end
		if y>=window_height-PLAYER_HEIGHT/2 then game.players.right.y=window_height-PLAYER_HEIGHT
		end
	end
end

function love.touchmoved (_, x, y)
	if x<=window_width/2 then
	game.players.left.y = y - PLAYER_HEIGHT/2
		if y<=PLAYER_HEIGHT/2 then game.players.left.y=0
		end
		if y>=window_height-PLAYER_HEIGHT/2 then game.players.left.y=window_height-PLAYER_HEIGHT
		end
	else
	game.players.right.y = y - PLAYER_HEIGHT/2
		if y<=PLAYER_HEIGHT/2 then game.players.right.y=0
		end
		if y>=window_height-PLAYER_HEIGHT/2 then game.players.right.y=window_height-PLAYER_HEIGHT
		end
	end
end
]]--

BUTTON_HEIGHT = 64
local
function button(text, fun)
    return
    {
        text = text,
        fun = fun,

        now = false,
        last = false
    }
end

local main_menu_buttons = {}
local font = nil
local game = {}

function love.load ()
	window_width, window_height = love.graphics.getDimensions()
	love.window.setMode(window_width, window_height)
	love.window.setTitle("Pong client")
	font = love.graphics.newFont(30)

    game = require('game')

    table.insert(main_menu_buttons, button(
            "Local game",
            function()
                game.current_state = "Local Game"
                game.init()
            end))

    table.insert(main_menu_buttons, button(
            "Online game",
            function()
                love.event.quit(0)
            end))

    table.insert(main_menu_buttons, button(
            "Exit",
            function()
                love.event.quit(0)
            end))

end

function love.update (dt)
	if game.current_state == "Main Menu" then
		return
	end

    if game.current_state == "Local Game" then

        game.update_players()
        game.update_ball()

    end
end

-- offset from center
local
function draw_buttons(buttons, x_offset, y_offset, button_width)
    local ww = window_width
    local wh = love.graphics.getHeight()

    local margin = 16
    local cursor_y = 0

    local total_height = (BUTTON_HEIGHT + margin) * #buttons;
    for i, button in ipairs(buttons) do
        button.last = button.now

        button_x = 0.5 * (ww - button_width) + x_offset
        button_y = 0.5 * (wh - total_height) + y_offset + cursor_y

        local color = {0.5, 0.4, 0.5, 1}

        local mouse_x, mouse_y = love.mouse.getPosition()

        local hot = mouse_x > button_x and mouse_x < button_x + button_width and
                    mouse_y > button_y and mouse_y < button_y + BUTTON_HEIGHT

        if hot then
            color = {1, 0.8, 1, 1}
        end

        button.now = love.mouse.isDown(1)

        if hot and button.now and not button.last then
            button.fun()
        end

        love.graphics.setColor(unpack(color))
        love.graphics.rectangle(
            "fill",
            button_x,
            button_y,
            button_width,
            BUTTON_HEIGHT
        )

        local text_width = font:getWidth(button.text)
        local text_height = font:getHeight(button.text)

        love.graphics.setColor(0, 0, 0, 1)
        love.graphics.print(button.text,
                            font,
                            button_x + 0.5 * (button_width - text_width),
                            button_y + text_height * 0.5)

        cursor_y = cursor_y + BUTTON_HEIGHT + margin

    end
end

function love.draw ()
    local ww = love.graphics.getWidth()
    local wh = love.graphics.getHeight()

    love.graphics.setBackgroundColor(unpack(BACKGROUND_COLOR))
    if game.current_state == "Main Menu" then
        draw_buttons(main_menu_buttons, 0, 0, ww/3)
    else
        game.draw_players()
        game.draw_ball()
        game.draw_deadzones()
        game.draw_middle_line()
        game.draw_score()

    end
end
