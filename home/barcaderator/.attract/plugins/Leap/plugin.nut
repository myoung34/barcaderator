// --------------------
// Leap
// --------------------

class Leap {
	constructor() {
		fe.add_transition_callback(this, "transitions");
	}

	function transitions(ttype, var, ttime) {
		if (ttype == Transition.ToNewList) {
			if (fe.list.display_index < 0) return false; // 'Displays Menu' (with a custom layout) is currently showing
			if (fe.list.search_rule != "") return false; // Search rule applied to the current game list
			if (fe.list.filter_index == 0) return false; // No filters or first filter

			if (fe.list.size == 0) {
				switch (var) {
					case -1:
						fe.signal("prev_filter");
						break;
					case 0:
					case 1:
						fe.signal("next_filter");
						break;
				}
			}
		}
		return false;
	}
}
fe.plugin["Leap"] <- Leap();
