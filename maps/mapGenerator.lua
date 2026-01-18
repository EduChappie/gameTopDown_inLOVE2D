mapGenerator = {}

local Block = require("objects.blockGenerator")
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

    -- ================================
    -- 1. CACHE DE QUADS (UMA VEZ)
    -- em termos mais simples, ele faz a verificação da localização de cada bloco no inicio
    -- somente 1 vez, para depois depois ele só usufluir desses dados,
    -- dando uma boa folga no sitema
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
    -- 3. MARCA TILES SÓLIDOS
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
    -- 4. MERGE HORIZONTAL + VERTICAL
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
end

-- ================================
-- UPDATE
-- ================================
function mapGenerator:update(dt)
end

-- ================================
-- DRAW (MAPA + DEBUG)
-- ================================
function mapGenerator:draw()
    -- desenha layers visuais
    for _, layer in ipairs(mapa.layers) do
        if layer.type == "tilelayer"
        and layer.visible then

            local index = 1
            for y = 0, mapH - 1 do
                for x = 0, mapW - 1 do
                    local tileId = layer.data[index]

                    if tileId ~= 0 then
                        local quad = quadCache[tileId]

                        love.graphics.draw(
                            tileset,
                            quad,
                            x * tileW,
                            y * tileH
                        )
                    end

                    index = index + 1
                end
            end
        end
    end

    -- DEBUG: colisão
    --for _, b in ipairs(self.blocks) do
        --b:draw()
    --end
end

-- ================================
-- API
-- ================================
function mapGenerator:getBlocks()
    return self.blocks
end

return mapGenerator
