extends Node

var level_infos
var current_level = 1
var level_folder = "res://resources/level"

var level_jump_height = 20

var unlocked_level = 0

var LEVEL_SAVE_KEY = "levels"
var FINISH_SAVE_KEY = "finished"

var finished_game = false


func is_prolog():
	return current_level == 0
# Called when the node enters the scene tree for the first time.
func _ready():
	load_levels_info()
	
func load_levels_info():
	return
	var file_path = '%s/%s.json' % [level_folder, "level"]
	level_infos = Utils.load_json(file_path)


func _process(delta):
	pass
	
func level_up():

	Utils.maingame.show_level_end_dialog()
	#start next level
	
func start_level():
	#load level data
	#create base
	pass


	
func get_level():
	return current_level

func get_one_level_info(level):
	if level>= level_infos.size() or level<0:
		printerr("level %d more than define"%level)
	var res = level_infos[level].duplicate()
#	if DebugSetting.skip_main_game > 0:
#		res.level_length = DebugSetting.skip_main_game
	return res

func get_last_level_info():
	var last_level = current_level-1
	if last_level>= level_infos.size() or last_level<0:
		printerr("level %d more than define"%current_level)
	var res = level_infos[last_level].duplicate()
#	if DebugSetting.skip_main_game > 0:
#		res.level_length = DebugSetting.skip_main_game
	return res
	
func get_level_info():
	if current_level>= level_infos.size():
		push_error("level %d more than define"%current_level)
	var res = level_infos[current_level].duplicate()
#	if DebugSetting.skip_main_game > 0:
#		res.level_length = DebugSetting.skip_main_game
	return res
	
func load_level(level):
	current_level = level
	
func next_level():
	current_level+=1
	if current_level >=level_infos.size():
		Events.emit_signal("get_max_level")
	
func save(saved_game: Resource):
	unlocked_level = max(unlocked_level,current_level)
	saved_game.data[LEVEL_SAVE_KEY] = unlocked_level
	if finished_game:
		saved_game.data[FINISH_SAVE_KEY] = true
	
func load(saved_game: Resource):
	if not saved_game.data.has(LEVEL_SAVE_KEY):
		unlocked_level = 0
	else:
		unlocked_level = saved_game.data[LEVEL_SAVE_KEY]
	if saved_game.data.has(FINISH_SAVE_KEY):
		finished_game = true

