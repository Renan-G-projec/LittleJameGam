# Ad Maiorem Dei Gloriam!
extends CanvasLayer

@export var _minigames_list: Array[Node] = []
@export var _current_minigame: int = 0

@onready var _player_initial_position: Vector2 = $Player.position

var pontuation: int = 0

func _ready():
	if !_minigames_list: 
		_minigames_list = $Screen/MarginContainer/Screen.get_children()
	
	for minigame in _minigames_list:
		minigame.process_mode = Node.PROCESS_MODE_DISABLED
	
	_minigames_list[_current_minigame].process_mode = Node.PROCESS_MODE_INHERIT
	var current_minigame: Control = _minigames_list[_current_minigame]
	current_minigame.process_mode = Node.PROCESS_MODE_INHERIT
	current_minigame.visible = true
	if (current_minigame.has_signal("completed")):
		current_minigame.completed.connect(_on_minigame_completed)
	if (current_minigame.has_signal("earned_points")):
		current_minigame.earned_points.connect(_on_minigame_earned_points)
	if (current_minigame.has_signal("gameover")):
		current_minigame.gameover.connect(_on_minigame_gameover)

func go_to_next_minigame() -> void:
	TransitionManager.create_transition()
	
	var prev_minigame: Control = _minigames_list[_current_minigame]
	prev_minigame.visible = false
	if (prev_minigame.has_signal("completed")):
		prev_minigame.completed.disconnect(_on_minigame_completed)
	if (prev_minigame.has_signal("earned_points")):
		prev_minigame.earned_points.disconnect(_on_minigame_earned_points)
	if (prev_minigame.has_signal("gameover")):
		prev_minigame.gameover.disconnect(_on_minigame_gameover)
		
	prev_minigame.process_mode = Node.PROCESS_MODE_DISABLED
	
	_current_minigame += 1
	
	if _minigames_list.size() <= _current_minigame:
		_finish_game()
		return

	var current_minigame: Control = _minigames_list[_current_minigame]
	current_minigame.process_mode = Node.PROCESS_MODE_INHERIT
	current_minigame.visible = true
	if (current_minigame.has_signal("completed")):
		current_minigame.completed.connect(_on_minigame_completed)
	if (current_minigame.has_signal("earned_points")):
		current_minigame.earned_points.connect(_on_minigame_earned_points)
	if (current_minigame.has_signal("gameover")):
		current_minigame.gameover.connect(_on_minigame_gameover)
	$Player.position = _player_initial_position

func _on_minigame_completed() -> void:
	return

func _on_minigame_gameover() -> void:
	go_to_next_minigame()

func _on_minigame_earned_points(points: int) -> void:
	pontuation += points

func _finish_game() -> void:
	TransitionManager.go_to_scene("res://scenes/menu.tscn")
