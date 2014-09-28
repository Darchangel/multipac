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

function createMap(tiles, maxWidth, startPosition, tileWidth, tileHeight, wallTileImageDir, powerTileImage, dotImage)

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
                        love.graphics.draw(wallTileImageDir.."/"..tile.imageCode..".png", (x - 1) * tileWidth, (y - 1) * tileHeight)
                    elseif tile.type == tileTypes.NORMAL_TILE and tile.hasDot then
                        love.graphics.draw(dotImage, (x - 1) * tileWidth, (y - 1) * tileHeight)
                    end
                end
            end
        end

    }
end

--Loads a map text file into an object
function loadMap(mapPath, wallTileImageDir, powerTileImage, dotImage)

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

    return createMap(tiles, maxWidth, startPosition, tileWidth, tileHeight, wallTileImageDir, powerTileImage, dotImage)
end

function loadTile(char, x, y, lines)
    tile = {
        x = x,
        y = y,
        type = char
    }

    if char == tileTypes.NORMAL_TILE or char == tileTypes.POWER_TILE then
        tile.hasDot = true
    elseif char == tileTypes.WALL_TILE then
        tile.imageCode = checkSurroundings(y + 1, x + 1, lines)
    end

    return tile
end

function checkSurroundings(line, column, lines)
    local surroundings = ""
    local isCorner = false

    function boolToBinary(bool)
        local result
        if bool then
            result = "1"
        else
            result = "0"
        end

        return result
    end

    surroundings = surroundings..boolToBinary(line - 1 > 0 and lines[line-1][column] == tileTypes.WALL_TILE)
                               ..boolToBinary(line - 1 > 0 and column + 1 > #lines[line] and lines[line-1][column+1] == tileTypes.WALL_TILE)
                               ..boolToBinary(column + 1 > #lines[line] and lines[line][column+1] == tileTypes.WALL_TILE)
                               ..boolToBinary(line + 1 > #lines and column + 1 > #lines[line] and lines[line+1][column+1] == tileTypes.WALL_TILE)
                               ..boolToBinary(line + 1 > #lines and lines[line+1][column] == tileTypes.WALL_TILE)
                               ..boolToBinary(line + 1 > #lines and column - 1 > 0 and lines[line+1][column-1] == tileTypes.WALL_TILE)
                               ..boolToBinary(column - 1 > 0 and lines[line][column-1] == tileTypes.WALL_TILE)
                               ..boolToBinary(line - 1 > 0 and column - 1 > 0 and lines[line-1][column-1] == tileTypes.WALL_TILE)
               
    return surroundings
end


return {
    load = loadMap,
    tileTypes = tileTypes
}
