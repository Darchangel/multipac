local WALL_TILE = '#'
local POWER_TILE = 'x'
local START_TILE = '1'

--Load all lines from a file
function loadLines(filePath)
    local file = io.open(filePath, "r")
    local lines = {}
    local thisLine = file:read("*line")

    while thisLine ~= nil and thisLine ~= "" do
        table.insert(lines, thisLine)
        thisLine = file:read("*line")
    end

    file:close()
    return lines
end

--Explode a string into a list of characters
function stringExplode(string)
    local chars = {}
    for char in string:gmatch(".") do --Loop over all chars
        table.insert(chars, char)
    end

    return chars
end

function index2D(x, y)
    return tostring(x)..":"..tostring(y)
end


function createMap(lines, maxWidth, powerTiles, startPosition, tileWidth, tileHeight, wallTileImage, powerTileImage)

    return {
        width = maxWidth,
        height = #lines,
        powerTiles = powerTiles, --TODO: Implement normal dots

        getDimensions = function(self)
            return {
                width = self.width * tileWidth,
                height = self.height * tileHeight
            }
        end,


        getStartCoordinates = function(self)
            local result
            if startPosition ~= nil then
                result = {x = startPosition.x * tileWidth, y = startPosition.y * tileHeight}
            else
                result = {x = math.random(self.width) * tileWidth, y = math.random(self.height) * tileHeight}
            end
        end,

        draw = function(self)
            for y, line in ipairs(lines) do
                for x, tile in ipairs(line) do
                    if tile == POWER_TILE then
                        if self.powerTiles[index2D(x - 1, y - 1)] then
                            love.graphics.draw(powerTileImage, (x - 1) * tileWidth, (y - 1) * tileHeight)
                        end
                    elseif tile == WALL_TILE then
                        love.graphics.draw(wallTileImage, (x - 1) * tileWidth, (y - 1) * tileHeight)
                    end
                end
            end
        end

    }
end

--Loads a map text file into an object
function loadMap(mapPath, wallTileImage, powerTileImage)
    local tileWidth = wallTileImage:getWidth()
    local tileHeight = wallTileImage:getHeight()
    local startPosition = nil
    local maxWidth = 0
    local powerTiles = {}
    local lines = {}

    --Parse the lines
    local mapLines = loadLines(mapPath)
    for linePosition, line in ipairs(mapLines) do
        local chars = stringExplode(line)
        table.insert(lines, chars)

        maxWidth = math.max(maxWidth, #chars)

        --Check for special tiles
        for charPosition, char in ipairs(chars) do
            if char == POWER_TILE then
                powerTiles[index2D(charPosition - 1, linePosition - 1)] = true
            elseif char == START_TILE then
                startPosition = {x = charPosition - 1, y = linePosition - 1}
            end
        end
    end

    return createMap(lines, maxWidth, powerTiles, startPosition, tileWidth, tileHeight, wallTileImage, powerTileImage)
end

return {
    load = loadMap
}
