extends Area2D
# Ejection Spring / Bounce Pad
# Launches player upward when stepped on

@export var bounce_force: float = 800.0  # Upward launch velocity
@export var horizontal_boost: float = 0.0  # Optional horizontal boost
@export var animation_enabled: bool = true
@export var compress_amount: float = 0.2  # How much spring compresses (0-1)

@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null

var original_scale: Vector2
var is_compressed: bool = false

func _ready() -> void:
	# Connect collision detection
	body_entered.connect(_on_body_entered)
	
	# Store original scale for spring animation
	if sprite:
		original_scale = sprite.scale
	else:
		original_scale = scale

func _on_body_entered(body: Node2D) -> void:
	# Check if player landed on spring
	if body.name == "Player":
		# Launch player upward
		launch_player(body)

func launch_player(player: Node2D) -> void:
	# Apply bounce force to player
	if player.has_method("bounce"):
		player.bounce(bounce_force, horizontal_boost)
	else:
		# Fallback: directly set velocity
		player.velocity.y = -bounce_force
		player.velocity.x += horizontal_boost
	
	# Play spring animation
	if animation_enabled:
		play_bounce_animation()
	
	# Play sound if available
	if has_node("BounceSound"):
		$BounceSound.play()
	
	print("Player bounced! Force: ", bounce_force)

func play_bounce_animation() -> void:
	if is_compressed:
		return  # Already animating
	
	is_compressed = true
	
	# Use AnimationPlayer if available
	if animation_player and animation_player.has_animation("bounce"):
		animation_player.play("bounce")
		await animation_player.animation_finished
		is_compressed = false
	else:
		# Manual compression animation
		await compress_spring()
		is_compressed = false

func compress_spring() -> void:
	var tween = create_tween()
	
	if sprite:
		# Compress sprite
		var compressed_scale = original_scale * Vector2(1.0 + compress_amount, 1.0 - compress_amount)
		tween.tween_property(sprite, "scale", compressed_scale, 0.1)
		tween.tween_property(sprite, "scale", original_scale, 0.2).set_ease(Tween.EASE_OUT)
	else:
		# Compress whole node
		var compressed_scale = original_scale * Vector2(1.0 + compress_amount, 1.0 - compress_amount)
		tween.tween_property(self, "scale", compressed_scale, 0.1)
		tween.tween_property(self, "scale", original_scale, 0.2).set_ease(Tween.EASE_OUT)
	
	await tween.finished
