# Ad Maiorem Dei Gloriam!
class_name Breakout
extends Control

var balls := 3
var score := [0, 0] # 0: Player, 1: CPU
const POINTS_TO_WIN := 3
const PONTUATION_BY_WIN := 20
const PONTUATION_BY_GOAL := 3

signal completed()
signal earned_points(points: int)
signal gameover()


## Point to cpu
func _on_score_left_body_entered(body: Node2D) -> void:
	if !(body is Ball2): return
	balls -= 1
	if balls == 0:
		gameover.emit()
	print(body)
	$BallTimer.start(1)

	

	


func _on_ball_timer_timeout() -> void:
	$Ball.newBall()


func _on_body_shape_entered(body: Node) -> void:
	pass # Replace with function body.
