extends Area2D
# Rotating Chainsaw Hazard
# Kills player on contact

@export var rotation_speed: float = 180.0  # Degrees per second
@export var damage_on_contact: bool = true

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

func _ready() -> void:
	# Connect collision detection
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	# Rotate the chainsaw continuously
	if sprite:
		sprite.rotation_degrees += rotation_speed * delta
	else:
		# If no sprite child, rotate the whole area
		rotation_degrees += rotation_speed * delta

func _on_body_entered(body: Node2D) -> void:
	# Check if the player touched the chainsaw
	if body.name == "Player" and damage_on_contact:
		if body.has_method("die"):
			body.die()
			print("Player hit chainsaw!")
