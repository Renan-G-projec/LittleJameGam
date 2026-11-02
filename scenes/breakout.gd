# Ad Maiorem Dei Gloriam!
class_name Breakout
extends Control

var balls := 3
var score := [0, 0] # 0: Player, 1: CPU


signal completed()
signal earned_points(points: int)
signal gameover()

var has_won = false
var has_lose = false

## Point to cpu
func _on_score_left_body_entered(body: Node2D) -> void:
	if !(body is Ball2): return
	balls -= 1
	print(body)
	$BallTimer.start(0.1)
	

func _process(delta: float) -> void:
	if has_won or has_lose:
		return
	var blocks_left = get_tree().get_nodes_in_group("Blocks").size()
	if blocks_left <= 0:
		has_won = true
		completed.emit()
		Global.scr[3] = 5
		Global.scr[8] = 5
	if balls == 0:
		gameover.emit()
		Global.scr[3] = 5-blocks_left
		Global.scr[8] = 15
		has_lose = true


	


func _on_ball_timer_timeout() -> void:
	$Ball.newBall()


func _on_body_shape_entered(body: Node) -> void:
	pass # Replace with function body.
