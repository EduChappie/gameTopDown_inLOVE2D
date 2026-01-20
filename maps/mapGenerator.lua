mapGenerator = {}

local block = require("objects.blockGenerator")
local chest = require("objects.chests")
local mapa = require("maps.data.mapa01")

-- ================================
-- TILESET E DIMENSÕES
-- ================================
local tileset = love.graphics.newImage("assets/mapas/Dungeon_Tileset.png")
tileset:setFilter("nearest", "nearest")

local tileW = mapa.tilewidth
local tileH = mapa.tileheight
local mapW = mapa.width
local mapH = mapa.height

local tilesetW, tilesetH = tileset:getDimensions()
local tilesPerRow = tilesetW / tileW

-- ================================
-- CACHE DE QUADS
-- ================================
local quadCache = {}

-- ================================
-- LOAD
-- ================================
function mapGenerator:load()
    self.blocks = {}
    self.chests = {}

    -- ================================
    -- 1. CACHE DE QUADS
    -- ================================
    for _, layer in ipairs(mapa.layers) do
        if layer.type == "tilelayer" then
            for _, tileId in ipairs(layer.data) do
                if tileId ~= 0 and not quadCache[tileId] then
                    local tx = ((tileId - 1) % tilesPerRow) * tileW
                    local ty = math.floor((tileId - 1) / tilesPerRow) * tileH

                    quadCache[tileId] = love.graphics.newQuad(
                        tx, ty,
                        tileW, tileH,
                        tilesetW, tilesetH
                    )
                end
            end
        end
    end

    -- ================================
    -- 2. MATRIZES DE COLISÃO
    -- ================================
    local solid = {}
    local visited = {}

    for y = 0, mapH - 1 do
        solid[y] = {}
        visited[y] = {}
        for x = 0, mapW - 1 do
            solid[y][x] = false
            visited[y][x] = false
        end
    end

    -- ================================
    -- 3. MARCA PAREDES
    -- ================================
    for _, layer in ipairs(mapa.layers) do
        if layer.name == "paredes" then
            local index = 1
            for y = 0, mapH - 1 do
                for x = 0, mapW - 1 do
                    if layer.data[index] ~= 0 then
                        solid[y][x] = true
                    end
                    index = index + 1
                end
            end
        end
    end

    -- ================================
    -- 4. MERGE DE COLISÃO
    -- ================================
    for y = 0, mapH - 1 do
        for x = 0, mapW - 1 do
            if solid[y][x] and not visited[y][x] then

                local width = 1
                while x + width < mapW
                and solid[y][x + width]
                and not visited[y][x + width] do
                    width = width + 1
                end

                local height = 1
                local canExpand = true

                while canExpand and y + height < mapH do
                    for ix = 0, width - 1 do
                        if not solid[y + height][x + ix]
                        or visited[y + height][x + ix] then
                            canExpand = false
                            break
                        end
                    end
                    if canExpand then
                        height = height + 1
                    end
                end

                for iy = 0, height - 1 do
                    for ix = 0, width - 1 do
                        visited[y + iy][x + ix] = true
                    end
                end

                table.insert(
                    self.blocks,
                    block:new(
                        x * tileW,
                        y * tileH,
                        width * tileW,
                        height * tileH
                    )
                )
            end
        end
    end

    -- ================================
    -- 5. LEITURA DOS BAÚS (TILE LAYER)
    -- ================================
    -- a fazer!!!!
    
end

-- ================================
-- UPDATE
-- ================================
function mapGenerator:update(dt)
end

-- ================================
-- DRAW
-- ================================
function mapGenerator:draw()
    for _, layer in ipairs(mapa.layers) do
        if layer.type == "tilelayer" and layer.visible then
            local index = 1
            for y = 0, mapH - 1 do
                for x = 0, mapW - 1 do
                    local tileId = layer.data[index]
                    if tileId ~= 0 then
                        love.graphics.draw(
                            tileset,
                            quadCache[tileId],
                            x * tileW,
                            y * tileH
                        )
                    end
                    index = index + 1
                end
            end
        end
    end

    -- DEBUG BAÚS - isso que deixo com o vermelho envolta
    --for _, c in ipairs(self.chests) do
        --c:draw()
    --end
end

-- ================================
-- API
-- ================================
function mapGenerator:getBlocks()
    return self.blocks
end

function mapGenerator:getChests()
    return self.chests
end

return mapGenerator
