# GdUnit generated TestSuite
class_name TokenProgressionsTest
extends GameManagerTest
@warning_ignore('unused_parameter')
@warning_ignore('return_value_discarded')

## trees
func test__grass_to_bush() -> void:
	await __await_combination_to_combination(IDs.GRASS, IDs.BUSHH)

func test__bush_to_tree() -> void:
	await __await_combination_to_combination(IDs.BUSHH, IDs.TREEE)

func test__tree_to_chest() -> void:
	await __await_combination_to_combination(IDs.TREEE, IDs.CHE_B)

func test__tree_to_big_tree() -> void:
	await __await_combination_to_combination(IDs.TREEE, IDs.B_TRE, Constants.DifficultyLevel.MEDIUM)
	
func test__big_tree_to_chest() -> void:
	await __await_combination_to_combination(IDs.B_TRE, IDs.CHE_B, Constants.DifficultyLevel.MEDIUM)

## graves
func test__grave_to_tomb() -> void:
	await __await_combination_to_combination(IDs.GRAVE, IDs.TOMBB)
	
func test__tomb_to_shrine() -> void:
	await __await_combination_to_combination(IDs.TOMBB, IDs.SRINE)
	
func test__shrine_to_silver_chest() -> void:
	await __await_combination_to_combination(IDs.SRINE, IDs.CHE_S)

## rocks
func test__stone_to_rock() -> void:
	await __await_combination_to_combination(IDs.STONE, IDs.ROCKK)
	
func test__rock_to_statue() -> void:
	await __await_combination_to_combination(IDs.ROCKK, IDs.STA_B)
	
func test__statue_to_chest() -> void:
	await __await_combination_to_combination(IDs.STA_B, IDs.CHE_B)

func test__statue_to_gold_statue() -> void:
	await __await_combination_to_combination(IDs.STA_B, IDs.STA_G, Constants.DifficultyLevel.MEDIUM)
	
func test__statue_gold_to_chest_gold() -> void:
	await __await_combination_to_combination(IDs.STA_G, IDs.CHE_G)

## houses

func test__lamp_to_gate() -> void:
	await __await_combination_to_combination(IDs.LAMPP, IDs.GATEE)

func test__gate_to_house() -> void:
	await __await_combination_to_combination(IDs.GATEE, IDs.HOUSE)

func test__house_to_chest_bronce() -> void:
	await __await_combination_to_combination(IDs.HOUSE, IDs.CHE_B)

func test__house_to_cottage() -> void:
	await __await_combination_to_combination(IDs.HOUSE, IDs.COTEG, Constants.DifficultyLevel.MEDIUM)
	
func test__cottage_to_tower() -> void:
	await __await_combination_to_combination(IDs.COTEG, IDs.TOWER, Constants.DifficultyLevel.MEDIUM)
	
func test__tower_to_chest_silver() -> void:
	await __await_combination_to_combination(IDs.TOWER, IDs.CHE_S, Constants.DifficultyLevel.MEDIUM)

func test__tower_to_palace() -> void:
	await __await_combination_to_combination(IDs.TOWER, IDs.PALAC, Constants.DifficultyLevel.HARD)

func test__palace_to_fortress() -> void:
	await __await_combination_to_combination(IDs.PALAC, IDs.FORTR, Constants.DifficultyLevel.HARD)

## chests
func test__chest_bronce_to_chest_silver() -> void:
	await __await_combination_to_combination(IDs.CHE_B, IDs.CHE_S)

func test__chest_silver_to_chest_gold() -> void:
	await __await_combination_to_combination(IDs.CHE_S, IDs.CHE_G)

func test__chest_gold_to_chest_diamond() -> void:
	await __await_combination_to_combination(IDs.CHE_G, IDs.CHE_D)
