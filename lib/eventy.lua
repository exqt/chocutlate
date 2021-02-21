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
  t.removed = {}
  return t
end

function Event:add(a, b)
  local tag = EventTag.new()
  if type(a) == 'table' then
    table.insert(self.list, {tag = tag, obj = a, fn = b})
  else
    table.insert(self.list, {tag = tag, fn = a})
  end
  return tag
end

function Event:remove(tag)
  self.removed[tag] = true
end

function Event:invoke(...)
  local list = {}
  for i=1, #self.list do
    local act = self.list[i]
    if not self.removed[act.tag] then
      if act.obj then act.fn(act.obj, ...)
      else act.fn(...)
      end
    end
  end

  local filterInplace = function(t, fn)
    local i = 1
    local j = 1
    while i <= #t do
      t[j] = t[i]
      if fn(t[i]) then j = j + 1 end
      i = i + 1
    end
    while j <= #t do t[#t] = nil end
  end

  filterInplace(self.list, function(item) return not self.removed[item.tag] end)
  self.removed = {}
end

function Event:__call(...) self:invoke(...) end

local module = setmetatable({}, {__call = function(...) return Event.new(...) end}) ---@type EventyEvent
return module
