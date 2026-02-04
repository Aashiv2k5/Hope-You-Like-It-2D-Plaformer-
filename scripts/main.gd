extends Node2D
# Main game scene - Handles heart collection and message display coordination

@onready var message_popup: CanvasLayer = $MessagePopup
@onready var player: CharacterBody2D = $Player
@onready var camera: Camera2D = $Camera2D
@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var heart_hud: CanvasLayer = $HeartHUD

# Game state
var hearts_collected: int = 0
var max_hearts: int = 3
var all_hearts: Array = []  # Store references to all hearts
var player_spawn_position: Vector2
var game_ended: bool = false

# Level bounds for fall detection
var level_height: float = 720.0
var fall_threshold: float = 100.0

# Camera boundary limits for respawn
var camera_left_boundary: float = -100.0  # Left edge with buffer
var camera_right_boundary: float = 2100.0  # Right edge beyond level_width (2000)

# Parallax scrolling control
var parallax_scroll_limit: float = 2304.0  # Two camera sections (2 * 1152)
var parallax_enabled: bool = true

func _ready() -> void:
	# Store player's initial spawn position
	if player:
		player_spawn_position = player.global_position
	
	# Connect all heart signals to the message popup
	connect_hearts()
	
	# Initialize HUD
	if heart_hud:
		heart_hud.update_count(hearts_collected, max_hearts)
	
	# Connect camera signal for parallax control
	if camera and camera.has_signal("distance_traveled_updated"):
		camera.distance_traveled_updated.connect(_on_camera_distance_updated)
	
	# Start background music
	start_background_music()

func _process(delta: float) -> void:
	if game_ended:
		return
	
	# Check if player has fallen off the level
	check_player_fall()
	
	# Check if player has exited camera boundaries
	check_camera_boundaries()

func connect_hearts() -> void:
	# Get all hearts in the scene
	all_hearts = get_all_hearts(self)
	
	for heart in all_hearts:
		if heart.has_signal("collected"):
			heart.collected.connect(_on_heart_collected)

func get_all_hearts(node: Node) -> Array:
	var hearts = []
	
	for child in node.get_children():
		if child.name.begins_with("Heart"):
			hearts.append(child)
		# Recursively check children
		hearts.append_array(get_all_hearts(child))
	
	return hearts

func _on_heart_collected(message: String) -> void:
	# Increment hearts collected
	hearts_collected += 1
	
	print("Hearts collected: ", hearts_collected, "/", max_hearts)
	
	# Update HUD
	if heart_hud:
		heart_hud.update_count(hearts_collected, max_hearts)
	
	# Show the message popup when a heart is collected
	if message_popup:
		message_popup.show_message(message)
	
	# Check if player should respawn after collecting 3 hearts
	if hearts_collected >= max_hearts:
		# Show respawn message
		if message_popup:
			message_popup.show_message("3 hearts collected! Respawning... 💕")
		
		# Wait a moment before respawning
		await get_tree().create_timer(1.5).timeout
		
		# Reset hearts counter
		hearts_collected = 0
		
		# Update HUD
		if heart_hud:
			heart_hud.update_count(hearts_collected, max_hearts)
		
		# Respawn player at starting position
		respawn_player()

func check_player_fall() -> void:
	if not player:
		return
	
	# Check if player has fallen below the level
	if player.global_position.y > level_height + fall_threshold:
		# Call die() to trigger death sequence instead of instant respawn
		player.die()

func check_camera_boundaries() -> void:
	if not player:
		return
	
	# Check if player has exited the horizontal camera boundaries
	if player.global_position.x < camera_left_boundary or player.global_position.x > camera_right_boundary:
		print("Player exited camera boundaries at x: ", player.global_position.x)
		# Call die() to trigger death sequence instead of instant respawn
		player.die()

func respawn_player() -> void:
	if player:
		print("Player fell! Respawning at start position...")
		
		# Respawn all hearts first
		respawn_all_hearts()
		
		# Reset hearts counter
		hearts_collected = 0
		
		# Update HUD
		if heart_hud:
			heart_hud.update_count(hearts_collected, max_hearts)
		
		# Respawn player
		player.respawn(player_spawn_position)

func respawn_all_hearts() -> void:
	# Respawn all hearts in the level
	for heart in all_hearts:
		if heart and heart.has_method("respawn"):
			heart.respawn()
	print("All hearts respawned!")

func end_game() -> void:
	game_ended = true
	print("Game ended! All ", max_hearts, " hearts collected!")
	
	# Show victory message
	show_victory_screen()

func show_victory_screen() -> void:
	# Create a victory message
	var victory_message = "Congratulations! You collected all the hearts! 💕"
	
	if message_popup:
		message_popup.show_message(victory_message)
	
	# Optionally pause the game
	get_tree().paused = false  # Keep running for now, can be set to true to pause

func _on_camera_distance_updated(distance: float) -> void:
	# Check if camera has scrolled beyond the limit
	if parallax_enabled and distance >= parallax_scroll_limit:
		stop_parallax_scrolling()

func stop_parallax_scrolling() -> void:
	if not parallax_enabled:
		return
	
	parallax_enabled = false
	print("Parallax scrolling stopped after 2 camera sections")
	
	# Disable parallax background scrolling
	if parallax_background:
		parallax_background.scroll_ignore_camera_zoom = true
		# Freeze all parallax layers
		for child in parallax_background.get_children():
			if child is ParallaxLayer:
				child.motion_scale = Vector2.ZERO

func start_background_music() -> void:
	# Load and play background music
	if has_node("BackgroundMusic"):
		var music_player = $BackgroundMusic
		var audio_path = "res://assets/audio/background_music.ogg"
		
		# Try to load the audio file
		if ResourceLoader.exists(audio_path):
			music_player.stream = load(audio_path)
			# Enable looping for background music
			if music_player.stream is AudioStreamOggVorbis:
				music_player.stream.loop = true
			music_player.play()
			print("Background music started")
		else:
			print("Background music file not found at: ", audio_path)
			print("Please add an audio file at assets/audio/background_music.ogg")
