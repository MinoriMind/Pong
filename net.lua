PORT = 12345
ADDRESS = 'localhost'

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

local net = {read_until_empty = read_until_empty,
             address = ADDRESS, port = PORT}

return net



