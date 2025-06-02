extends Control

signal unpause
signal pause

func _on_resume_pressed() -> void:
	unpause.emit()

func _on_visibility_changed() -> void:
	if visible:
		pause.emit()
