extends Node

class_name  Constants

enum TokenType {
	NORMAL,
	CHEST,
	PRIZE,
	ENEMY,
	WILDCARD
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
	CHECK,
	PAUSED,
	GAME_OVER
}

enum MergeType {
	BY_INITIAL_CELL,
	BY_LAST_CREATED
}

enum MessageType {
	INFO,
	NORMAL,
	ERROR
}

enum UIPlayScreenId {
	NONE,
	INTRO,
	PLAYING,
	PAUSE,
	GAME_OVER
}

const WILDCARD_ID = "WILDCARD"
const GRAVE_ID = "GRAVE"

const MIN_REQUIRED_TOKENS_FOR_COMBINATION = 3 
const EMPTY_CELL = ""
const INVALID_CELL = Vector2(-1,-1)
const IS_DEBUG_MODE = true

const GROUP_ENEMIES = "enemies"

const CELL_SIZE:Vector2 = Vector2(90,90)

# TODO resize to 64
const TOKEN_SPRITE_SIZE: Vector2 = Vector2(128, 128)
const CELL_SPRITE_SIZE: Vector2 = Vector2(64, 64) 
