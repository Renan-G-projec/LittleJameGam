extends Control

var text_count = 0

var end = false
signal completed()

var texts = ["","Thank you for playing, press the action button to continue", 
"[wave amp=2 freq=8 connected=0][color=lime]Code by[/color][/wave]
KS Renan Danxo compiling.me

[wave amp=2 freq=8 connected=0][color=#89CFF0]Art by[/color][/wave]
Renan & Danxo

[wave amp=2 freq=8 connected=0][color=violet]Music by[/color][/wave]
Vini", ""]

@onready var text = $Text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = texts[text_count]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateTextCount()
	
	if text_count == 3 and not end:
		end = true
		TransitionManager.go_to_scene("res://scenes/menu.tscn")

func updateTextCount():
	if Input.is_action_just_pressed("main_action"):
		text_count += 1
		text.text = texts[text_count]
		await 1
		
