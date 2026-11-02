extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.scr[6] = 3
	pass


func _on_body_entered(body: Node2D) -> void:
	if body.name == "meriu":
		body.Won()
		Global.scr[1] = 3
