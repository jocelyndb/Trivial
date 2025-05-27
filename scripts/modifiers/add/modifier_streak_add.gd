#extends "res://scripts/modifiers/modifier_add.gd"
extends ModifierAdd

class_name ModifierStreakAdd

@export var streakCondition: Callable
@export var streakIncrease: int

# Array of callables for functions that initialize every
# possible type of streak add modifier
var possibilities: Array[Callable] = [
	ifCorrectAddStreak,
	ifInorrectSubtractStreak,
	ifCorrectAdd,
	ifIncorrectSubtract,
]

func _init() -> void:
	choiceText = "Adds by some streak"
	pointAddition = 0
	possibilities.pick_random().call()

#func modifyScore(score: int) -> int:
	#return score * multiplier
	
func modifyScoreWithContext(score: int, correct: bool, difficulty: int, subject: String):
	if streakCondition.call(score, correct, difficulty, subject):
		pointAddition += streakIncrease
	else:
		pointAddition = 0
	return super.modifyScore(score)

# BEGIN SPECIFICATIONS FOR CONDITIONAL ADD MODIFIERS

func ifCorrectAddStreak() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		return correct
	streakIncrease = randi_range(1, 15) * 10
	choiceText = "+%d x your correct answer streak" % streakIncrease
	
func ifInorrectSubtractStreak() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		return not correct
	streakIncrease = randi_range(-1, -4) * 10
	choiceText = "%d x your incorrect answer streak" % streakIncrease
	
func ifCorrectAdd() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		if not correct:
			pointAddition -= streakIncrease
		return true
	streakIncrease = randi_range(50, 80) * 10
	choiceText = "+%d if your answer is correct" % streakIncrease

func ifIncorrectSubtract() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		if correct:
			pointAddition -= streakIncrease
		return true
	streakIncrease = randi_range(10, 30) * -10
	choiceText = "%d if your answer is incorrect" % streakIncrease
		
