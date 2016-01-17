--------------------------------------------------
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local function calcBestFit (w, h, maxW, maxH)
	local scale = 1

	while w * scale <= maxW and h * scale <= maxH do 
		scale = scale + 1
	end

	scale = scale - 1
	scale = scale < 1 and 1 or scale

	return scale
end

--------------------------------------------------
local c = {}

--------------------------------------------------
local count = 0
function c:update ()

	local windowW, windowH = dio.drawing.getWindowSize ()
	self.scale = calcBestFit (self.w, self.h, windowW, windowH)
	self.x = (windowW - self.w * self.scale) / 2
	self.y = (windowH - self.h * self.scale) / 2

	if not app_is_shutting_down and dio.system.shouldAppClose () then
		local next_menu_name = self.current_menu:onAppShouldClose ()	
		if next_menu_name then
			self.next_menu_name = next_menu_name
		end
	end

	if app_is_shutting_down then
		app_is_ready_to_quit = dio.session.hasTerminated ()
		if app_is_ready_to_quit then
			return true
		end
	end

	if self.next_menu_name then
		if self.current_menu then
			self.current_menu:onExit (self.menus)
		end
		self.current_menu = self.menus [self.next_menu_name]
		self.next_menu_name = nil
		if self.current_menu then
			self.current_menu:onEnter (self.menus)
		end
	end

	local x = (dio.inputs.mouse.x - self.x) / self.scale
	local y = (dio.inputs.mouse.y - self.y) / self.scale
	local is_left_clicked = dio.inputs.mouse.left_button.is_clicked

	self.next_menu_name = self.current_menu:onUpdate (x, y, is_left_clicked);

	return false
end

--------------------------------------------------
function c:renderEarly ()
	if self.isVisible and self.current_menu then
		dio.drawing.setRenderToTexture (self.renderToTexture)
		self.current_menu:onRender ();
		dio.drawing.setRenderToTexture (nil)
	end
end

--------------------------------------------------
function c:renderLate ()
	if self.isVisible and self.current_menu then 
		dio.drawing.drawTexture (self.renderToTexture, self.x, self.y, self.w * self.scale, self.h * self.scale)
	end
end

--------------------------------------------------
function c:setIsVisible (isVisible)
	self.isVisible = isVisible
end

--------------------------------------------------
return function (all_menus, initial_menu_name)
	
	local instance = 
	{
		menus = all_menus,
		current_menu = nil,
		next_menu_name = initial_menu_name,
		w = 512,
		h = 256,
		scale = 1,
		isVisible = true,
	}

	instance.renderToTexture = dio.drawing.createRenderToTexture (instance.w, instance.h)

	Mixin.CopyTo (instance, c)

	return instance
end
