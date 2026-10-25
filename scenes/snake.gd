# Ad Maiorem Dei Gloriam!
class_name Snake
extends Control
signal completed()
signal gameover()
var head := Vector2i(3,4)
var fruit := Vector2i(12,4)
var snek := [Vector2i(3,4)]
var t := 0.0
var Next := Vector2i.RIGHT

func _process(delta: float) -> void:
	if Input.is_action_pressed("directional_down"):
		Next = Vector2i.DOWN
	if Input.is_action_pressed("directional_up"):
		Next = Vector2i.UP
	if Input.is_action_pressed("directional_right"):
		Next = Vector2i.RIGHT
	if Input.is_action_pressed("directional_left"):
		Next = Vector2i.LEFT
	if t > 0.5:
		t -= 0.5
		if $TileMapLayer.get_cell_atlas_coords(head + Next) != Vector2i(19,15):
			if $TileMapLayer.get_cell_atlas_coords(head + Next) == Vector2i(2,9):
				head += Next
				snek.append(head)
				snek.pop_back()
			else:
				gameover.emit()
		else:
			head += Next
			fruit = Vector2i(randi_range(0,16),randi_range(0,8))
			while fruit in snek:
				fruit = Vector2i(randi_range(0,16),randi_range(0,8))
			snek.append(head)

	t+=delta
	for i in range(17):
		for j in range(9):
			$TileMapLayer.set_cell(Vector2i(i,j),0,Vector2i(2,9))
	
	for i in snek:
		$TileMapLayer.set_cell(i,0,Vector2i(14,16))
	
	$TileMapLayer.set_cell(fruit,0,Vector2i(19,15))
