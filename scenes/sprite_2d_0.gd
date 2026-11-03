extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if int(self.name) == 5:
		if Global.sup:
			$Text.text = str(Global.scr[int(self.name)])+"/"+str(Global.scr[int(self.name)+5++int(Global.sup)])
		else:
			$Text.text = "??????"
	else:
		$Text.text = str(Global.scr[int(self.name)])+"/"+str(Global.scr[int(self.name)+5++int(Global.sup)])
	pass
