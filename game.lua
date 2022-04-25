PLAYER_COLOR       = {133/255,100/255,123/255, 1}
BALL_COLOR         = PLAYER_COLOR
SCORE_COLOR        = PLAYER_COLOR
DEADZONE_COLOR     = {0, 0.8, 0}
BACKGROUND_COLOR   = {242/255, 220/255, 224/255}

PLAYER_HEIGHT = 90
PLAYER_WIDTH = 20
PLAYER_VELOCITY = 8
DEADZONE_WIDTH = 10
PLAYER_X_OFFSET = DEADZONE_WIDTH + 5

local game = {}
local utils = require('utils')

function game.reset_ball()
    game.ball = {}
    game.ball.x = window_width/2
    game.ball.y = window_height/2
    -- TODO: random direction
    game.ball.vx = 1
    game.ball.vy = 1
    game.ball.radius = 20
end

local
function player(x)
    return
    {
        x = x,
        y = 0,
        width = PLAYER_WIDTH,
        height = PLAYER_HEIGHT,
        score = 0
    }
end

function game.reset_players()
    game.players = {}
    game.players.left  = player(PLAYER_X_OFFSET)
    game.players.right = player(window_width - PLAYER_WIDTH - PLAYER_X_OFFSET)
end

function game.reset_players_position()
    game.players.left.x = PLAYER_X_OFFSET
    game.players.right.x = window_width - PLAYER_WIDTH - PLAYER_X_OFFSET
end

function game.init_deadzones()
    game.deadzones = {}
    game.deadzones.left = {x = 0, y = 0, width = DEADZONE_WIDTH, height = window_height}
    game.deadzones.right = {x = window_width - DEADZONE_WIDTH, y = 0, width = DEADZONE_WIDTH, height = window_height}
end

function game.init()
    game.reset_ball()
    game.reset_players()
    game.init_deadzones()
end

function game.draw_players()
    love.graphics.setColor(unpack(PLAYER_COLOR))
    love.graphics.rectangle("fill", game.players.left.x, game.players.left.y, PLAYER_WIDTH, PLAYER_HEIGHT)
    love.graphics.rectangle("fill", game.players.right.x, game.players.right.y, PLAYER_WIDTH, PLAYER_HEIGHT)
end

function game.draw_ball()
    love.graphics.setColor(unpack(BALL_COLOR))
    love.graphics.circle("fill", game.ball.x, game.ball.y, game.ball.radius)
end

function game.draw_deadzones()
    love.graphics.setColor(unpack(DEADZONE_COLOR))
    love.graphics.rectangle("fill", 0, 0, DEADZONE_WIDTH, window_height)
    love.graphics.rectangle("fill", window_width - DEADZONE_WIDTH, 0, DEADZONE_WIDTH, window_height)
end

function game.draw_score()
    love.graphics.setColor(unpack(SCORE_COLOR))
    local offset = 150
    score = {}
    score.width = 50
    score.height = 50
    score.y = 50

    -- love.graphics.rectangle("fill", window_width * 0.5 - score.width - offset, score.y,
    --                                 score.width, score.height)

    -- love.graphics.rectangle("fill", window_width * 0.5 + offset, score.y,
    --                                 score.width, score.height)

	local font = love.graphics.newFont(60)
    love.graphics.print(game.players.left.score,
                        font,
                        window_width * 0.5 - score.width - offset,
                        score.y)

    love.graphics.print(game.players.right.score,
                        font,
                        window_width * 0.5 + offset,
                        score.y)
end

function game.draw_middle_line()
    love.graphics.setColor(unpack(PLAYER_COLOR))
    local line_width = 6
    love.graphics.rectangle("fill", (window_width - line_width) * 0.5, 0, line_width, window_height)
end

function game.update_players()
    if love.keyboard.isDown ('w') then
        game.players.left.y = game.players.left.y - PLAYER_VELOCITY
    end
    if love.keyboard.isDown ('s') then
        game.players.left.y = game.players.left.y + PLAYER_VELOCITY
    end
    game.players.left.y = utils.clamp(0, game.players.left.y, window_height - game.players.left.height)

    if love.keyboard.isDown ('up') then
        game.players.right.y = game.players.right.y - PLAYER_VELOCITY
    end
    if love.keyboard.isDown ('down') then
        game.players.right.y = game.players.right.y + PLAYER_VELOCITY
    end
    game.players.right.y = utils.clamp(0, game.players.right.y, window_height - game.players.right.height)
end

local
function ball_rect_intersect(ball, rect)

    local ball_distance = {}
    local rect_center = {x = rect.x + rect.width/2,
                         y = rect.y + rect.height/2}
    ball_distance.x = math.abs(ball.x - rect_center.x)
    ball_distance.y = math.abs(ball.y - rect_center.y)

    if (ball_distance.x > (rect.width/2 + ball.radius)) then
        return false
    end

    if (ball_distance.y > (rect.height/2 + ball.radius)) then
        return false
    end

    if (ball_distance.x <= (rect.width/2)) then
        return true
    end

    if (ball_distance.y <= (rect.height/2)) then
        return true
    end

    local corner_distance_sq = (ball_distance.x - rect.width/2)^2 +
                               (ball_distance.y - rect.height/2)^2

    return (corner_distance_sq <= (ball.radius^2))
end

function game.update_ball()
    -- reflecting ball when it hits floor or ceiling
    -- TODO: clamp ball.y so is does not overflow or underflow
    if game.ball.y >= window_height-game.ball.radius then
        game.ball.vy = game.ball.vy*-1
    end
    if game.ball.y <= game.ball.radius then
        game.ball.vy = game.ball.vy*-1
    end

    -- TODO: collision can occur multiple times if we have corner collision - need fix
    if ball_rect_intersect(game.ball, game.players.left) or
       ball_rect_intersect(game.ball, game.players.right) then
        game.ball.vx = game.ball.vx*-1.2
    end

    if ball_rect_intersect(game.ball, game.deadzones.left) then
        game.players.right.score = game.players.right.score + 1
        game.reset_ball()
        game.reset_players_position()
    elseif ball_rect_intersect(game.ball, game.deadzones.right) then
        game.players.left.score = game.players.left.score + 1
        game.reset_ball()
        game.reset_players_position()
    end

    game.ball.y = game.ball.y + game.ball.vy
    game.ball.x = game.ball.x + game.ball.vx

end

game.init()
game.current_state = "Main Menu"
return game
