#extends "res://scripts/modifiers/modifier.gd"
extends Modifier

class_name ModifierAdd

@export var pointAddition: int
@export var maxPointAdditionInHundreds: int = 18
@export var minPointAdditionInHundreds: int = 2

func _init() -> void:
	pointAddition = 100 * randi_range(minPointAdditionInHundreds, maxPointAdditionInHundreds)
	choiceText = "+%d points" % pointAddition

func modifyScore(score: int) -> int:
	return score + pointAddition
