extends Node

class_name  Constants

enum TokenType {
	NORMAL,
	CHEST,
	PRIZE,
	ENEMY,
	WILDCARD,
	ACTION
}

enum EnemyType {
	BEAR,
	ROLLER,
	MOLE,
	CRAB
}

enum ActionType {
	MOVE,
	LEVEL_UP,
	REMOVE,
	BOMB,
	SWIRL
}

enum CellHighlight {
	NONE,
	VALID,
	WARNING,
	INVALID,
	COMBINATION
}

enum TokenHighlight {
	NONE,
	LAST,
	INVALID,
	TRANSPARENT
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

const MIN_REQUIRED_TOKENS_FOR_COMBINATION = 3 
const MIN_LANDSCAPE_TOKENS = 3
const MAX_LANDSCAPE_TOKENS = 13
const EMPTY_CELL = ""
const INVALID_CELL = Vector2(-1,-1)
const IS_DEBUG_MODE = true

const CELL_SIZE:Vector2 = Vector2(90,90)

# TODO resize to 64
const TOKEN_SPRITE_SIZE: Vector2 = Vector2(128, 128)
const CELL_SPRITE_SIZE: Vector2 = Vector2(64, 64) 

const TOKEN_PROB_COMMON: float = 0.6
const TOKEN_PROB_UNCOMMON: float = TOKEN_PROB_COMMON + 0.2 
const TOKEN_PROB_RARE: float = TOKEN_PROB_UNCOMMON + 0.1 
const TOKEN_PROB_SCARCE: float = TOKEN_PROB_RARE + 0.08 
