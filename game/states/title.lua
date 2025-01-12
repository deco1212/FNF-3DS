local TitleState = State:extend()

local PlayState = require "game.states.play"

function TitleState:enter()
	resetMusic()

	self.danceLeft = false
	self.confirmed = false

	self.gfDance = Sprite(512, 40)
	self.gfDance:setFrames(paths.getSparrowAtlas("menus/title/gfDanceTitle"))
	self.gfDance:addAnimByIndices("danceLeft", "gfDance", {
		30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
	}, 24, false)
	self.gfDance:addAnimByIndices("danceRight", "gfDance", {
		15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29
	}, 24, false)
	self:add(self.gfDance)

	self.logoBl = Sprite(-150, -100)
	self.logoBl:setFrames(paths.getSparrowAtlas("menus/title/logoBumpin"))
	self.logoBl:addAnimByPrefix("bump", "logo bumpin", 24, false)
	self.logoBl:play("bump")
	self.logoBl:updateHitbox()
	self:add(self.logoBl)

	self.titleText = Sprite(100, 576)
	self.titleText:setFrames(paths.getSparrowAtlas("menus/title/titleEnter"))
	self.titleText:addAnimByPrefix("idle", "Press Enter to Begin", 24)
	self.titleText:addAnimByPrefix("press", "ENTER PRESSED", 24)
	self.titleText:play("idle")
	self.titleText:updateHitbox()
	self:add(self.titleText)

	music:play()
end

function TitleState:update(dt)
	if not self.confirmed and controls:pressed("accept") then
		self.confirmed = true
		self.titleText:play("press")
		paths.playSound("confirmMenu")
		Timer.after(1.5, function()
			music:stop()
			switchState(PlayState())
		end)
	end
	TitleState.super.update(self, dt)
end

function TitleState:beat(n)
	self.logoBl:play("bump", true)

	self.danceLeft = not self.danceLeft
	if self.danceLeft then
		self.gfDance:play("danceLeft")
	else
		self.gfDance:play("danceRight")
	end
	TitleState.super.beat(self, n)
end

return TitleState
