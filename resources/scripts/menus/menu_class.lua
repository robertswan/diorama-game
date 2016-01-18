--------------------------------------------------
local Mixin = require ("resources/scripts/menus/mixin")

--------------------------------------------------
local c = {}

--------------------------------------------------
function c:addMenuItem (menuItem)
	menuItem.x = 0
	menuItem.y = self.next_y
	self.next_y = self.next_y + menuItem.height + menuItem.gapY
	table.insert (self.items, menuItem)

	return menuItem	
end

--------------------------------------------------
function c:clearAllMenuItems ()
	self.items = {}
	self.next_y = 40
	self.events = {}
end

--------------------------------------------------
function c:setUpdateOnlySelectedMenuItems (isSet)
	self.isUpdatingOnlySelectedMenuItems = isSet
end

--------------------------------------------------
function c:onUpdate (x, y, was_left_clicked)
	-- go through every item
	-- check if the mouse is over it
	-- if so, switch the text for a HIGHLIGHTED

	local next_menu = nil

	for i, item in ipairs (self.items) do

		if item.onUpdate then

			if not self.isUpdatingOnlySelectedMenuItems or item.isSelected then

				local next_menu_2 = item:onUpdate (self, x, y, was_left_clicked)
				if next_menu_2 then
					next_menu = next_menu_2
				end
				
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
		local width = font.measureString (self.title)
		font.drawString ((self.width - width) * 0.5, 0, self.title, 0xffffffff)
	end

	local highlighted_item = nil
	for idx, menuItem in ipairs (self.items) do

		if menuItem.onRender then
			menuItem:onRender (font, self)
		end

		-- font.drawString (item.x, item.y, item.text, 0xffff0000)
	end
end

--------------------------------------------------
function c:onKeyCodeClicked (keyCode)
	local next_menu = nil

	for i, item in ipairs (self.items) do

		if item.onKeyCodeClicked and item.isSelected then

			local wasConsumed = item:onKeyCodeClicked (self, keyCode)
			if wasConsumed then
				return true
			end
		end
	end	
end

--------------------------------------------------
function c:onKeyCharacterClicked (character)
	local next_menu = nil

	for i, item in ipairs (self.items) do

		if item.onKeyCharacterClicked and item.isSelected then

			local wasConsumed = item:onKeyCharacterClicked (self, character)
			if wasConsumed then
				return true
			end
		end
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
		next_y = 30,
		events = {},
		width = 512,
		height = 256,
	}

	Mixin.CopyTo (instance, c)

	return instance
end
