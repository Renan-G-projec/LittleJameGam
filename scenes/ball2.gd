class_name Ball2
extends CharacterBody2D

var active = false
const startSpeed = 60
const accel = 5
var speed : int
var dir : Vector2

@onready var sfx = $AudioStreamPlayer
@onready var sfx2 = $AudioStreamPlayer2

func _ready() -> void:
	pass
	
func newBall():
	position = Vector2(68,50)
	speed = startSpeed
	active = false
	dir = random_direction()

func random_direction():
	var newDirection := Vector2()
	newDirection.x = [1, -1].pick_random()
	newDirection.y = randf_range(0, 2)
	return newDirection.normalized()

func _physics_process(delta: float) -> void:
	if active:
		var collision = move_and_collide(dir * speed * delta)
		var collider
		if collision:
			collider = collision.get_collider()
			if collider == $"../Paddle" or collider == $"../CPU":
				speed += accel
				dir = dir.bounce(collision.get_normal())
				sfx.play()
			elif collider.is_in_group("Blocks"):
				dir = dir.bounce(collision.get_normal())
				sfx2.play()
				collider.free()
			else:
				dir = dir.bounce(collision.get_normal())
				sfx2.play()
	else:
		position = $"../Paddle".position + 10*Vector2.UP
		if Input.is_action_pressed("main_action"):
			active = true
