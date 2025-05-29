#extends "res://scripts/modifiers/modifier_mult.gd"
extends ModifierMult

class_name ModifierStreakMult

@export var streakCondition: Callable
@export var streakIncrease: float

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
	streakIncrease = float(randi_range(1.0,3.0)) / 10.0
	choiceText = "Multiply score by 1 + %.2f for every correct answer, resets after incorrect answer" % streakIncrease
	
func incorrectStreakMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		return not correct
	streakIncrease = 0.1
	choiceText = "Multiply score by 1 + %.2f for every incorrect answer, resets after correct answer" % streakIncrease
	
func ifCorrectMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = 0
		return correct
	streakIncrease = [2,2.5,3].pick_random()
	choiceText = "Multiply score by %.2f if your answer is correct" % streakIncrease

func ifCorrectMultIfIncorrectNegative() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		streakIncrease = absi(streakIncrease)
		multiplier = 0
		if correct: streakIncrease = 1 + streakIncrease
		else: streakIncrease = 1 - streakIncrease
		return true
	streakIncrease = 0.2
	choiceText = "Multiply score by %.2f if correct, by %.2f if incorrect" % [1.0 + streakIncrease, 1.0 - streakIncrease]


func ifIncorrectMult() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = 0
		return not correct
	streakIncrease = -1.0 * [1.0,2.0,1.5].pick_random()
	choiceText = "Multiply score by -%.2f if your answer is incorrect" % multiplier

func multRandom() -> void:
	streakCondition = func (score: int, correct: bool, difficulty: int, subject: String):
		multiplier = [-10, -5, -2, -1, 1, 2, 5, 10].pick_random()
		return true
	streakIncrease = 0
	choiceText = "rAnd0m##!10x,5x,2x,1x$err!&###-1x-5x-2x-10x"

			
