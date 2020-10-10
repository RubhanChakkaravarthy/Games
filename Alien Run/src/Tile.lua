Tile = Class{}

function Tile:init(def)
    self.x = def.x
    self.y = def.y
    self.id = def.id
    self.width = 16
    self.height = 16
    self.texture = def.texture
    self.topTexture = def.topTexture
    self.tileset = def.tileset
    self.topperset = def.topperset
    self.topper = def.topper
    self.collidable = def.collidable
    self.hurtable = def.hurtable
end

function Tile:render()

    love.graphics.draw(
        gTextures[self.texture], 
        gFrames[self.texture][self.tileset][self.id], 
        (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE
    )

    if self.topper then
        love.graphics.draw(
            gTextures[self.topTexture], 
            gFrames[self.topTexture][self.topperset][self.id], 
            (self.x - 1) * TILE_SIZE, (self.y - 1) * TILE_SIZE
        )
    end
end