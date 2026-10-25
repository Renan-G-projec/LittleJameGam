
# Ad Maiorem Dei Gloriam!
extends Control

var _labels: Array[RichTextLabel] = []
var _labels_original_text: Array[String] = []

var is_fullscreen := false
var _is_adjusting_volume := false

const VOLUME_INDEX := 1

@export var audio_bus_name: String = "Master"
@export var text_effect: String = "> [color=#93b4db][wave freq=2 connected=0]%s[/wave][/color]"

@onready var _volume_slider: HSlider = $MarginContainer/VBoxContainer/VolumeSlider
@onready var _fullscreen_label: RichTextLabel = $MarginContainer/VBoxContainer/FullScreenLabel

var _buttons_actions: Dictionary[int, Callable] = {
	0: _full_screen_button,
	2: _go_back_button
}

var _current_selected_label: int = 0:
	set(new_label):
		if _labels.is_empty():
			return

		_current_selected_label = clampi(new_label, 0, _labels.size() - 1)
		_activate_current_label()


func _ready() -> void:
	# Only collect RichTextLabels.
	_labels.clear()

	for child in $MarginContainer/VBoxContainer.get_children():
		if child is RichTextLabel:
			_labels.append(child)

	for label in _labels:
		_labels_original_text.append(label.text)

	is_fullscreen = (
		DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	)

	# Initialize the slider from the current audio bus volume.
	var bus_index := AudioServer.get_bus_index(audio_bus_name)
	if bus_index != -1:
		_volume_slider.value = db_to_linear(
			AudioServer.get_bus_volume_db(bus_index)
		)

	_volume_slider.value_changed.connect(_on_volume_slider_value_changed)

	_activate_current_label()


func _activate_current_label() -> void:
	for i in range(_labels.size()):
		_labels[i].text = _labels_original_text[i]

	# Highlight the selected label.
	_labels[_current_selected_label].text = (
		text_effect % _labels_original_text[_current_selected_label]
	)

	# Update fullscreen color and volume selection.
	_update_fullscreen_color()

	_is_adjusting_volume = (_current_selected_label == VOLUME_INDEX)


func _process(_delta: float) -> void:
	var navigation := (
		int(Input.is_action_just_pressed("ui_down"))
		- int(Input.is_action_just_pressed("ui_up"))
	)

	if navigation != 0:
		$AudioStreamPlayer2D2.play()

		# Animate the previously selected label.
		var previous_label := _labels[_current_selected_label]
		previous_label.offset_transform_scale = Vector2(1.2, 0.8)

		var previous_tween := previous_label.create_tween()
		previous_tween.tween_property(
			previous_label, "offset_transform_position",
			Vector2.ZERO, 0.1
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		previous_tween.tween_property(
			previous_label, "offset_transform_scale",
			Vector2.ONE, 0.1
		)

		_current_selected_label += navigation

		# Animate the newly selected label.
		var current_label := _labels[_current_selected_label]
		current_label.offset_transform_scale = Vector2(1.2, 0.8)

		var current_tween := current_label.create_tween()
		current_tween.tween_property(
			current_label, "offset_transform_position",
			Vector2(16, 0), 0.1
		).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		current_tween.tween_property(
			current_label, "offset_transform_scale",
			Vector2.ONE, 0.1
		).set_trans(Tween.TRANS_CUBIC)

	if _current_selected_label == VOLUME_INDEX:
		if Input.is_action_just_pressed("ui_left"):
			_volume_slider.value = maxf(
				_volume_slider.min_value,
				_volume_slider.value - 0.05
			)
		elif Input.is_action_just_pressed("ui_right"):
			_volume_slider.value = minf(
				_volume_slider.max_value,
				_volume_slider.value + 0.05
			)

	if Input.is_action_just_pressed("ui_accept"):
		$AudioStreamPlayer.play()

		var selected_label := _labels[_current_selected_label]
		selected_label.offset_transform_pivot_ratio = Vector2(0.5, 0.5)
		selected_label.offset_transform_scale = Vector2(1.4, 0.6)

		var tween := selected_label.create_tween()
		tween.tween_property(
			selected_label, "offset_transform_scale",
			Vector2.ONE, 0.2
		).set_trans(Tween.TRANS_CUBIC)

		# Volume is adjusted with left/right, not Enter.
		if _buttons_actions.has(_current_selected_label):
			await get_tree().create_timer(0.2).timeout
			_buttons_actions[_current_selected_label].call()


func _full_screen_button() -> void:
	is_fullscreen = not is_fullscreen

	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

	_update_fullscreen_color()


func _sound() -> void:
	pass


func _go_back_button() -> void:
	var view_size: float = get_viewport_rect().size.x
	var num_frames: int = int(
		ceil($Control/TextureRect.size.x / view_size)
	)

	TransitionManager.go_to_scene("res://scenes/menu.tscn")

	for _frame in range(num_frames):
		$Control/TextureRect.position.x -= view_size
		await get_tree().create_timer(0.05).timeout


func _update_fullscreen_color() -> void:
	var color := "#00ff00" if is_fullscreen else "#ffffff"
	var original_text := _labels_original_text[0]

	if _current_selected_label == 0:
		_fullscreen_label.text = (
			"> [color=%s][wave freq=2 connected=0]%s[/wave][/color]"
			% [color, original_text]
		)
	else:
		_fullscreen_label.text = "[color=%s]%s[/color]" % [
			color, original_text
		]


func _on_volume_slider_value_changed(value: float) -> void:
	var bus_index := AudioServer.get_bus_index(audio_bus_name)

	if bus_index == -1:
		return

	if value <= 0.0:
		AudioServer.set_bus_mute(bus_index, true)
	else:
		AudioServer.set_bus_mute(bus_index, false)
		AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))
