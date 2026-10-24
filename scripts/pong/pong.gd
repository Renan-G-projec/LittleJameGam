# Ad Maiorem Dei Gloriam!
class_name Pong
extends Control

var score := [0, 0] # 0: Player, 1: CPU
const POINTS_TO_WIN := 3
const PONTUATION_BY_WIN := 20
const PONTUATION_BY_GOAL := 3

signal completed()
signal earned_points(points: int)
signal gameover()


## Point to cpu
func _on_score_left_body_entered(body: Node2D) -> void:
	if !(body is Ball): return
	score[1] += 1
	print(body)
	$BallTimer.start(1)
	$CPUScore.text = str(score[1])
	
	if score[1] >= POINTS_TO_WIN:
		gameover.emit()
	

func _on_score_right_body_entered(body: Node2D) -> void:
	if !(body is Ball): return
	score[0] += 1
	earned_points.emit(PONTUATION_BY_GOAL)
	$BallTimer.start(1)
	$PlayerScore.text = str(score[0])
	
	
	if score[0] >= POINTS_TO_WIN:
		earned_points.emit(PONTUATION_BY_WIN)
		completed.emit()
		print("SFhkdjlfjalksdfj")


func _on_ball_timer_timeout() -> void:
	$Ball.newBall()
