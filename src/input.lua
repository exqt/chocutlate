local module = {}
module._pressed = {}
module._released = {}

--love event
function module:keypressed(key)
  self._pressed[key] = true
end

function module:mousepressed(x, y, btn)
  self._pressed['mouse' .. tostring(btn)] = true
end

function module:mousereleased(x, y, btn)
  self._released['mouse' .. tostring(btn)] = true
end

function module:update(dt)
end

--methods
function module:isPressed(key)
  return self._pressed[key]
end

function module:isReleased(key)
  return self._released[key]
end

function module:isDown(key)
  if key:sub(1, 5) == 'mouse' then
    return love.mouse.isDown(tonumber(key:sub(6)))
  else
    return love.keyboard.isDown(key)
  end
end

function module:clear()
  self._pressed = {}
  self._released = {}
end

return module
