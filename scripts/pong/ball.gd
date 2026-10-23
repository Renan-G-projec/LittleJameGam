extends CharacterBody2D

const startSpeed = 40
const accel = 5
var speed : int
var dir : Vector2

func _ready() -> void:
	newBall()
	
func newBall():
	position.x = 45
	position.y = randi_range(10, 90 - 10)
	speed = startSpeed
	dir = random_direction()

func random_direction():
	var newDirection := Vector2()
	newDirection.x = [1, -1].pick_random()
	newDirection.y = randf_range(-1, 1)
	return newDirection.normalized()

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		if collider == $"../Paddle" or collider == $"../CPU":
			speed += accel
			dir = dir.bounce(collision.get_normal())
		else:
			dir = dir.bounce(collision.get_normal())
