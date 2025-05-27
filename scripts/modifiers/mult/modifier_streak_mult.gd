#extends "res://scripts/modifiers/modifier_mult.gd"
extends ModifierMult

class_name ModifierStreakMult

@export var streakCondition: Callable
@export var streakIncrease: int

# Array of callables for functions that initialize every
# possible type of streak mult modifier
var possibilities: Array[Callable] = [
	correctStreakMult,
	incorrectStreakMult,
	ifCorrectMult,
	ifIncorrectMult,
	multRandom,
	ifCorrectMultIfIncorrectNegative,
]

func _init() -> void:
	print("Initializing streak mult")
	choiceText = "Multiplies by some streak"
	multiplier = 1
	possibilities.pick_random().call()

#func modifyScore(score: int) -> int:
	#return score * multiplier
	
func modifyScoreWithContext(score: int, correct: bool, difficulty: int, subject: String):
	if streakCondition.call(score, correct, difficulty, subject):
		multiplier += streakIncrease
	else:
		multiplier = 1
	return super.modifyScore(score)
	
# BEGIN SPECIFICATIONS FOR CONDITIONAL MULT MODIFIERS

func correctStreakMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		return correct
	streakIncrease = randi_range(1, 15) * 10
	choiceText = "x%d x your current correct answer streak" % streakIncrease
	
func incorrectStreakMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		return not correct
	streakIncrease = randi_range(-1, -4) * 10
	choiceText = "x%d x your incorrect answer streak" % streakIncrease
	
func ifCorrectMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = 0
		return correct
	streakIncrease = randf_range(8, 15)
	choiceText = "x%d if your answer is correct" % streakIncrease

func ifCorrectMultIfIncorrectNegative() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = 0
		streakIncrease = absi(streakIncrease)
		if not correct:
			streakIncrease = -streakIncrease
		return true
	streakIncrease = randf_range(20, 25)
	choiceText = "x%d if your answer is correct" % streakIncrease


func ifIncorrectMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = 0
		return correct
	streakIncrease = [-10, -1, 2, 4, 5].pick_random()
	choiceText = "x%d if your answer is incorrect" % multiplier

func multRandom() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = [-10, -1, 2, 4, 5, 8, 10, 1000].pick_random()
		return true
	streakIncrease = 0
	choiceText = "rAnd0m##!x1000,x10,x8,x5,x4err!&###x-10,x-1"

			
