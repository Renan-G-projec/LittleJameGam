extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "meriu":
		body.canClimb = true

func _on_body_exited(body: Node2D) -> void:
	if body.name == "meriu":
		body.canClimb = false
