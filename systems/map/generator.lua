mapGenerator = {}

local block = require("entities.block")
local chest = require("entities.chests")

local mapa = require("data.mapas.mapa01_withEnemie")

local enemie = require("entities.enemies.enemies")

-- ================================
-- TILESET E DIMENSÕES
-- ================================
local tileset = love.graphics.newImage("assets/image/tiles/Dungeon_Tileset.png")
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
    self.enemies = {}

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
    -- essa parte do cache é mais complexa, mas basicamente ele está
    -- fazendo uns cálculos para saber qual bloco exato vai ser renderizador
    -- na posição dele, pois ele ta verificando o id pra descorbrir quem 
    -- ele vai por vai naquela posição e mais importante
    -- ele ta tentando descobrir qual id é o qué, pra na hora do draw ele
    -- renderizar o sprite correto com base na imagem que eu mandei 'tileset'
    -- ================================
    -- CACHE DE QUADS PARA OBJECTGROUP (BAÚS)
    -- ================================
    for _, layer in ipairs(mapa.layers) do
        if layer.type == "objectgroup" then
            for _, obj in ipairs(layer.objects) do
                if obj.gid ~= nil and not quadCache[obj.gid] then

                    local tx = ((obj.gid - 1) % tilesPerRow) * tileW
                    local ty = math.floor((obj.gid - 1) / tilesPerRow) * tileH

                    quadCache[obj.gid] = love.graphics.newQuad(
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
    for _, layer in ipairs(mapa.layers) do
        if layer.name == "baú" then

            for _, bau in ipairs(layer.objects) do
                -- loop para instanciar cada baú existente 
                -- no mapa, com seus repectivos dados e
                -- mandar para um object que eu possa printar
                -- depois, quase o mesmo que acontece com o block
                -- só que mais simples graças a Deus
                table.insert(
                    self.chests,
                    chest:new(
                        bau.gid,
                        bau.x, 
                        bau.y - bau.height, -- não entendi,
                        bau.width,
                        bau.height,
                        bau.properties.action,
                        bau.properties.raio,
                        bau.properties.item
                    )
                )

            end

        end
    end

    -- ================================
    -- 6. LEITURA DOS INIMIGOS (TILE LAYER)
    -- ================================
    for _, layer in ipairs(mapa.layers) do
        if layer.name == "inimigos" then

            for _, n in ipairs(layer.objects) do
                dados = require("data.enemies.".. n.name)
                -- requisitando os dados especifico do inimigo que 
                -- que existe dentro desse determinado mundo.
                table.insert(
                    self.enemies,
                    enemie:new(
                        n.id,
                        n.x,
                        n.y,
                        dados
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

    -- update de animação para todos os inimigos
    for _, ene in ipairs(self.enemies) do
        ene:update(dt, player, block)
    end
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

    -- renderização dos baús
    for _, c in ipairs(self.chests) do
        if c.visible then
            -- somente se o baú tiver a propriedade de estar visível
            -- ele será mostrado, caso contrário não
            local quad = quadCache[c.gid] -- quadchace já verificou a posição de tudo
            if quad then -- para mim

                love.graphics.draw(
                    tileset,
                    quad,
                    c.x-1,
                    c.y-5
                )
            end
        end
    end

    -- DEBUG BAÚS - isso que deixo com o vermelho envolta
    --for _, c in ipairs(self.chests) do
        --c:draw()
    --end


    -- renderização dos inimigos
    for _, n in ipairs(self.enemies) do
        -- não precisa cetar invisible o próprio boneco verifica isso
        n:draw()
    end
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

function mapGenerator:getEnemies()
    return self.enemies
end

return mapGenerator
