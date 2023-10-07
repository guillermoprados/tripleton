extends Node

class_name  Constants

enum TokenType {
	NORMAL,
	CHEST,
	PRIZE,
	ENEMY
}

enum EnemyType {
	BEAR,
	ROLLER,
	MOLE,
	CRAB
}

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

enum PlayingState {
	NONE,
	INTRO,
	PLAYER,
	ENEMIES,
	PAUSED
}

enum MessageType {
	INFO,
	NORMAL,
	ERROR
}

enum UIPlayState {
	NONE,
	INTRO,
	PLAYING,
	PAUSE,
	GAME_OVER
}


const MIN_REQUIRED_TOKENS_FOR_COMBINATION = 3 
const INVALID_TOKEN_ID = ""
const EMPTY_CELL = ""
const INVALID_CELL = Vector2(-1,-1)
const IS_DEBUG_MODE = true

const GROUP_ENEMIES = "enemies"

const token_predefined_size: Vector2 = Vector2(128, 128)
