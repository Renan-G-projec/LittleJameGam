extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	var direction = (int(Input.is_action_pressed("directional_right")) - int(Input.is_action_pressed("directional_left")))

	# Handle jump.
	if Input.is_action_just_pressed("directional_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	velocity.x = direction * SPEED

	move_and_slide()
