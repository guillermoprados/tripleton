extends Node

enum HighlightMode {
	NONE,
	HOVER,
	SAME_LINE,
	COMBINATION
}

enum RewardType {
	NONE,
	GOLD,
	POINTS,
}

enum MessageType {
	INFO,
	NORMAL,
	ERROR
}


const MIN_REQUIRED_TOKENS_FOR_COMBINATION = 3 
const INVALID_TOKEN_ID = ""
const EMPTY_CELL = ""
const IS_DEBUG_MODE = true
