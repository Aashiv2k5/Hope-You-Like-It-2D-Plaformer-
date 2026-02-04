extends CanvasLayer
# Heart HUD - Displays heart collection counter in top left corner

@onready var label: Label = $Panel/MarginContainer/HeartLabel

func _ready() -> void:
	# Initialize with 0 hearts
	update_count(0, 3)

func update_count(current: int, max_hearts: int) -> void:
	if label:
		label.text = "Hearts: %d/%d" % [current, max_hearts]
