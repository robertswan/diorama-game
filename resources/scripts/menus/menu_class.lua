--------------------------------------------------
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
	-- go through every item
	-- check if the mouse is over it
	-- if so, switch the text for a HIGHLIGHTED

	local next_menu = nil
	local highlighted_item = nil

	for i, item in ipairs (self.items) do

		if item.onClicked then

			local is_over = 
					x >= item.x and 
					x < item.x + item.w and
					y >= item.y and 
					y < item.y + item.h

			item.text = is_over and item.text_focused or item.text_unfocused
			if is_over then
				highlighted_item = item
			end
		end
	end

	if was_left_clicked and highlighted_item then
		next_menu = highlighted_item:onClicked ()
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
	font.drawString (200, 0, self.title, 0xffff0000)

	local highlighted_item = nil
	for i, item in ipairs (self.items) do

		font.drawString (item.x, item.y, item.text, 0xffff0000)
	end
end

--------------------------------------------------
function c:onAppShouldClose ()
	app_is_shutting_down = true 
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
		next_y = 100,
		events = {}		
	}

	Mixin.CopyTo (instance, c)

	return instance
end
