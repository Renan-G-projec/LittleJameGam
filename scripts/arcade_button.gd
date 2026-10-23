# Ad Maiorem Dei Gloriam!
class_name ArcadeButton
extends Node2D

@export var directional_action: InputEventAction

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var feel_component: FeelComponent = $FeelComponent

var _active: bool = true

func _activate() -> void:
	feel_component.squash_animation(sprite, Vector2(1.1, 0.9))
	sprite.frame = 1
	_active = true
	directional_action.pressed = true

func _deactivate() -> void:
	feel_component.squash_animation(sprite, Vector2(0.9, 1.1))
	sprite.frame = 0
	_active = false
	directional_action.pressed = false

func _on_area_2d_body_entered(_body: Node2D) -> void:
	_activate()

func _on_area_2d_body_exited(_body: Node2D) -> void:
	_deactivate()
