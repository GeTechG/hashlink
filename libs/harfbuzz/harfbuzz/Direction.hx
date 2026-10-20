package harfbuzz;

/**
	Text direction, with the values of `hb_direction_t`.
**/
enum abstract Direction(Int) to Int {
	var Invalid = 0;
	var LeftToRight = 4;
	var RightToLeft = 5;
	var TopToBottom = 6;
	var BottomToTop = 7;
}
