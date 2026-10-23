# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _feel_component: FeelComponent = $FeelComponent
@onready var _jump_input_buffer_timer: Timer = $JumpInputBufferTimer

var _jump_input_buffer: bool = false

func _physics_process(delta: float) -> void:
	_update_velocity(delta)

	move_and_slide()

func _update_velocity(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor() && _jump_input_buffer:
		_jump()

	if Input.is_action_just_pressed("ant_jump"):
		if is_on_floor():
			_jump()
		else:
			_jump_input_buffer = true
			_jump_input_buffer_timer.start()
			
	
	var direction := Input.get_axis("ant_move_left", "ant_move_right")
	if direction:
		velocity.x = direction * SPEED
		_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

func _jump() -> void:
	_jump_input_buffer = false
	velocity.y = JUMP_VELOCITY
	_feel_component.squash_animation(_sprite, Vector2(0.7, 1.3), 0.2)

func _on_jump_input_buffer_timer_timeout() -> void:
	_jump_input_buffer = false
