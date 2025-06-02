extends Node

@onready var Trivia: Node = $".."

# Wrapper for Open Trivia Database API

func _ready():
	makeRequest()

func makeRequest():
	var httpRequest = HTTPRequest.new()
	print("Making HTTP Request")
	add_child(httpRequest)
	httpRequest.request_completed.connect(self.parseResponse)
	
	# GET request to OTDB endpoint
	var error = httpRequest.request("https://opentdb.com/api.php?amount=12&type=multiple&encode=url3986&difficulty=easy")
	#var error = httpRequest.request("https://httpbin.org/get")
	printt("Error", error)
	if error != OK:
		push_error("There was a problem performing HTTP request")

var difficultyDict: Dictionary = {
	&"easy":1,
	&"medium":2,
	&"hard":3,
}
#
##static func newQuestion(
#question: String, 
#difficulty: int, 
#options: Dictionary, 
#subject: String = "General"):

func parseResponse(result, response_code, headers, body):
		var json = JSON.new()
		json.parse(body.get_string_from_utf8())
		var response = json.get_data()
		if response == null or not response.has("results"):
			return
		for question in response.results:
			var options: Dictionary = {
				question.correct_answer.uri_decode():1,
			}
			for option in question.incorrect_answers:
				options[option.uri_decode()] = 0
			Trivia.questions.append(Question.newQuestion(
				question.question.uri_decode(),
				difficultyDict[question.difficulty],
				options,
				question.category
			))
		print("Processed HTTP Response")
		
		
