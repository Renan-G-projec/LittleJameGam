extends StaticBody2D

@export var speed = 130
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("directional_left"):
		position.x -= speed * delta
	if Input.is_action_pressed("directional_right"):
		position.x += speed * delta
		
	position.x = clamp(position.x, 9, 137)
	
