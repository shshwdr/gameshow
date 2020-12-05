extends Node2D

var answer_count = 4
var answer_scene = preload("res://Scenes/UI/answerButton.tscn")
onready var answers = $Control/answers

# Called when the node enters the scene tree for the first time.
func _ready():
	if Utils.answer!=null:
		var answer  = Utils.answer
		var min_range = max(-3,-(answer/2))
		#-3,-2,-1,0,1,2,3
		var diff = Utils.rng.randi_range(-3,3)
		var pace = 2
		for i in range(answer_count):
			var current_answer = answer+(diff+i)*pace
			var answer_instance = answer_scene.instance()
			answer_instance.answer = current_answer
			answers.add_child(answer_instance)
	Events.connect("select_answer",self,"on_select_answer")

func on_select_answer(answer):
	if answer == Utils.answer:
		print("correct")
	else:
		print("incorrect")





func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/miniGames/car_racing.tscn")
