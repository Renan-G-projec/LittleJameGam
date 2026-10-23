extends StaticBody2D

var ball_pos : Vector2
var dist : int
var move_by : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ball_pos = $"../Ball".position
	dist = position.y - ball_pos.y
	if abs(dist) > 0:
		move_by = 200 * delta * (dist / abs(dist))
	
	position.y -= move_by
	
	position.y = clamp(position.y, 0, 80)
