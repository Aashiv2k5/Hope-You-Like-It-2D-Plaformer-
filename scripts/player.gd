extends CharacterBody2D
# Player controller - Handles movement, jumping, and physics
# Recreates the web version's player mechanics

# Movement settings
@export var move_speed: float = 300.0
@export var acceleration: float = 25.0
@export var deceleration: float = 25.0

# Jump settings
@export var jump_velocity: float = -350.0
@export var gravity: float = 1000.0
@export var max_fall_speed: float = 600.0
@export var coyote_time: float = 0.15
@export var jump_buffer_time: float = 0.15

# Ladder settings
@export var ladder_climb_speed: float = 150.0

# Sprite textures
var idle_texture: Texture2D
var walk_texture: Texture2D
var jump_texture: Texture2D

# References
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer if has_node("AnimationPlayer") else null

# State
var last_grounded_time: float = 0.0
var jump_buffer_counter: float = 0.0

# Ladder state
var is_on_ladder: bool = false
var current_ladder: Area2D = null

func _ready() -> void:
	# Load sprite textures
	idle_texture = load("res://Scene1/player_idle.png")
	walk_texture = load("res://Scene1/player_walk.png")
	jump_texture = load("res://Scene1/player_jump.png")
	
	# Set initial sprite
	if sprite and idle_texture:
		sprite.texture = idle_texture

func _physics_process(delta: float) -> void:
	if is_on_ladder:
		# Climbing mode
		handle_ladder_movement()
	else:
		# Normal platformer mode
		handle_normal_movement(delta)
	
	move_and_slide()
	
	# Update sprite animation based on state
	update_sprite_animation()

func handle_normal_movement(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity.y = min(velocity.y + gravity * delta, max_fall_speed)
	
	# Update timers
	if is_on_floor():
		last_grounded_time = coyote_time
	else:
		last_grounded_time -= delta
	
	# Jump buffer
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump"):
		jump_buffer_counter = jump_buffer_time
	else:
		jump_buffer_counter -= delta
	
	# Jump
	if jump_buffer_counter > 0 and last_grounded_time > 0:
		velocity.y = jump_velocity
		jump_buffer_counter = 0
		last_grounded_time = 0
	
	# Horizontal movement
	var input_direction = Input.get_axis("ui_left", "ui_right")
	
	if input_direction != 0:
		var target_speed = input_direction * move_speed
		velocity.x = move_toward(velocity.x, target_speed, acceleration)
		
		# Flip sprite
		if input_direction < 0:
			sprite.flip_h = true
		elif input_direction > 0:
			sprite.flip_h = false
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)

func handle_ladder_movement() -> void:
	# Disable gravity while on ladder
	velocity.y = 0
	velocity.x = 0
	
	# Vertical movement (up/down)
	var vertical_input = Input.get_axis("ui_up", "ui_down")
	if vertical_input != 0:
		velocity.y = vertical_input * ladder_climb_speed
	
	# Horizontal movement to get off ladder
	var horizontal_input = Input.get_axis("ui_left", "ui_right")
	if horizontal_input != 0:
		velocity.x = horizontal_input * move_speed
		exit_ladder()  # Get off the ladder
	
	# Jump off ladder
	if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		exit_ladder()

# Called by ladder when player enters
func enter_ladder(ladder: Area2D) -> void:
	is_on_ladder = true
	current_ladder = ladder
	velocity = Vector2.ZERO
	
	# Use ladder's climb speed if available
	if ladder.has_method("get_climb_speed"):
		ladder_climb_speed = ladder.get_climb_speed()
	
	print("Player entered ladder")

# Called by ladder when player exits or manually exits
func exit_ladder() -> void:
	is_on_ladder = false
	current_ladder = null
	print("Player exited ladder")

func respawn(position: Vector2) -> void:
	global_position = position
	velocity = Vector2.ZERO
	last_grounded_time = 0.0
	jump_buffer_counter = 0.0
	
	# Exit ladder if on one
	if is_on_ladder:
		exit_ladder()
	
	# Reset sprite direction
	if sprite:
		sprite.flip_h = false

func get_bounds() -> Vector2:
	if sprite:
		return sprite.get_rect().size * sprite.scale
	return Vector2(32, 32)

func die() -> void:
	# Called when player dies from hazards (chainsaw, spikes, etc.)
	print("Player died!")
	
	# Play death sound if available
	if has_node("DeathSound"):
		var death_sound = $DeathSound
		# Try to load audio if not already loaded
		if death_sound.stream == null:
			var audio_path = "res://assets/audio/player_death.wav"
			if ResourceLoader.exists(audio_path):
				death_sound.stream = load(audio_path)
		
		if death_sound.stream != null:
			death_sound.play()
			# Wait for sound to finish before respawning
			await get_tree().create_timer(0.3).timeout
	
	# Get spawn position from parent scene (Main node)
	var main = get_parent()
	if main and main.has_method("respawn_player"):
		main.respawn_player()
	else:
		# Fallback: respawn at current position (not ideal but prevents softlock)
		respawn(global_position)

func bounce(force: float, horizontal_boost: float = 0.0) -> void:
	# Called by springs/bounce pads to launch player
	velocity.y = -force
	velocity.x += horizontal_boost
	
	# Exit ladder if on one
	if is_on_ladder:
		exit_ladder()
	
	print("Player bounced with force: ", force)

func update_sprite_animation() -> void:
	# Update the player sprite based on current state
	if not sprite:
		return
	
	if not is_on_floor():
		# Jumping or falling
		if jump_texture:
			sprite.texture = jump_texture
	elif abs(velocity.x) > 10:
		# Walking
		if walk_texture:
			sprite.texture = walk_texture
	else:
		# Idle
		if idle_texture:
			sprite.texture = idle_texture
