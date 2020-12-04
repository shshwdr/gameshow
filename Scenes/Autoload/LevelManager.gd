extends Node

var level_infos
var current_level = 0
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

func level_up_scene_change():
	var move_up_dir = Vector2(0,-level_jump_height)
	var moon_move_up_dir = Vector2(0,-level_jump_height+Utils.moon_jump_height)
	var move_up_time = 1
	
	var space_ship_diff = LevelManager.get_level_info().target_height - LevelManager.get_last_level_info().target_height #-5
	#move camera up and moon up
	
	var tween1 = Tween.new()
	var tween2 = Tween.new()
	var tween3 = Tween.new()
	add_child(tween1)
	add_child(tween2)
	add_child(tween3)
	
	Utils.move_position_by( Utils.camera,tween1,move_up_dir,move_up_time,Tween.TRANS_QUINT, Tween.EASE_OUT)
	Utils.move_position_by(Utils.moon,tween2,moon_move_up_dir,move_up_time,Tween.TRANS_BACK, Tween.EASE_OUT)
	Utils.move_position_by(Utils.generator,tween3,move_up_dir+ Vector2(0,1)*space_ship_diff,move_up_time*3,Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	
	
	Utils.update_offset(level_jump_height)
	Utils.moon.reset_moon()
	yield(get_tree().create_timer(3), "timeout")
	tween1.queue_free()
	tween2.queue_free()
	tween3.queue_free()
	#move spaceship later
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

