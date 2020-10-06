GameLevel = Class{}

function GameLevel:init(entities, objects, tilemap)
    self.entities = entities
    self.objects = objects
    self.tilemap = tilemap
end

function GameLevel:clear()
    for i = #self.objects, 1, -1 do
        if not self.objects[i] then
            table.remove(self.objects, i)
        end
    end

    for i = #self.entities, 1, -1 do
        if not self.entities[i] then
            table.remove(self.entities, i)
        end
    end
end

function GameLevel:update(dt)
    self.tilemap:update(dt)

    for k, objects in pairs(self.objects) do
        objects:update(dt)
    end

    for k, entity in pairs(self.entities) do
        entities:update(dt)
    end
end

function GameLevel:render()
    self.tilemap:render()

    for k, objects in pairs(self.objects) do
        objects:render()
    end

    for k, entity in pairs(self.entities) do
        entities:render()
    end
end