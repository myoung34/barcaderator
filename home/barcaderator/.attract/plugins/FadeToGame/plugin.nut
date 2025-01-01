// Layout User Options
class UserConfig </ help="Plugin fades the screen when transitioning to and from a game." /> {
	</ label="To Game Run Time",
		help="The amount of time in milliseconds to run the fade to game.",
		order=1 />
	toGameRunTime="500";
	</ label="From Game Run Time",
		help="The amount of time in milliseconds to run the fade from game.",
		order=2 />
	fromGameRunTime="500";
}

// FadeToGame
class FadeToGame {
	user_config = null;
	toGameRunTime = null;
	fromGameRunTime = null;
	shade = null;
	
	constructor() {
		user_config = fe.get_config();
		toGameRunTime = user_config["toGameRunTime"].tointeger();
		fromGameRunTime = user_config["fromGameRunTime"].tointeger();
		
		shade = fe.add_image("white.png", 0, 0, fe.layout.width, fe.layout.height);
		shade.set_rgb(0, 0, 0);
		shade.visible = false;
		shade.zorder = 9999;
		
		fe.add_transition_callback(this, "transitions");
	}
	
	function transitions(ttype, var, ttime) {
		switch(ttype) {
			case Transition.ToGame:
				shade.visible = true;
				if (ttime < toGameRunTime) {
					// Fade Out
					shade.alpha = (255 * (ttime - toGameRunTime)) / toGameRunTime;
					return true;
				}
				break;
			case Transition.FromGame:
				shade.visible = true;
				if (ttime < fromGameRunTime) {
					// Fade In
					shade.alpha = (255 * (fromGameRunTime - ttime)) / fromGameRunTime;
					return true;
				}
				break;
		}
		return false;
	}
}
fe.plugin["FadeToGame"] <- FadeToGame();
