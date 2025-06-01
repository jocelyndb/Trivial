extends Button

class_name SFXButton

func _ready() -> void:
	mouse_entered.connect(SoundManager.playHover)
	pressed.connect(SoundManager.playPress)
