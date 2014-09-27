local tileTypes = {
    WALL_TILE = '#',
    POWER_TILE = 'x',
    START_TILE = '1',
    NORMAL_TILE = ' '
}

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


function createMap(tiles, maxWidth, startPosition, tileWidth, tileHeight, wallTileImage, powerTileImage, dotImage)

    return {
        width = maxWidth,
        height = #tiles,
        tiles = tiles,

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
            return result
        end,

        draw = function(self)
            for y, line in ipairs(self.tiles) do
                for x, tile in ipairs(line) do
                    if tile.type == tileTypes.POWER_TILE then
                        if tile.hasDot then
                            love.graphics.draw(powerTileImage, (x - 1) * tileWidth, (y - 1) * tileHeight)
                        end
                    elseif tile.type == tileTypes.WALL_TILE then
                        love.graphics.draw(wallTileImage, (x - 1) * tileWidth, (y - 1) * tileHeight)
                    elseif tile.type == tileTypes.NORMAL_TILE and tile.hasDot then
                        love.graphics.draw(dotImage, (x - 1) * tileWidth, (y - 1) * tileHeight)
                    end
                end
            end
        end

    }
end

--Loads a map text file into an object
function loadMap(mapPath, wallTileImage, powerTileImage, dotImage)
    local tileWidth = wallTileImage:getWidth()
    local tileHeight = wallTileImage:getHeight()
    local startPosition = nil
    local maxWidth = 0
    local lines = {}
    local tiles = {}

    --Parse the lines
    local mapLines = loadLines(mapPath)
    for linePosition, line in ipairs(mapLines) do
        local chars = stringExplode(line)
        local tileLine = {}

        maxWidth = math.max(maxWidth, #chars)

        --Check for special tiles
        for charPosition, char in ipairs(chars) do
            local tile = loadTile(char, charPosition - 1, linePosition - 1)
            if tile.type == tileTypes.START_TILE then
                tile.type = tileTypes.NORMAL_TILE
                startPosition = {x = tile.x, y = tile.y}
            end

            table.insert(tileLine, tile)
        end

        table.insert(tiles, tileLine)
    end

    return createMap(tiles, maxWidth, startPosition, tileWidth, tileHeight, wallTileImage, powerTileImage, dotImage)
end

function loadTile(char, x, y, lines)
    tile = {
        x = x,
        y = y,
        type = char
    }


    if char == tileTypes.NORMAL_TILE or char == tileTypes.POWER_TILE then
        tile.hasDot = true
    end

    return tile

end

return {
    load = loadMap,
    tileTypes = tileTypes
}
