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
