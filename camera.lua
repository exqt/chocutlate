---@class Camera
local Camera = Class('Camera')

function Camera:initialize(scene, x, y, w, h, scale)
  self.scene = scene
  self.x, self.y = x, y
  self.width, self.height = w, h
  self.scale = scale
  self.screen = love.graphics.newCanvas(w, h)
  self.screen:setFilter('nearest', 'nearest')
end

function Camera:setPosition(x, y)
  self.x, self.y = x, y
end

function Camera:getPosition()
  return self.x, self.y
end

function Camera:moveBy(dx, dy)
  self.x, self.y = self.x + dx, self.y + dy
end

function Camera:convertScreenToScene(x, y)
  return (x/self.scale - self.width /2) + self.x,
         (y/self.scale - self.height/2) + self.y
end

function Camera:convertSceneToScreen(x, y)
  return self.scale*((x - self.x) + self.width/2),
         self.scale*((y - self.y) + self.height/2)
end

function Camera:update(dt)
end

--draw
function Camera:clear(r, g, b, a)
  self.screen:renderTo(function()
    love.graphics.clear(r, g, b, a)
  end)
end

function Camera:render(fn, ui)
  local g = love.graphics
  g.push()
  if not ui then
    g.origin()
    g.translate(self.width/2, self.height/2)
    g.translate(-self.x, -self.y)
  end
  self.screen:renderTo(fn)
  g.pop()
end

function Camera:draw()
  love.graphics.draw(self.screen, 0, 0, 0, self.scale, self.scale)
end

return Camera
