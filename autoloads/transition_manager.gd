# Ad Maiorem Dei Gloriam!
## AUTOLOAD: TransitionManager
extends CanvasLayer


var transition_time: float = 0.5
var _in_transition: bool = false

var _progress: float = 0.0

func go_to_scene(scene_file: String) -> void:
	_in_transition = true
	
	var tween: Tween = create_tween()
	tween.tween_property(self, "_progress", 1.0, transition_time)
	await tween.finished
	
	get_tree().change_scene_to_file(scene_file)
	await get_tree().scene_changed
	
	%ColorRect.rotation_degrees += 180
	
	tween = create_tween()
	tween.tween_property(self, "_progress", 0.0, transition_time)
	await tween.finished
	
	var shader: ShaderMaterial = %ColorRect.material as ShaderMaterial
	if shader:
		shader.set_shader_parameter("animation_progress", 0.0)
	_in_transition = false

func _process(delta: float) -> void:
	if !_in_transition: return
	var shader: ShaderMaterial = %ColorRect.material as ShaderMaterial
	if shader:
		shader.set_shader_parameter("animation_progress", _progress)
