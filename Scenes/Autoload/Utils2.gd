extends Node

var tile_length = 32

var half_tile_size = Vector2(tile_length/2,tile_length/2)
var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var maingame
var current_question
var failed_game = false
var answer

var interact_key = "interact"
var interact_key_2 = "interact2"

#these value would never change.
var width_offset = 4#left space for generator
var width_end_offset = 1#right space for balance
var width_index = 12
var width_total = width_offset+width_index+width_end_offset
var height_offset_static = 3#upper space, for moon jump up

#these value would change
var y_offset = 0 #screen y offset, when moon move up, this value will get small
var height_offset = 3 
#game screen is inside of screen
var height_index = 5 #height would change based on level
var screen_top_left = Vector2(0,y_offset)
#used to check if item is inside of game screen
var game_screen_top_left = Vector2(width_offset,height_offset) 
var game_screen_top_right = Vector2(width_offset+width_index,height_offset) 
#used to decide moon position
var game_screen_top_center = Vector2(width_offset +width_index/2 ,height_offset)
#used to decide where to generate base, generator, and if player is ready to start
var game_screen_bottom_left = Vector2(width_offset,height_offset+height_index)
#used to decide where to generate base
var game_screen_bottom_right = Vector2(width_offset+width_index,height_offset+height_index)

var height_total = height_offset_static+height_index+height_offset_static


var screen_height_index = 11

var is_main_game_started = false

var wait_time =0.4

var DIR4 = [[0,1],[0,-1],[-1,0],[1,0]]

var DIR_UP = Vector2(0,1)

func main_game_start():
	is_main_game_started = true
func main_game_stop():
	is_main_game_started = false
	
func reset_offset():
	y_offset = 0
	height_offset = 3 
	screen_top_left = Vector2(0,y_offset)
#used to check if item is inside of game screen
	game_screen_top_left = Vector2(width_offset,height_offset) 
	game_screen_top_right = Vector2(width_offset+width_index,height_offset) 
#used to decide moon position
	game_screen_top_center = Vector2(width_offset +width_index/2 ,height_offset)


func update_offset(diff):
	y_offset -= diff
	height_offset -= diff
	screen_top_left = Vector2(0,y_offset)
	game_screen_top_left = Vector2(width_offset,height_offset)
	game_screen_top_right = Vector2(width_offset+width_index,height_offset) 
	game_screen_top_center = Vector2(width_offset +width_index/2 ,height_offset)
	update_game_level()

func update_game_level():
	game_screen_top_center = Vector2(width_offset +width_index/2 ,height_offset)
	game_screen_bottom_left = Vector2(width_offset,height_offset+height_index)
	game_screen_bottom_right = Vector2(width_offset+width_index,height_offset+height_index)
	height_total = height_offset_static+height_index+height_offset_static
	
	

func _ready():
	rng.randomize()

func clear_all_children(node):
	for child in node.get_children():
		child.queue_free()

func on_border(index:Vector2):
	if index.x == width_offset or index.x == width_offset+width_index-1:
		return true
	return false
	
func in_bound(index:Vector2, width,height):
	return index.x>=0 and index.x<width and index.y>=0 and index.y<height	
	
func in_screen(index:Vector2):
	if not index:
		return false
	return in_bound_with_start_position(index, screen_top_left, width_total,height_total)

func in_game_screen(index:Vector2):
	return in_bound_with_start_position(index, game_screen_top_left, width_index,height_index)
	

	
	
	
func in_bound_with_start_position(index:Vector2, start_position,width,height):
	return index.x>=start_position.x and index.x<start_position.x+width and \
	index.y>=start_position.y and index.y<height+start_position.y	
	

func index_to_position(index:Vector2):
	var res = index*tile_length +half_tile_size
	return res
	
func position_to_index(position:Vector2):
	var res = (position - half_tile_size)/tile_length
	res = Vector2(round(res.x),round(res.y))
	return res
	
func move_position_by(character,tween,index_position,move_time = wait_time, tween_trans = Tween.TRANS_LINEAR, tween_ease = Tween.EASE_IN):
	var current_position  = character.position
	var target_position =  position_move_by(character.position,index_position)
	var create_tween = false
#	if not tween:
#		create_tween = true
#		tween = Tween.new()
	#add_child(tween)
	if not tween:
		return
	tween.interpolate_property(
				character, 
				"position", 
				current_position,target_position, move_time,
				tween_trans, tween_ease)
	tween.start()
	yield(tween,"tween_completed")
#	if create_tween:
#		tween.free_queue()

func position_move_to(character,index_position):
	character.position = index_to_position(index_position)
	
func position_move_by(position,index_position):
	var to_move_index_position = position_to_index(position)
	return index_to_position(to_move_index_position+index_position)

func randomi_vector2(vec1,vec2):
	return Vector2(rng.randi_range(vec1.x,vec2.x), rng.randi_range(vec1.y,vec2.y))

func randomi_2d(width,height):
	var w = rng.randi() % width
	var h = rng.randi() % height
	return Vector2(w,h)
func randomi(i):
	return rng.randi()%i

func sum_array(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum

func random_distribution_array(array):
	var total_count = sum_array(array)
	var random_value = rng.randi_range(1,total_count)
	var increasing_count = 0
	for i in array.size():
		increasing_count+=array[i]
		if random_value<=increasing_count:
			return i
	printerr("random array didn't return correctly")
	return 0

func load_json(file_path):
	var file = File.new()
	var error = file.open(file_path, File.READ)
	if error != OK:
		printerr("Couldn't open file for read: %s, error code: %s." % [file_path, error])
		return
	var json = file.get_as_text()
	var res = JSON.parse(json).result
	error = JSON.parse(json).error
	if error != OK:
		print(JSON.parse(json).error_string)
	file.close()
	return res
