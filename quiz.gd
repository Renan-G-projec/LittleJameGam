extends Control
var q:=[[[". 2+2?","1","2","3","4",4],[". This is a question.","True","False","What?","Maybe",2],[". If you are in HackClub, what are you?","Teenager","Smart","Silly","All of the above",4],[". If a³-1 = 0, |a| = ?","1","-1","0","i",1],[". What is the name of this game?","AntGames","LilGames","AntCade","LilCade",3],[". What is a Blåhaj?","Hammerhead","Blue","Lemon","Mako",2],[". If you're happy and you know it...","Clap Clap!","Hug!","Boop!","All of the above",4],[". [3*9-3*3]%3?","0","18","1","WTH",1],[". Where is Tarsila do Amaral from?","USA","France","Brazil","Portugal",3],["How do you center a div?","margin: auto;","text-align: center;","display: flex; justify-content: center; align-items: center;","Is it possible?",4],[". Press ¬Up","Left","Down","Up","Right",2]],[[". 2+2?", "1", "2", "3", "4", 4],[". Isto é uma pergunta.", "Verdadeiro", "Falso", "Quê?", "Talvez", 2],[". Se você está no HackClub, o que você é?", "Adolescente", "Esperto", "Bobo", "Todas as anteriores", 4],[". Se a³-1 = 0, |a| = ?", "1", "-1", "0", "i", 1],[". Qual é o nome deste jogo?", "AntGames", "LilGames", "AntCade", "LilCade", 3],[". O que é um Blåhaj?", "Martelo", "Azul", "Lima", "Mako", 2],[". Se você está contente...", "Bata palmas!", "Abraço!", "Toque no nariz!", "Todas as anteriores", 4],[". [3*9-3*3]%3 = ?", "0", "18", "1", "WTH", 1],[". De onde é a Tarsila do Amaral?", "EUA", "França", "Brasil", "Portugal", 3],["Como você centraliza uma div?", "margin: auto;", "text-align: center;", "display: flex; justify-content: center; align-items: center;", "Isso é possível?", 4],[". Pressione ¬Cima", "Esquerda", "Baixo", "Cima", "Direita", 2]]]
var p:= 0
var l:= 1
var m:=[]
signal completed()
signal gameover()
var score1 := 0
var score2 := 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	p = 0
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$RichTextLabel.text = "[wave amp=8.0 freq=2.0 connected=0]" +str(l)+ q[Global.lang][p][0]
	$l/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[Global.lang][p][1]
	$d/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[Global.lang][p][2]
	$u/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[Global.lang][p][3]
	$r/tex.text = "[wave amp=8.0 freq=2.0 connected=0]" +q[Global.lang][p][4]
	$score.text = "[color=2c2]"+str(score1)+"[/color] / [color=c22]"+str(score2)+"[/color]"
	if Global.ans != 0 and Input.is_action_pressed("main_action"):
		if Global.ans == q[Global.lang][p][5]:
			score1 += 1
			Global.ans = 0
		else:
			score2 += 1
			Global.ans = 0
		m.append(p)
		if l == 10:
			if score1<7:
				gameover.emit()
			else:
				completed.emit()

		while p in m:
			p = randi_range(0,len(q[0])-1)
		l+=1
	pass
