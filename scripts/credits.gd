extends Control
var b = true
var text_count = 0

var end = false
signal completed()

var texts = [["","Score: ","Thank you for playing, press the action button to continue", 
"[wave amp=2 freq=8 connected=0][color=lime]Code by[/color][/wave]
KS Renan Danxo compiling.me

[wave amp=2 freq=8 connected=0][color=#89CFF0]Art by[/color][/wave]
Renan & Danxo

[wave amp=2 freq=8 connected=0][color=violet]Music by[/color][/wave]
Vini", ""],["","Pontuação: ","Obrigado por jogar, aperte o botão de ação para continuar","[wave amp=2 freq=8 connected=0][color=lime]Código por[/color][/wave]\nKS Renan Danxo compiling.me\n\n[wave amp=2 freq=8 connected=0][color=#89CFF0]Arte por[/color][/wave]\nRenan & Danxo\n\n[wave amp=2 freq=8 connected=0][color=violet]Música por[/color][/wave]\nVini",""
]]

@onready var text = $Text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = texts[Global.lang][text_count]
	$Flags.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateTextCount()
	
	if text_count == 4 and not end:
		end = true
		TransitionManager.go_to_scene("res://scenes/menu.tscn")

func updateTextCount():
	if Input.is_action_just_pressed("main_action"):
		text_count += 1
		text.text = texts[Global.lang][text_count]
		await 1
	if text_count == 3:
		$Flags.show()
	if text_count == 1:
		$level.show()
		if b:
			b=false
			if Global.sup:
				$Text.text += "%2.2f "%((float(Global.scr[0])/float(Global.scr[6])+(Global.scr[1])/float(Global.scr[7])+(Global.scr[2])/float(Global.scr[8])+(Global.scr[3])/float(Global.scr[9])+(Global.scr[4])/float(Global.scr[10])+(Global.scr[5])/float(Global.scr[11]))*50.0/3.0)+"% \n\n\n\n\n\n\n\n\n"
			else:
				$Text.text += "%2.2f "%((float(Global.scr[0])/float(Global.scr[5])+(Global.scr[1])/float(Global.scr[6])+(Global.scr[2])/float(Global.scr[7])+(Global.scr[3])/float(Global.scr[8])+(Global.scr[4])/float(Global.scr[9]))*20.0)+"% \n\n\n\n\n\n\n\n\n"
			
	else:
		$level.visible = 0
