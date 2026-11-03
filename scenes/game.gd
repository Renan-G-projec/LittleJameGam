# Ad Maiorem Dei Gloriam!
class_name Game
extends Control
signal completed()
signal gameover()
var gj := false
var head := Vector2i(3,4)
var snek := [Vector2i(3,4)]
var t := 180.0
var p := 0.3
var Next := Vector2i.RIGHT

func _ready():
	if not Global.sup:
		queue_free()
	pass

func _process(delta: float) -> void:
	if not gj:
		t-=delta
		if t < 0:
			gameover.emit()
	$RichTextLabel.text = "%2s:%2.2f"%[int(t)/60,t-60*(int(t)/60)]
	pass
	



func _on_ant_aaaaa() -> void:
	pass # Replace with function body.


func _on_fla_body_entered(body: Node2D) -> void:
		Global.scr[5] = int(t)/60 + 1
		Global.scr[11] = 3
		gj = true
		completed.emit()

	
		pass # Replace with function body.
