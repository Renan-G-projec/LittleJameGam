extends StaticBody2D

var ball_pos : Vector2
var dist : int
var move_by : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var ball = $"../Ball"

	var dist = ball.global_position.y - global_position.y
	var step = 50.0 * delta

	if abs(dist) > step:
		global_position.y += sign(dist) * step
	else:
		global_position.y = ball.global_position.y
	
	position.y = clamp(position.y, 0.0, 80.0)
