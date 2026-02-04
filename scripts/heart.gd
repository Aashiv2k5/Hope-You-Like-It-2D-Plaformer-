extends Area2D
# Heart collectible with floating animation and message display
# Recreates the web version's heart system

signal collected(message: String)

@export var message: String = "You mean everything to me."
@export var float_speed: float = 1.0
@export var float_amount: float = 15.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null

var start_position: Vector2
var collected_flag: bool = false

func _ready() -> void:
	start_position = global_position
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	if not collected_flag:
		# Floating animation
		var new_y = start_position.y + sin(Time.get_ticks_msec() / 1000.0 * float_speed) * float_amount
		global_position.y = new_y

func _on_body_entered(body: Node2D) -> void:
	if collected_flag:
		return
	
	if body.name == "Player":
		collect()

func collect() -> void:
	collected_flag = true
	
	# Emit signal with message
	collected.emit(message)
	
	# Hide sprite
	if sprite:
		sprite.visible = false
	
	# Disable collision so player can't collect again
	monitoring = false
	monitorable = false
	
	# Play particle effect if available
	if has_node("ParticleEffect"):
		$ParticleEffect.emitting = true
	
	# Play sound if available
	if has_node("CollectSound"):
		var collect_sound = $CollectSound
		# Try to load audio if not already loaded
		if collect_sound.stream == null:
			var audio_path = "res://assets/audio/heart_collect.wav"
			if ResourceLoader.exists(audio_path):
				collect_sound.stream = load(audio_path)
		
		if collect_sound.stream != null:
			collect_sound.play()
	
	# Don't queue_free - keep the heart in the scene so it can respawn!

func set_message(new_message: String) -> void:
	message = new_message

func respawn() -> void:
	# Reset the heart to be collectible again
	collected_flag = false
	
	# Restore position (in case it moved)
	global_position = start_position
	
	# Make sprite visible
	if sprite:
		sprite.visible = true
	
	# Re-enable collision
	monitoring = true
	monitorable = true
	
	print("Heart respawned at: ", start_position)
