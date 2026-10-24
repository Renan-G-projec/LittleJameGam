extends Sprite2D
var l := 0
var r := 0
var inp := "directional_up"
var active := false
var h := 0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	match str(self.name)[0]:
		"l":
			l = 0
			r = 0
			inp = "directional_left"
		"r":
			l = 3
			r = 3
			inp = "directional_right"
		"u":
			l = 2
			r = 2
			inp = "directional_up"
		"d":
			r = 1
			l = 1
			inp = "directional_down"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	h+=delta
	if h > 0.5: h-=0.5; l+=1
	if l ==4: l=0
	if Input.is_action_pressed(inp):
		active = true
	for i in ["directional_left","directional_right","directional_up","directional_down","main_action"]:
		if i != inp and Input.is_action_pressed(i):
			active = false
	if active:
		region_rect = Rect2(56,l*19,56,19)
		Global.ans = r+1
	else:
		region_rect = Rect2(0,l*19,56,19)
	pass
