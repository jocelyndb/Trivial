#extends "res://scripts/modifiers/modifier.gd"
extends Modifier

class_name ModifierMult

@export var multiplier: float = 1
@export var multOptions: Array[float] = [1.25, 1.5, 2]

func _init() -> void:
	multiplier = multOptions.pick_random()
	choiceText = "Multiply score by %.2f" % multiplier


func modifyScore(score: int) -> int:
	return score * multiplier
