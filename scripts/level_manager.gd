extends Node
# Level Manager - Singleton for managing levels and game state
# Recreates the web version's level system

# Level data structure
var levels = [
	{
		"name": "How It Started",
		"size": Vector2(2000, 720),
		"player_start": Vector2(100, 500),
		"platforms": [
			{"pos": Vector2(200, 660), "size": Vector2(400, 120)},
			{"pos": Vector2(750, 660), "size": Vector2(300, 120)},
			{"pos": Vector2(1150, 660), "size": Vector2(400, 120)},
			{"pos": Vector2(1700, 660), "size": Vector2(600, 120)},
			{"pos": Vector2(350, 550), "size": Vector2(120, 20)},
			{"pos": Vector2(700, 500), "size": Vector2(120, 20)},
			{"pos": Vector2(1050, 550), "size": Vector2(120, 20)},
		],
		"hearts": [
			{"pos": Vector2(350, 450), "message": "The day I met you, everything felt lighter."},
			{"pos": Vector2(700, 400), "message": "I didn't know it then… but you were special."},
			{"pos": Vector2(1600, 550), "message": "That moment changed my life."}
		]
	},
	{
		"name": "Growing Closer",
		"size": Vector2(2000, 720),
		"player_start": Vector2(100, 500),
		"platforms": [
			{"pos": Vector2(200, 660), "size": Vector2(300, 120)},
			{"pos": Vector2(650, 550), "size": Vector2(200, 20)},
			{"pos": Vector2(1000, 450), "size": Vector2(200, 20)},
			{"pos": Vector2(1400, 600), "size": Vector2(600, 120)},
		],
		"hearts": [
			{"pos": Vector2(650, 500), "message": "Every moment with you was magic."},
			{"pos": Vector2(1000, 400), "message": "You made everything better."},
			{"pos": Vector2(1700, 550), "message": "I couldn't imagine life without you."}
		]
	}
]

var current_level_index: int = 0
var platform_scene: PackedScene = null
var heart_scene: PackedScene = null

signal level_loaded(level_data: Dictionary)
signal level_completed()

func _ready() -> void:
	# Load scenes at runtime (won't fail if they don't exist)
	if ResourceLoader.exists("res://scenes/platform.tscn"):
		platform_scene = load("res://scenes/platform.tscn")
	if ResourceLoader.exists("res://scenes/heart.tscn"):
		heart_scene = load("res://scenes/heart.tscn")

func get_current_level() -> Dictionary:
	return levels[current_level_index]

func load_level(index: int) -> void:
	if index < 0 or index >= levels.size():
		print("Level index out of range: ", index)
		return
	
	current_level_index = index
	level_loaded.emit(levels[index])

func next_level() -> bool:
	var next_index = current_level_index + 1
	if next_index >= levels.size():
		level_completed.emit()
		return false
	
	load_level(next_index)
	return true

func is_last_level() -> bool:
	return current_level_index == levels.size() - 1

func get_level_count() -> int:
	return levels.size()
