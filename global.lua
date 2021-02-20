input = require 'input'
Class = require 'lib.middleclass'
assets = require('lib.cargo').init({
  dir = 'assets',
  processors = {
    ['images/'] = function(image, filename)
      image:setFilter('nearest', 'nearest')
    end
  }
})

table.filterInplace = function(t, fn)
  local i = 1
  local j = 1
  while i <= #t do
    t[j] = t[i]
    if fn(t[i]) then j = j + 1 end
    i = i + 1
  end
  while j <= #t do t[#t] = nil end
end
