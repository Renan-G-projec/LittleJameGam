extends Control
var q:=[["1. 2+2?","1","2","3","4",4],["2. This is a question.","True","False","What?","Maybe",2],["3. If you are in HackClub, what are you?","Teenager","Smart","Silly","All of the above",4],["  1) This is a question","WRONG","RIght","^",">",2],["  1) This is a question","WRONG","RIght","^",">",2],["  ","1","2","3","4",5]]
var p:= 0
var score1 := 0
var score2 := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text = "[wave amp=8.0 freq=2.0 connected=0]" + q[p][0]
	$l/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[p][1]
	$d/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[p][2]
	$u/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[p][3]
	$r/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[p][4]
	$score.text = "[color=2c2]"+str(score1)+"[/color] / [color=c22]"+str(score2)+"[/color]"
	if Global.ans != 0 and Input.is_action_pressed("main_action"):
		if Global.ans == q[p][5]:
			score1 += 1
			Global.ans = 0
		else:
			score2 += 1
			Global.ans = 0
		p+=1
	pass
