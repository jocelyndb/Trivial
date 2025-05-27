#extends "res://scripts/modifiers/modifier.gd"
extends Modifier

class_name ModifierMult

@export var multiplier: int = 1
@export var multOptions: Array[int] = [-1, 2, 3, 4, 5, 7, 10]

func _init() -> void:
	multiplier = multOptions.pick_random()
	choiceText = "x%d" % multiplier


func modifyScore(score: int) -> int:
	return score * multiplier
