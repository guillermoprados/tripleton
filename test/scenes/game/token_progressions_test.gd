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
	await __await_combination_to_combination(IDs.TREEE, IDs.B_TRE, true)
	
func test__big_tree_to_chest() -> void:
	await __await_combination_to_combination(IDs.B_TRE, IDs.CHE_B, true)

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
	await __await_combination_to_combination(IDs.STA_B, IDs.STA_G, true)
	
func test__statue_gold_to_chest_gold() -> void:
	await __await_combination_to_combination(IDs.STA_G, IDs.CHE_G)
