extends Node

class_name  Constants

enum TokenType {
	NORMAL,
	CHEST,
	PRIZE,
	ENEMY,
	ACTION
}

enum EnemyType {
	MONOKELO,
	ROLLER,
	MOLE,
	CRAB
}

enum ActionType {
	NONE,
	MOVE,
	LEVEL_UP,
	BOMB,
	REMOVE_ALL,
	WILDCARD,
}

enum ActionResult {
	VALID,
	INVALID,
	WASTED
}

enum CellHighlight {
	NONE,
	VALID,
	INVALID,
	WASTED,
	COMBINATION
}

enum TokenHighlight {
	NONE,
	VALID,
	INVALID,
	WASTED,
	COMBINATION,
	LAST,
}


enum TokenStatus {
	NONE,
	BOXED,
	FLOATING,
	PLACED,
	IN_RANGE,
	INVISIBLE,
	GHOST_BOX
}


enum RewardType {
	NONE,
	GOLD,
	POINTS,
}

enum FloorType {
	OUT,
	PATH,
	GRASS,
	FOUNDATIONS
}

enum PlayingState {
	NONE,
	LOADING,
	START,
	ENEMIES,
	PLAYER,
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

const BOARD_SIZE := Vector2(6,5)

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

const HOLD_TIME_TO_CANCEL_PRESS: float = 1

# Game Objects positions
const BOARD_Z_INDEX : float = 1
const CELL_Z_INDEX: float = 2
const TOKENS_Z_INDEX: float = 3
const FX_Z_INDEX : float = 20
const GHOST_BOX_Z_INDEX : float = 24
const FLOATING_Z_INDEX : float = 25

const BOARD_BOTTOM_SEPARATION: float = 100

const TOKEN_SPRITE_HOLDER_Y = 25

const TOKEN_SHADOW_Y_POS = 2
const TOKEN_BOXED_Y_POS: float = 20
const TOKEN_FLOATING_Y_POS: float = 20
const TOKEN_IN_RANGE_Y_POS: float = 10

const TOKEN_SHADOW_FLOATING_MULTIPLIER: float = .5
const TOKEN_SHADOW_IN_RANGE_MULTIPLIER: float = .75

const BOARD_SPAWN_TOKEN_Y_SEPARATION_MULTIPLIER: float = 1.2
