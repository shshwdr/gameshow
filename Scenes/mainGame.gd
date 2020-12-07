extends Node2D

var answer_count = 4
var answer_scene = preload("res://Scenes/UI/answerButton.tscn")
var dialog = preload("res://Scenes/UI/Dialog.tscn")
var dialog_folder = "res://resources"
onready var answers = $Control/answers
onready var text = $Control/RichTextLabel

var dialog_instance

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
	
	var file_path = '%s/%s%d.json' % [dialog_folder, "level",LevelManager.current_level]
	var level_dialog = Utils.load_json(file_path)
	
	DialogManager.load_dialog(level_dialog,self)
	DialogManager.load_dialog_label(text)
	
#	dialog_instance = dialog.instance()
#	dialog_instance.init_existed_label(text,level_dialog)
#	add_child(dialog_instance)
#	dialog_instance.start_dialog()

func on_select_answer(answer):
	if answer == Utils.answer:
		print("correct")
	else:
		print("incorrect")

func end():
	return
	dialog_instance.queue_free()
	
		
func trigger(trigger_name):
	match trigger_name:
		
		"end":
			end()
		"end_game":
			LevelManager.finished_game = true
			#GameSaver.save_globally()
			#Events.emit_signal("game_end")
		
	yield(get_tree(), 'idle_frame')


func _on_Button_pressed():
	get_tree().change_scene("res://Scenes/miniGames/car_racing.tscn")
