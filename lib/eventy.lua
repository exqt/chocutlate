-- Eventy - small event library like Unity Event

---@class EventyTag
local EventTag = {}
EventTag.__index = EventTag

function EventTag.new()
  local t = setmetatable({}, EventTag)
  return t
end

---@class EventyEvent
local Event = {}
Event.__index = Event

function Event.new()
  local t = setmetatable({}, Event)
  t.list = {}
  return t
end

function Event:add(a, b)
  local tag = EventTag.new()
  if type(a) == 'table' then
    self.list[tag] = {a, b}
  else
    self.list[tag] = a
  end
  return tag
end

function Event:remove(tag)
  self.list[tag] = nil
end

function Event:invoke(...)
  for tag, f in pairs(self.list) do
    if type(f) == 'table' then f[2](f[1], ...)
    else f(...)
    end
  end
end

function Event:__call(...) self:invoke(...) end

local module = setmetatable({}, {__call = function(...) return Event.new(...) end}) ---@type EventyEvent
return module
