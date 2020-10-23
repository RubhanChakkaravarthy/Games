StencilSystem = Class{}

function StencilSystem:init(def)
    self.stencils = {}

    if def then
        for k, drawableArgs in pairs(def) do
            self:addStencil(drawableArgs, k)
        end
    end
    self.numStencils = #self.stencils
end

function StencilSystem:addStencil(drawableArgs, id)
    if not id then
        table.insert(self.stencils, drawableArgs)
    else
        self.stencils[id] = drawableArgs
    end

    self.numStencils = #self.stencils
    return self.numStencils
end

function StencilSystem:removeStencil(id)
    table.remove(self.stencils, id)
    self.numStencils = #self.stencils
end

function StencilSystem:updateStencil(id, drawableArgs)
    if self.stencils[id] then
        self.stencils[id] = drawableArgs
    end
end

function StencilSystem:createStencilFunction()
    return function () 
        for k, drawableArgs in pairs(self.stencils) do
            love.graphics.rectangle(unpack(drawableArgs))
        end
    end
end