# Ad Maiorem Dei Gloriam!
extends Control

var _labels: Array[Node]
var _labels_original_text: Array[String] = []

@export var text_effect: String = "[color=lime][wave  freq=3 connected=0]%s[/wave][/color]"

var _current_selected_label: int:
	set(new_label):
		_current_selected_label = clamp(new_label, 0, _labels.size() - 1)
		_activate_current_label()

func _ready() -> void:
	_labels = $MarginContainer/VBoxContainer.get_children()
	for label in _labels:
		_labels_original_text.push_back(label.text)
	_current_selected_label = 0

func _activate_current_label() -> void:
	for label in range(0, _labels.size()):
		_labels[label].text = _labels_original_text[label]
	_labels[_current_selected_label].text = text_effect % _labels[_current_selected_label].text

func _process(delta: float) -> void:
	var current_wanting_label: int = int(Input.is_action_just_pressed("ui_down")) - int(Input.is_action_just_pressed("ui_up"))
	if current_wanting_label != 0:
		_labels[_current_selected_label].create_tween().tween_property(_labels[_current_selected_label], "offset_transform_position", Vector2.ZERO, 0.2).set_trans(Tween.TRANS_CUBIC)
		_current_selected_label += current_wanting_label
		_labels[_current_selected_label].create_tween().tween_property(_labels[_current_selected_label], "offset_transform_position", Vector2(16, 0), 0.2).set_trans(Tween.TRANS_CUBIC)
