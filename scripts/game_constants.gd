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

enum FloorType {
	PATH,
	GRASS,
	FOUNDATIONS
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

const TILESET_TERRAIN_BOARD_SET = 0
const TILESET_TERRAIN_BACK = 0
const TILESET_TERRAIN_PATH = 1
const TILESET_TERRAIN_OUT = 2

const MIN_REQUIRED_TOKENS_FOR_COMBINATION = 3 
const MIN_LANDSCAPE_TOKENS = 3
const MAX_LANDSCAPE_TOKENS = 13
const EMPTY_CELL = ""
const INVALID_CELL = Vector2(-1,-1)
const IS_DEBUG_MODE = true

const CELL_SIZE:Vector2 = Vector2(100,100)

const TOKEN_PROB_COMMON: float = 0.6
const TOKEN_PROB_UNCOMMON: float = TOKEN_PROB_COMMON + 0.2 
const TOKEN_PROB_RARE: float = TOKEN_PROB_UNCOMMON + 0.1 
const TOKEN_PROB_SCARCE: float = TOKEN_PROB_RARE + 0.08 

# Game Objects positions
const BOARD_BOTTOM_SEPARATION: float = 50
const TOKEN_Y_DELTA: float = 25
const BOARD_SPAWN_TOKEN_Y_SEPARATION_MULTIPLIER: float = 1.2
