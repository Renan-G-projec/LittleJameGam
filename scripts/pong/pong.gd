extends Control

var score := [0, 0]# 0: Player, 1: CPU

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_score_left_body_entered(body: Node2D) -> void:
	print("dadada")
	score[1] += 1
	$BallTimer.start(1)

func _on_score_right_body_entered(body: Node2D) -> void:
	print("wswswsww")
	score[0] += 1
	$BallTimer.start(1)


func _on_ball_timer_timeout() -> void:
	$Ball.newBall()
