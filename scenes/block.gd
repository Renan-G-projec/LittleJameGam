extends RigidBody2D
var po = Vector2.ONE
var ball_pos : Vector2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = INF
	po = position
	if !Global.hard and int(str(self.name)[5]) in range(5,10):
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in get_colliding_bodies():
		if str(i.name) == "Ball":
			visible = false
	position = po
	rotation = 0
	pass

func _on_body_shape_entered(body: Node) -> void:
	get_contact_count()
	visible = false



func _on_body_entered(body: Node) -> void:
	visible = false
	pass # Replace with function body.
