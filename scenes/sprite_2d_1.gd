extends Sprite2D
var i = 0
var l = 0.0
var p = 5.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	i = int(str(self.name)[8])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	l += delta
	
	if l > p:
		l -= p
		i+= 1
		i %= 5
		p = randf_range(0.1,0.4)
		region_rect = Rect2(0,36*i,53,36)
	pass
