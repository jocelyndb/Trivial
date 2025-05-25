extends Node

class_name Question
# Question text
var question: String
var subject: String
# difficulty is one of:
#	1: easy
#	2: medium
#	3: hard
var difficulty: int
# Dictionary[String, int]
# Int is one of:
#	- -2 Disabled, Incorrect
# 	- -1 Disabled, Correct
#	- 0  Enabled, Incorrect
# 	- 1	 Enabled, Correct
var options: Dictionary

static func newQuestion(question: String, difficulty: int, options: Dictionary, subject: String = "General"):
	var newQ = Question.new()
	newQ.question = question
	newQ.difficulty = difficulty
	newQ.options = options
	newQ.subject = subject
	print(JSON.stringify(newQ))
	return newQ
	
# TODO: add serialize function to save questions
#static func serialize()
	
static func parseJSONString(json: String) -> Question:
	var qJson = JSON.parse_string(json)
	print(qJson["question"])
	print(qJson["difficulty"])
	print(qJson["subject"])
	print(qJson["options"])
	return newQuestion(qJson["question"], qJson["difficulty"], qJson["options"], qJson["subject"])
