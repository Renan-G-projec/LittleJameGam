extends CharacterBody2D

const SPEED = 24.0
const JUMP_VELOCITY = -50.0
var gravity = 100

var isFacingRight = true

var canClimb = false

var ogGravity = gravity

var last_barrel

var is_dying = false

var animation_time: float = 0.0

@onready var _sprite = $Sprite2D

@onready var raycast = $RayCast2D

var last_direction

var haswon = false

var direction

signal completed()
signal earned_points(points: int)
signal gameover()

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$Sprite2D.frame = 1
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider.is_in_group("Barrel") and collider != last_barrel:
				print("dnada")
				last_barrel = collider
	else:
		$Sprite2D.frame = 0
	
	if Input.is_action_pressed("directional_up") and canClimb:
		velocity.y = -15
	elif Input.is_action_pressed("directional_down") and canClimb:
		velocity.y = 15
	elif canClimb:
		velocity.y = 0
	if canClimb == false:
		gravity = ogGravity
	else:
		gravity = 0
	# Handle jump.
	if Input.is_action_just_pressed("main_action") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("directional_left", "directional_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
	if not is_on_floor() and !canClimb:
			velocity.x = SPEED * _sprite.scale.x
		
	
	
	if direction > 0 and !isFacingRight:
		_sprite.scale.x *= -1
		isFacingRight = true
	if direction < 0 and isFacingRight:
		_sprite.scale.x *= -1
		isFacingRight = false

	move_and_slide()
	
	sway(delta)

func Won():
	earned_points.emit(20)
	completed.emit()
	haswon = true

func Die():
	if is_dying or haswon:
		return
	
	is_dying = true
	$Sprite2D.frame = 1
	
	var start_position = position
	var up_position = start_position + Vector2(0, -30)
	var down_position = start_position + Vector2(0, 80)
	
	while position.y > up_position.y:
		velocity.y = -60
		await get_tree().create_timer(0.01).timeout
	while position.y < down_position.y:
		position.y += 2
		await get_tree().create_timer(0.01).timeout
	gameover.emit()

func sway(delta: float) -> void:
	if is_on_floor():
		if velocity.length() > 0:
			animation_time += delta * 10.0
			_sprite.rotation = sin(animation_time) * 0.2 * direction
		else:
			_sprite.rotation = lerp_angle(rotation, 0.0, 0.1)
			animation_time = 0.0
