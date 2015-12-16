--------------------------------------------------
local menus = require ("resources/scripts/menus/menu_construction")

--------------------------------------------------
function onStartNewLevelClicked ()

	dio.session.terminate () -- kills it immediately

	-- these are not used!
	local params =
	{
		should_save = true,
	}

	dio.session.requestBegin (params)
end

--------------------------------------------------
function createMainMenu ()

	local menu = menus.createMenu ("MAIN MENU")

	menus.addButton (menu, "Start New Level", onStartNewLevelClicked)
	menus.addBreak (menu)
	--menus.addLabel (menu, dio.getVersionString ())
	menus.addLabel (menu, "TEST")

	return menu
end





--[[

	sessions_gamestate
	{

		int session_id = StartNewSession ();

		UpdateSessions ()
		{
			current_alive_session->Update ();
			all_shutting_down_sessions->UpdateShutdown ();
		}

		ShutdownSession ();

		bool HasShutdown (session_id);

	private:

		Session * current_session_;
		std::list <Session *> shutting_down_sessions_;
	}



	lifecycle of a session - what is it?

	session = new Session ()
	session->start (instant)

	session->update (instant, repeat etc)

	session->shutdown (not instant!)
	session->updateShutdown ()
	if (session->hasShutdown ())
	{
		delete sessions
	}

	



]]--



--------------------------------------------------
return createMainMenu ()
