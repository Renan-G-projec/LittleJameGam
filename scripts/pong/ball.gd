extends CharacterBody2D

const startSpeed = 20
const accel = 2
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
	move_and_collide(dir * speed * delta)
