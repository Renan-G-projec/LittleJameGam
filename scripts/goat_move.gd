extends CharacterBody2D



@export var speed = 200
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("directional_up"):
		position.y -= speed * delta
	if Input.is_action_pressed("directional_down"):
		position.y += speed * delta
		
	position.y = clamp(position.y, 0, 80)
	
