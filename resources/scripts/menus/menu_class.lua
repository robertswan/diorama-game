--------------------------------------------------
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:addMenuItem (menu_item)
	menu_item.x = 0
	menu_item.y = self.next_y
	self.next_y = self.next_y + menu_item.height
	table.insert (self.items, menu_item)

	return menu_item	
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
	-- go through every item
	-- check if the mouse is over it
	-- if so, switch the text for a HIGHLIGHTED

	local next_menu = nil

	for i, item in ipairs (self.items) do

		if item.onUpdate then
			local next_menu_2 = item:onUpdate (self, x, y, was_left_clicked)
			if next_menu_2 then
				next_menu = next_menu_2
			end
		end
	end

	for event, callback in pairs (self.events) do
		if dio.inputs.events [event] then
			next_menu = callback ();
		end
	end

	return next_menu
end

--------------------------------------------------
function c:onRender ()
	local font = dio.drawing.font;
	
	if self.title then
		font.drawString (200, 0, self.title, 0xffff0000)
	end

	local highlighted_item = nil
	for idx, menu_item in ipairs (self.items) do

		if menu_item.onRender then
			menu_item:onRender (font)
		end

		-- font.drawString (item.x, item.y, item.text, 0xffff0000)
	end
end

--------------------------------------------------
function c:onAppShouldClose ()
	app_is_shutting_down = true
	-- TODO should this also do...
	--dio.session.terminate ()
	--return "quitting_menu"
end

--------------------------------------------------
function c:onEnter ()
end

--------------------------------------------------
function c:onExit ()
end

--------------------------------------------------
return function (title)
	
	local instance = 
	{
		title = title,
		items = {},
		next_y = 40,
		events = {}		
	}

	Mixin.CopyTo (instance, c)

	return instance
end
