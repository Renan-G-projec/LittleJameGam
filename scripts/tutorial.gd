extends Control

var text_count = 0

var down = false
var up = false
var left = false
var right = false
var end = false
signal completed()

var texts = [["Try pressing that big button over there, you can use the arrow keys or a controller", 
"now let we see some moves, try pressing the arrows. did you know something happens when you press SHIFT after jumping", 
"You are on fire, press the big button again to start playing", ""],["Tente apertar aquele botãozão ali, você pode usar as setas do teclado ou um controle","Agora mostra seu gingado, tente apertar essas setas. Você sabia que algo acontece quando tu aperta SHIFT no ar?","Tá mandando vê, aperte o botão grande de novo para começar a jogar",""]]

@onready var text = $Text
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text.text = texts[Global.lang][text_count]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if text_count == 0 and Input.is_action_just_pressed("main_action"):
		text_count += 1
	if text_count == 1:
		if Input.is_action_just_pressed("directional_down"):
			down = true
		if Input.is_action_just_pressed("directional_up"):
			up = true
		if Input.is_action_just_pressed("directional_left"):
			left = true
		if Input.is_action_just_pressed("directional_right"):
			right = true
		if left and right and down and up:
			text_count += 1
	if text_count == 2 and Input.is_action_just_pressed("main_action"):
		text_count += 1
	text.text = texts[Global.lang][text_count]
	
	if text_count >= 3 and not end:
		Global.tutorial_completed = true
		completed.emit()
		end = true
