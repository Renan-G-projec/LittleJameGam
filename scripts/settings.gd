# Ad Maiorem Dei Gloriam!
extends Control

var _labels: Array[Node]
var _labels_original_text: Array[String] = []

var is_fullscreen = false

var _buttons_actions: Dictionary[int, Callable] = {
	# Fullscreen
	0: _full_screen_button,
	
	# Sound
	1: _go_back_button,
	
	# EXIT
	2: _go_back_button
}

@export var text_effect: String = "> [color=#93b4db][wave freq=2 connected=0]%s[/wave][/color]"

var _current_selected_label: int:
	set(new_label):
		_current_selected_label = clamp(new_label, 0, _labels.size() - 1)
		_activate_current_label()

func _ready() -> void:
	_labels = $MarginContainer/VBoxContainer.get_children()
	for label in _labels:
		_labels_original_text.push_back(label.text)
	_current_selected_label = 0
	
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		is_fullscreen = true
		var fullscreen_button = $MarginContainer/VBoxContainer/PlayLabel
		fullscreen_button.add_theme_color_override("font_color", Color.GREEN)

func _activate_current_label() -> void:
	for label in range(_labels.size()):
		_labels[label].text = _labels_original_text[label]

	_labels[_current_selected_label].text = text_effect % _labels[_current_selected_label].text

	_update_fullscreen_color()

func _process(delta: float) -> void:
	var current_wanting_label: int = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	if current_wanting_label != 0:
		$AudioStreamPlayer2D2.play()
		# Strectch effect on the previous option
		_labels[_current_selected_label].offset_transform_scale = Vector2(1.2, 0.8)
		var prev_selected_tween: Tween = _labels[_current_selected_label].create_tween()
		prev_selected_tween.tween_property(_labels[_current_selected_label], "offset_transform_position", Vector2.ZERO, 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		prev_selected_tween.tween_property(_labels[_current_selected_label], "offset_transform_scale", Vector2.ONE, 0.1)
		
		_current_selected_label += current_wanting_label
		
		# Same here 
		
		_labels[_current_selected_label].offset_transform_scale = Vector2(1.2, 0.8)
		var current_selected_tween: Tween = _labels[_current_selected_label].create_tween()
		current_selected_tween.tween_property(_labels[_current_selected_label], "offset_transform_position", Vector2(16, 0), 0.1).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		current_selected_tween.tween_property(_labels[_current_selected_label], "offset_transform_scale", Vector2.ONE, 0.1).set_trans(Tween.TRANS_CUBIC)
	
	if Input.is_action_just_pressed("ui_accept"):
		$AudioStreamPlayer.play()
		
		_labels[_current_selected_label].offset_transform_scale = Vector2(1.4, 0.6)
		_labels[_current_selected_label].offset_transform_pivot_ratio = Vector2(0.5, 0.5)
		_labels[_current_selected_label].create_tween().tween_property(_labels[_current_selected_label], "offset_transform_scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_CUBIC)
		
		await get_tree().create_timer(0.2).timeout
		_buttons_actions[_current_selected_label].call()
	
	if is_fullscreen:
		var fullscreen_button = $MarginContainer/VBoxContainer/PlayLabel
		fullscreen_button.add_theme_color_override("font_color", Color.GREEN)
	else:
		var fullscreen_button = $MarginContainer/VBoxContainer/PlayLabel
		fullscreen_button.add_theme_color_override("font_color", Color.WHITE)

func _full_screen_button() -> void:
	is_fullscreen = not is_fullscreen

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	_update_fullscreen_color()
	

func _go_back_button() -> void:
	var view_size: float = get_viewport_rect().size.x
	var num_frames: int = $Control/TextureRect.size.x / view_size
	
	TransitionManager.go_to_scene("res://scenes/menu.tscn")
	
	for frame in range(num_frames):
		$Control/TextureRect.position.x -= view_size
		
		# Go a little earlier
		await get_tree().create_timer(0.05).timeout

func _update_fullscreen_color() -> void:
	var fullscreen_button: RichTextLabel = $MarginContainer/VBoxContainer/PlayLabel

	var color := "#00ff00" if is_fullscreen else "#ffffff"
	var original_text: String = _labels_original_text[0]

	if _current_selected_label == 0:
		fullscreen_button.text = "> [color=%s][wave freq=2 connected=0]%s[/wave][/color]" % [color, original_text]
	else:
		fullscreen_button.text = "[color=%s]%s[/color]" % [color, original_text]
