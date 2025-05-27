extends Node

class_name Modifier

var choiceText: String

# Modifiers can affect score calculation
func modifyScore(score: int) -> int:
	return score

# Modifiers can use information about the answer
func modifyScoreWithContext(score: int, correct: bool, difficulty: int, subject: String):
	return modifyScore(score)

# Modifiers can affect the questions presented to the player
# Called before a question is chosen at random and presented to the player
func affectQuestionChoice(questions: Array[Question]) -> Array[Question]:
	return questions # stub
