# Ad Maiorem Dei Gloriam!
extends CanvasLayer
var s := false
signal completed()
@export var _current_minigame: int = 0:
	set(new_minigame):
		new_minigame = clamp(new_minigame, 0, _minigames_list.size() - 1)
		
		if _current_minigame == new_minigame: return
		_current_minigame = new_minigame
		_activate_current_minigame()

@onready var _player_initial_position: Vector2 = $Player.position

var pontuation: int = 0

# This variable is a array of all the minigames root. It is populated on _ready with every childremn of $Screen/MarginContainer/Screen
var _minigames_list: Array[Node] = []
var _screenshake_force: float = 0.0
var _screenshake_active: bool = false

func _ready():
	if !_minigames_list: 
		_minigames_list = $Screen/MarginContainer/Screen.get_children()
	
	for minigame in _minigames_list:
		minigame.process_mode = Node.PROCESS_MODE_DISABLED
	
	_minigames_list[_current_minigame].process_mode = Node.PROCESS_MODE_INHERIT
	
	if Global.tutorial_completed:
		_current_minigame = 1
		
	_activate_current_minigame()

func go_to_next_minigame() -> void:
	TransitionManager.create_transition(0.1, 0.2, 0.1)
	s = false
	$GameOver.visible = false
	if _current_minigame == _minigames_list.size() - 1:
		_finish_game()
	_current_minigame += 1
	
	$Player.position = _player_initial_position

func _on_minigame_completed() -> void:
	_screenshake(4)
	_deactivate_current_minigame()
	if _current_minigame == 0:
		go_to_next_minigame()
	else:
		s = true
		$GameOver.color = Color(0.0, 0.121, 0.05, 0.847)
		$GameOver/tex.text = "[wave amp=8.0 freq=2.0 connected=0][b]You Win![/b]
	Press the action button to proceed"
		$GameOver.visible = true

func _on_minigame_gameover() -> void:
	_screenshake(10)
	s = true
	_deactivate_current_minigame()
	$GameOver.color = Color(0.212, 0.0, 0.0, 0.847)
	$GameOver/tex.text = "[wave amp=8.0 freq=2.0 connected=0][b]Game Over[/b]
Press the action button to proceed"
	$GameOver.visible = true

func _on_minigame_earned_points(points: int) -> void:
	_screenshake(1)
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


func _screenshake(force: float = 30.0) -> void:
	_screenshake_active = true
	_screenshake_force = force

func _process(delta: float) -> void:
	if _screenshake_active:
		_screenshake_force = lerpf(_screenshake_force, 0.0, 10 * delta)
		offset.x = randf_range(-_screenshake_force, _screenshake_force)
		offset.y = randf_range(-_screenshake_force, _screenshake_force)
		
		if _screenshake_force <= 1:
			_screenshake_active = false
			offset = Vector2.ZERO
	if s and Input.is_action_just_pressed("main_action"):
			go_to_next_minigame()
	if Input.is_action_just_pressed("p"):
		completed.emit()
