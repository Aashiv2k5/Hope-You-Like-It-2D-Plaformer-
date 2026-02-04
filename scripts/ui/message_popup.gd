extends CanvasLayer
# Message Popup - Displays heart collection messages
# Recreates the web version's message popup UI

@onready var panel: Panel = $Panel
@onready var message_label: Label = $Panel/MarginContainer/VBoxContainer/MessageLabel
@onready var continue_button: Button = $Panel/MarginContainer/VBoxContainer/ContinueButton

var is_showing: bool = false

func _ready() -> void:
	# Allow this UI to work while game is paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	hide_popup()
	
	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)

func show_message(message: String) -> void:
	if is_showing:
		return
	
	is_showing = true
	message_label.text = message
	
	# Make sure panel is visible and set initial alpha
	panel.modulate.a = 0
	panel.visible = true
	visible = true
	
	# Pause game
	get_tree().paused = true
	
	# Fade in animation (must set tween to process always too)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(panel, "modulate:a", 1.0, 0.3)

func hide_popup() -> void:
	if not is_showing:
		return
	
	# Fade out animation (must process during pause)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(panel, "modulate:a", 0.0, 0.3)
	await tween.finished
	
	panel.visible = false
	visible = false
	is_showing = false
	
	# Resume game
	get_tree().paused = false

func _on_continue_pressed() -> void:
	hide_popup()

func is_popup_showing() -> bool:
	return is_showing
