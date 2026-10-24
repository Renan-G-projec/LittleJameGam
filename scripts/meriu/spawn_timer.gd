extends Timer

@export var min_time: float = 2.0
@export var max_time: float = 4.0

var barrel_scene = preload("res://scenes/konkey dong/barrel.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup()

func setup():
	var timeout_time = randf_range(min_time, max_time)
	self.wait_time = timeout_time
	start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timeout() -> void:
	setup()
	spawnBarrel()

func spawnBarrel():
	var barrel = barrel_scene.instantiate()
	var parent = self.get_parent()
	parent.add_child(barrel)
