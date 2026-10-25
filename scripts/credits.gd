extends Control

var text_count = 0

var end = false
signal completed()

var texts = ["","Thank you for playing, press the action button to continue", 
"Code by
KS Renan Danxo compiling.me

Art by
Renan & Danxo

Musics by
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
		
