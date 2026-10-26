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

var has_won = false
var has_lose = false

## Point to cpu
func _on_score_left_body_entered(body: Node2D) -> void:
	if !(body is Ball2): return
	balls -= 1
	if balls == 0:
		gameover.emit()
		has_lose = true
	print(body)
	$BallTimer.start(0.1)
	

func _process(delta: float) -> void:
	if has_won or has_lose:
		return
	var blocks_left = get_tree().get_nodes_in_group("Blocks").size()
	if blocks_left <= 0:
		has_won = true
		earned_points.emit(PONTUATION_BY_WIN)
		completed.emit()

	

	


func _on_ball_timer_timeout() -> void:
	$Ball.newBall()


func _on_body_shape_entered(body: Node) -> void:
	pass # Replace with function body.
