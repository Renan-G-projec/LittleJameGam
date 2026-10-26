extends StaticBody2D
var po = position
var ball_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !Global.hard and int(str(self.name)[5]+str(self.name)[6]) in range(5,15):
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
