local Scene = require 'src.scenes.scene'
local ChocolateObject = require 'src.objects.chocolate-object'
local ChocolateData = require 'src.core.chocolate-data'
local GameState = require 'src.core.game-state'
local ObjectGroup = require 'src.objects.object-group'
local AI = require 'src.core.ai'

---@class GameScene : Scene
local GameScene = Class('Scene', Scene)

function GameScene:initialize(mode)
  Scene.initialize(self)

  self.onStart = Event()
  self.started = false
  self.ended = false

  self.state = GameState()
  self.chocolateObjects = ObjectGroup()
  local co = ChocolateObject(0, 0, self.state.chocolates[1], self.state)
  self.chocolateObjects:add(co)
  self.objects:add(self.chocolateObjects)

  self.camera:setPosition(co:getCenterPosition())

  self.bg = assets.images.bg ---@type Image
  self.bg:setWrap("repeat", "repeat")
  self.bgQuad = love.graphics.newQuad(0, 0, 512, 512, 32, 32)

  local cx, cy = self.camera.x, self.camera.y
  local cw, ch = self.camera.width, self.camera.height

  self.mode = mode
  if self.mode == '2p' then
  elseif self.mode == 'bot' then
    self.ai = AI(5)
    self.aiPlayer = 2
    self.state.onCut:add(function(chocolate, orientation, p, d1, d2)
      if self.state.turn ~= self.aiPlayer then
        self:requestAIMove()
      end
    end)
  end

  self.state.onCut:add(function()
    self.timer:after(0.1, function()
      if self.state:getWinner() then self:onEnded() end
    end)
  end)

  local GameStat = require 'src.objects.stat'
  local stat1 = GameStat(cx - cw/2, cy - ch/2, self.state, 1)
  local stat2 = GameStat(cx + cw/2 - GameStat.width, cy - ch/2, self.state, 2)

  self.stats = ObjectGroup()
  self.stats:add(stat1)
  self.stats:add(stat2)

  if self.mode == 'bot' then
    self.playerSelectButtons = ObjectGroup()
    local Text = require 'src.objects.text'
    local p1 = Text(cx - 28, 88, "1P", true)
    local p2 = Text(cx + 12, 88, "2P", true)
    p1.onClick:add(function()
      self.aiPlayer = 2
      self.started = true
      self.onStart()
      self.playerSelectButtons.active = false
    end)
    p2.onClick:add(function()
      self.aiPlayer = 1
      self.started = true
      self.onStart()
      self.timer:after(0.3, function() self:requestAIMove() end)
      self.playerSelectButtons.active = false
    end)
    self.playerSelectButtons:add(p1)
    self.playerSelectButtons:add(p2)
    self.objects:add(self.playerSelectButtons)
  else
    self.timer:after(1.0, function()
      self.started = true
      self.onStart()
    end)
  end

  self.state.onCut:add(function()
    self.timer:after(0.1, function()
      if self.state:getWinner() then self:onEnded() end
    end)
  end)
end

function GameScene:reset()
  self:doTransition('out', function()
    scene = GameScene(self.mode)
    scene:doTransition('in')
  end)
end

function GameScene:requestAIMove()
  if self.state:getWinner() then return end
  self.timer:after(0.05, function()
    self.aiRequestedTime = self.time
    self.ai:run(self.state)
  end)
end

function GameScene:onEnded()
  self.ended = true
  local text = "?"
  local winner = self.state:getWinner()
  if self.mode == 'bot' then
    if self.aiPlayer == winner then
      text = "YOU LOSE"
    else
      text = "YOU WIN!"
    end
  elseif self.mode == '2p' then
    text = tostring(winner) .. "P WIN!"
  end

  local TextObject = require 'src.objects.text'
  local winText = TextObject(0, 0, text)
  winText:setCenterPosition(self.camera.x, -20)
  self.objects:add(winText)
end

function GameScene:update(dt)
  Scene.update(self, dt)

  if self.ai then
    if self.ai:getCount() == 1 then
      local idx, orientation, p = unpack(self.ai:getResult())
      local sleepTime = math.max(1.0 - (self.time - self.aiRequestedTime), 0)
      self.timer:after(sleepTime, function()
        self.state:cut(self.state.chocolates[idx], orientation, p)
      end)
    end
  end

  if input:isPressed('mouse2') then
  end

  if input:isPressed('mouse3') then
    self:reset()
  end
end

function GameScene:draw()
  local g = love.graphics

  self.camera:clear(0.2, 0.2, 0.2)
  self.camera:render(function()
    self.bgQuad:setViewport(10*self.time, 10*self.time, 512, 512)
    g.draw(self.bg, self.bgQuad, -256, -256)
    local drawObjects = function(x, y)
      g.push()
      g.translate(x, y)
      self.objects:draw()
      g.pop()
    end
    self.stats:draw()
    g.setShader(assets.shaders.shadow)
    drawObjects(2, 2)
    g.setShader()
    drawObjects(0, 0)
  end)

  self.camera:render(function()
    self:drawTransition()
  end, true)

  self.camera:draw()
end

return GameScene
