#extends "res://scripts/modifiers/modifier.gd"
extends Modifier

class_name ModifierAdd

@export var pointAddition: int
@export var maxPointAdditionInTens: int = 1
@export var minPointAdditionInTens: int = 5

func _init() -> void:
	pointAddition = 10 * randi_range(minPointAdditionInTens, maxPointAdditionInTens)
	choiceText = "+%d points to your score" % pointAddition

func modifyScore(score: int) -> int:
	return score + pointAddition
