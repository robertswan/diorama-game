--------------------------------------------------
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
local count = 0
function c:update ()

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
			self.current_menu:onExit ()
		end
		self.current_menu = self.menus [self.next_menu_name]
		self.next_menu_name = nil
		if self.current_menu then
			self.current_menu:onEnter ()
		end
	end

	local x = dio.inputs.mouse.x
	local y = dio.inputs.mouse.y
	local is_left_clicked = dio.inputs.mouse.left_button.is_clicked

	self.next_menu_name = self.current_menu:onUpdate (x, y, is_left_clicked);

	return false
end

--------------------------------------------------
function c:render ()
	if self.current_menu then
		self.current_menu:onRender ();
	end
end

--------------------------------------------------
return function (individual_menus, initial_menu_name)
	
	local instance = 
	{
		menus = individual_menus,
		current_menu = nil,
		next_menu_name = initial_menu_name
	}

	Mixin.CopyTo (instance, c)

	return instance
end
