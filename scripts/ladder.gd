extends Area2D
# Ladder - Allows player to climb up and down
# Place this on an Area2D node with a CollisionShape2D

@export var climb_speed: float = 150.0

var player_on_ladder: Node2D = null

func _ready() -> void:
	# Connect signals for collision detection
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("enter_ladder"):
		player_on_ladder = body
		body.enter_ladder(self)
		print("Player entered ladder: ", name)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Player" and body.has_method("exit_ladder"):
		# Only exit if player was on THIS specific ladder
		if player_on_ladder == body and body.current_ladder == self:
			player_on_ladder = null
			body.exit_ladder()
			print("Player exited ladder: ", name)

func get_climb_speed() -> float:
	return climb_speed
