extends Camera2D
# Camera follow system with smooth damping and level bounds
# Recreates the web version's camera system

# Signal for parallax control
signal distance_traveled_updated(distance: float)

# Follow settings
@export var target: NodePath
@export var smoothing_enabled: bool = true
@export var smoothing_speed: float = 8.0
@export var offset_position: Vector2 = Vector2(0, -50)

# Level bounds
@export var level_width: float = 2000.0
@export var level_height: float = 720.0

var target_node: Node2D = null
var start_position: Vector2 = Vector2.ZERO
var total_distance_traveled: float = 0.0
var last_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	if target:
		target_node = get_node(target)
	
	# Set camera limits based on level bounds
	update_level_bounds()
	
	# Store starting position for distance tracking
	await get_tree().process_frame
	start_position = global_position
	last_position = global_position

func _process(delta: float) -> void:
	if not target_node:
		return
	
	# Calculate desired position
	var desired_position = target_node.global_position + offset_position
	
	var old_position = global_position
	
	# Apply smoothing
	if smoothing_enabled:
		global_position = global_position.lerp(desired_position, smoothing_speed * delta)
	else:
		global_position = desired_position
	
	# Clamp to level bounds
	var viewport_size = get_viewport_rect().size / zoom
	var half_width = viewport_size.x / 2.0
	var half_height = viewport_size.y / 2.0
	
	global_position.x = clamp(global_position.x, half_width, level_width - half_width)
	global_position.y = clamp(global_position.y, half_height, level_height - half_height)
	
	# Track distance traveled (primarily horizontal)
	var distance_delta = abs(global_position.x - last_position.x)
	total_distance_traveled += distance_delta
	last_position = global_position
	
	# Emit signal for parallax control
	distance_traveled_updated.emit(total_distance_traveled)

func set_target(new_target: Node2D) -> void:
	target_node = new_target
	if target_node:
		global_position = target_node.global_position + offset_position

func set_level_bounds(width: float, height: float) -> void:
	level_width = width
	level_height = height
	update_level_bounds()

func update_level_bounds() -> void:
	limit_left = 0
	limit_right = int(level_width)
	limit_top = 0
	limit_bottom = int(level_height)

func get_distance_traveled() -> float:
	return total_distance_traveled
