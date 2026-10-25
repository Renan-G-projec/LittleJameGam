# Ad Maiorem Dei Gloriam!
extends Control

var _labels: Array[Node]
var _labels_original_text: Array = [["Play","Settings","Quit"],["Jogar","Configs","Quitar"]]

var _buttons_actions: Dictionary[int, Callable] = {
	# PLAY
	0: _play_game_button,
	
	# SETTINGS
	1: _settings_button,
	
	# EXIT
	2: (func() -> void: get_tree().quit())
}

@export var text_effect: String = "> [color=#93b4db][wave freq=2 connected=0]%s[/wave][/color]"

var _current_selected_label: int:
	set(new_label):
		_current_selected_label = clamp(new_label, 0, _labels.size() - 1)
		_activate_current_label()

func _ready() -> void:
	_labels = $MarginContainer/VBoxContainer.get_children()
	_current_selected_label = 0

func _activate_current_label() -> void:
	for label in range(0, _labels.size()):
		_labels[label].text = _labels_original_text[Global.lang][label]
	_labels[_current_selected_label].text = text_effect % _labels[_current_selected_label].text

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

func _play_game_button() -> void:
	var view_size: float = get_viewport_rect().size.x
	var num_frames: int = $Control/TextureRect.size.x / view_size
	
	TransitionManager.go_to_scene("res://scenes/main.tscn")
	
	for frame in range(num_frames):
		$Control/TextureRect.position.x -= view_size
		
		# Go a little earlier
		await get_tree().create_timer(0.05).timeout
		
func _settings_button() -> void:
	var view_size: float = get_viewport_rect().size.x
	var num_frames: int = $Control/TextureRect.size.x / view_size
	
	TransitionManager.go_to_scene("res://scenes/settings.tscn")
	
	for frame in range(num_frames):
		$Control/TextureRect.position.x -= view_size
		
		# Go a little earlier
		await get_tree().create_timer(0.05).timeout
