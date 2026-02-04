extends CanvasLayer
# Title Screen - Game start screen with title and start button
# Recreates the web version's title screen

@onready var panel: Panel = $Panel
@onready var title_label: Label = $Panel/VBoxContainer/TitleLabel
@onready var start_button: Button = $Panel/VBoxContainer/StartButton

@export var game_title: String = "Our Journey"
@export var show_on_ready: bool = true

signal game_started

func _ready() -> void:
	if title_label:
		title_label.text = game_title
	
	if start_button:
		start_button.pressed.connect(_on_start_pressed)
	
	if show_on_ready:
		show_title()
	else:
		hide_title()

func show_title() -> void:
	panel.visible = true
	get_tree().paused = true

func hide_title() -> void:
	panel.visible = false
	get_tree().paused = false

func _on_start_pressed() -> void:
	hide_title()
	game_started.emit()
