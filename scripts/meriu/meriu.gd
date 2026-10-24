extends CharacterBody2D


const SPEED = 24.0
const JUMP_VELOCITY = -50.0
const gravity = 100

var isFacingRight = true

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		$Sprite2D.frame = 1
	else:
		$Sprite2D.frame = 0

	# Handle jump.
	if Input.is_action_just_pressed("main_action") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("directional_left", "directional_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	if direction > 0 and !isFacingRight:
		self.scale.x = -1
		isFacingRight = true
	if direction < 0 and isFacingRight:
		self.scale.x = -1
		isFacingRight = false

	move_and_slide()
