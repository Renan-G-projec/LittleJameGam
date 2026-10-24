# Ad Maiorem Dei Gloriam!
extends CanvasLayer

@export var _current_minigame: int = 0:
	set(new_minigame):
		new_minigame = clamp(new_minigame, 0, _minigames_list.size())
		
		if _current_minigame == new_minigame: return
		
		_deactivate_current_minigame()
		_current_minigame = new_minigame
		_activate_current_minigame()

@onready var _player_initial_position: Vector2 = $Player.position

var pontuation: int = 0

# This variable is a array of all the minigames root. It is populated on _ready with every childremn of $Screen/MarginContainer/Screen
var _minigames_list: Array[Node] = []

func _ready():
	if !_minigames_list: 
		_minigames_list = $Screen/MarginContainer/Screen.get_children()
	
	for minigame in _minigames_list:
		minigame.process_mode = Node.PROCESS_MODE_DISABLED
	
	_minigames_list[_current_minigame].process_mode = Node.PROCESS_MODE_INHERIT
	_activate_current_minigame()

func go_to_next_minigame() -> void:
	TransitionManager.create_transition(0.1, 0.2, 0.1)
	
	if _current_minigame == _minigames_list.size() - 1:
		_finish_game()
	_current_minigame += 1
	
	$Player.position = _player_initial_position

func _on_minigame_completed() -> void:
	go_to_next_minigame()

func _on_minigame_gameover() -> void:
	go_to_next_minigame()

func _on_minigame_earned_points(points: int) -> void:
	pontuation += points

func _finish_game() -> void:
	TransitionManager.go_to_scene("res://scenes/menu.tscn")
	
func _activate_current_minigame() -> void:
	var current_minigame: Control = _minigames_list[_current_minigame]
	
	current_minigame.process_mode = Node.PROCESS_MODE_INHERIT
	current_minigame.visible = true
	
	if (current_minigame.has_signal("completed")):
		current_minigame.completed.connect(_on_minigame_completed)
	if (current_minigame.has_signal("earned_points")):
		current_minigame.earned_points.connect(_on_minigame_earned_points)
	if (current_minigame.has_signal("gameover")):
		current_minigame.gameover.connect(_on_minigame_gameover)

func _deactivate_current_minigame() -> void:
	var current_minigame: Control = _minigames_list[_current_minigame]
	
	current_minigame.process_mode = Node.PROCESS_MODE_DISABLED
	current_minigame.visible = false
	
	if (current_minigame.has_signal("completed")):
		current_minigame.completed.disconnect(_on_minigame_completed)
	if (current_minigame.has_signal("earned_points")):
		current_minigame.earned_points.disconnect(_on_minigame_earned_points)
	if (current_minigame.has_signal("gameover")):
		current_minigame.gameover.disconnect(_on_minigame_gameover)
