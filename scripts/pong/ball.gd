class_name Ball
extends CharacterBody2D

const startSpeed = 40
const accel = 5
var speed : int
var dir : Vector2

var last_score = 1

@onready var sfx = $AudioStreamPlayer
@onready var sfx2 = $AudioStreamPlayer2

func _ready() -> void:
	pass
	
func newBall():
	position.x = 75
	position.y = 40
	speed = startSpeed
	dir = random_direction()

func random_direction():
	var newDirection := Vector2()
	newDirection.x = [1, -1].pick_random()
	newDirection.y = randf_range(-1, 1)
	return newDirection.normalized() * last_score

func _physics_process(delta: float) -> void:
	var collision = move_and_collide(dir * speed * delta)
	var collider
	if collision:
		collider = collision.get_collider()
		if collider == $"../Paddle" or collider == $"../CPU":
			speed += accel
			dir = dir.bounce(collision.get_normal())
			dir = dir + Vector2(0.0,randf_range(0,1))*sign(dir)
			dir *= randf_range(1,1.05)
			sfx.play()
		else:
			dir = dir.bounce(collision.get_normal())
			sfx2.play()

#CPU goal
func _on_score_left_body_entered(body: Node2D) -> void:
	if !(body is Ball): return
	last_score = 1

#Player goal
func _on_score_right_body_entered(body: Node2D) -> void:
	if !(body is Ball): return
	last_score = -1
