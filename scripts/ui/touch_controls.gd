extends CanvasLayer
# Mobile Touch Controls
# On-screen buttons for mobile gameplay

# Virtual button references
@onready var left_button: TouchScreenButton = $LeftButton if has_node("LeftButton") else null
@onready var right_button: TouchScreenButton = $RightButton if has_node("RightButton") else null
@onready var jump_button: TouchScreenButton = $JumpButton if has_node("JumpButton") else null
@onready var up_button: TouchScreenButton = $UpButton if has_node("UpButton") else null
@onready var down_button: TouchScreenButton = $DownButton if has_node("DownButton") else null

# Auto-hide on desktop
@export var hide_on_desktop: bool = false  # Changed to false for testing!

func _ready() -> void:
	print("Touch Controls: Ready called")
	print("Platform: ", OS.get_name())
	
	# Always setup buttons first
	setup_buttons()
	
	# Hide controls on desktop platforms if enabled
	if hide_on_desktop and OS.get_name() in ["Windows", "Linux", "macOS"]:
		print("Touch Controls: Hiding on desktop")
		visible = false
	else:
		print("Touch Controls: Showing controls")
		visible = true

func setup_buttons() -> void:
	print("Touch Controls: Setting up buttons...")
	
	# Connect button signals if buttons exist
	if left_button:
		print("  ✓ Left button found")
		left_button.pressed.connect(_on_left_pressed)
		left_button.released.connect(_on_left_released)
	else:
		print("  ✗ Left button NOT found")
	
	if right_button:
		print("  ✓ Right button found")
		right_button.pressed.connect(_on_right_pressed)
		right_button.released.connect(_on_right_released)
	else:
		print("  ✗ Right button NOT found")
	
	if jump_button:
		print("  ✓ Jump button found")
		jump_button.pressed.connect(_on_jump_pressed)
	else:
		print("  ✗ Jump button NOT found")
	
	if up_button:
		print("  ✓ Up button found")
		up_button.pressed.connect(_on_up_pressed)
		up_button.released.connect(_on_up_released)
	else:
		print("  ✗ Up button NOT found (optional)")
	
	if down_button:
		print("  ✓ Down button found")
		down_button.pressed.connect(_on_down_pressed)
		down_button.released.connect(_on_down_released)
	else:
		print("  ✗ Down button NOT found (optional)")

# Button callbacks
func _on_left_pressed() -> void:
	print("LEFT button pressed")
	Input.action_press("ui_left")

func _on_left_released() -> void:
	print("LEFT button released")
	Input.action_release("ui_left")

func _on_right_pressed() -> void:
	print("RIGHT button pressed")
	Input.action_press("ui_right")

func _on_right_released() -> void:
	print("RIGHT button released")
	Input.action_release("ui_right")

func _on_jump_pressed() -> void:
	print("JUMP button pressed")
	Input.action_press("ui_accept")
	# Small delay then release for jump to work
	await get_tree().create_timer(0.1).timeout
	Input.action_release("ui_accept")

func _on_up_pressed() -> void:
	print("UP button pressed")
	Input.action_press("ui_up")

func _on_up_released() -> void:
	print("UP button released")
	Input.action_release("ui_up")

func _on_down_pressed() -> void:
	print("DOWN button pressed")
	Input.action_press("ui_down")

func _on_down_released() -> void:
	print("DOWN button released")
	Input.action_release("ui_down")
