# Ad Maiorem Dei Gloriam!
class_name KongeyDong
extends Control

signal completed()
signal earned_points(points: int)
signal gameover()


func _on_meriu_gameover() -> void:
	gameover.emit()
	

func _on_meriu_completed() -> void:
	earned_points.emit(20)
	completed.emit()
