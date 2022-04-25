PORT = 12345
local socket = require('socket')
local listening_socket = socket.tcp4()
if listening_socket:bind('*', PORT) == 1 then
    print("Success")
else
    print("Error during bind")
end
if listening_socket:listen(15) == 1 then
    print("Success")
else
    print("Error during listen")
end

local
function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end

local
function read_until_empty(socket)
    local last_response = nil
    local response, err = socket:receive("*l")

    while response do
        last_response = response
        response, err = socket:receive("*l")
    end

    return last_response, err
end

local game = {}
function love.load ()
	window_width, window_height = love.graphics.getDimensions()
    server_state = "Waiting Players"
	love.window.setMode(window_width, window_height)
	love.window.setTitle("Pong server")
	font = love.graphics.newFont(30)

    game = require('game')
end

function love.update (dt)
	if server_state == "Waiting Players" then
        print("Waiting for accept")
        left_socket = listening_socket:accept()
        print("First player connected")
        right_socket = listening_socket:accept()
        print("Second player connected ")
        left_socket:settimeout(0)
        right_socket:settimeout(0)

        left_socket:send("start\n")
        right_socket:send("start\n")
        server_state = "Game"
        return
    end

    if server_state == "Game" then
        local game_state
        local left_response, err = read_until_empty(left_socket)

        if left_response then
            command = string.sub(left_response, -1)
            if command == 'w' then
                game.players.left.y = game.players.left.y - PLAYER_VELOCITY
            end
            if command ==  's' then
                game.players.left.y = game.players.left.y + PLAYER_VELOCITY
            end
            game.players.left.y = clamp(0, game.players.left.y, window_height - PLAYER_HEIGHT)
        end

        local right_response, err = read_until_empty(right_socket)

        if right_response then
            command = string.sub(right_response, -1)
            if command == 'w' then
                game.players.right.y = game.players.right.y - PLAYER_VELOCITY
            end
            if command ==  's' then
                game.players.right.y = game.players.right.y + PLAYER_VELOCITY
            end
            game.players.right.y = clamp(0, game.players.right.y, window_height - PLAYER_HEIGHT)
        end

        game.update_ball()

        game_state = 'b' .. ':' .. game.ball.x .. ':' .. game.ball.y .. ':' .. game.ball.vx .. ':' .. game.ball.vy
        game_state = game_state .. '=l' .. ':' .. game.players.left.score .. ':' .. game.players.left.y
        game_state = game_state .. '=r' .. ':' .. game.players.right.score .. ':' .. game.players.right.y .. '\n'
        print(game_state)
        left_socket:send(game_state)
        right_socket:send(game_state)

    end
end


function love.draw ()
    love.graphics.setBackgroundColor(unpack(BACKGROUND_COLOR))
    if server_state == "Game" then
        game.draw_players()
        game.draw_ball()
        game.draw_deadzones()
        game.draw_middle_line()
        game.draw_score()
    end
end


