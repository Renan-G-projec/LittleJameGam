# Ad Maiorem Dei Gloriam!
class_name Player
extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -300.0
const DASH_VELOCITY = 800.0

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var _feel_component: FeelComponent = $FeelComponent
@onready var _jump_input_buffer_timer: Timer = $JumpInputBufferTimer

@onready var sfx: AudioStreamPlayer2D = $AudioStreamPlayer2D

var animation_time: float = 0.0

var direction = null

var _jump_input_buffer: bool = false
var _can_dash: bool = false

var _facing_direction: int = 1

var was_airbourne = false

func _physics_process(delta: float) -> void:
	_update_velocity(delta)
	move_and_slide()
	
	sway(delta)

func _update_velocity(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta
		was_airbourne = true
	else:
		if was_airbourne:
			was_airbourne = false
			_feel_component.squash_animation(_sprite, Vector2(1.3, 0.8), 0.2)
			
	
	if is_on_floor() && _jump_input_buffer:
		_jump()

	if Input.is_action_just_pressed("ant_jump"):
		if is_on_floor():
			_jump()
		else:
			_jump_input_buffer = true
			_jump_input_buffer_timer.start()
			
	
	direction = Input.get_axis("ant_move_left", "ant_move_right")
	if direction:
		if abs(velocity.x) < abs(SPEED * direction): 
			velocity.x = direction * SPEED
		else:
			velocity.x = lerpf(velocity.x, SPEED * direction, delta * 15)
			
		_facing_direction = sign(direction)
		_sprite.flip_h = direction < 0
	else:
		velocity.x = lerpf(velocity.x, 0, delta * 15)
		
	
	if _can_dash && Input.is_action_just_pressed("ant_dash"):
		_dash(DASH_VELOCITY, _facing_direction)

func _jump() -> void:
	_jump_input_buffer = false
	_can_dash = true
	velocity.y = JUMP_VELOCITY
	_feel_component.squash_animation(_sprite, Vector2(0.5, 1.5), 0.4)
	sfx.pitch_scale = randf_range(1, 1.2)
	sfx.play()

func _dash(force: float, direction: int) -> void:
	if !_can_dash: return
	_can_dash = false
	
	velocity.x = force * direction
	_sprite.flip_h = direction < 0
	_feel_component.squash_animation(_sprite, Vector2(1.5, 0.5), 0.4)
	
func _on_jump_input_buffer_timer_timeout() -> void:
	_jump_input_buffer = false
### ANIMATION ###
func sway(delta: float) -> void:
	if is_on_floor():
		if velocity.length() > 0.99:
			animation_time += delta * 10.0
			_sprite.rotation = sin(animation_time) * 0.2 * direction
		else:
			_sprite.rotation = lerp_angle(rotation, 0.0, 0.1)
			animation_time = 0.0
	else:
		if velocity.length() > 0:
			animation_time += delta * 10.0
			_sprite.rotation = sin(animation_time) * 0.2
		else:
			_sprite.rotation = lerp_angle(rotation, 0.0, 0.1)
			animation_time = 0.0
