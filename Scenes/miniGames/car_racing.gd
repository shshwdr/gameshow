extends Node2D

onready var camera = $Camera2D
onready var controlled_car = $controlled_car

var question = {"color_count":"blue"}
var answer = 0
var color_list = ["green","blue","purple","grey"]

var color_map = {
	"green":Color("00ff00"),
	"blue":Color("00f3ff"),
	"purple":Color("9100ff"),
	"grey":Color("5d5d5d"),
	"pink":Color("ff6cbf"),
	"orange":Color("ff7417"),
}

var npc_car_scene = preload("res://Scenes/Object/npc_car.tscn")
onready var cars = $cars

var height = 30
var width = 3

var x_center
var y_min
var car_width = 80
var car_height = 100

var difficulty = 0

var car_table = {}

var camera_to_car

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_to_car = camera.position - controlled_car.position
	yield(get_tree().create_timer(1), "timeout")
	controlled_car.is_started = true
	controlled_car.column_width = car_width
	x_center = controlled_car.position.y
	y_min = controlled_car.position.x - car_height*3
	npc_car_generation()
	pass # Replace with function body.

func _physics_process(delta):
	camera.position = Vector2(camera.position.x,(controlled_car.position+camera_to_car).y)
	#print(camera.position)
	
func out_border(pos,start_pos,end_pos):
	if pos[0]>=start_pos[0] and pos[1]>=start_pos[1] and pos[0]<=end_pos[0] and pos[1]<=end_pos[1]:
		return false
	return true

func can_add_car(i,j):
	#if this is set to true, there are still ways to reach upper level, 
	#for each position set as true in the third line below
	
	#set true
	car_table[[i,j]] = true
	var check_position = {}
	var vis = {}
	var check_y = j-3
	var end_pos = [2,j]
	var start_pos = [0,check_y]
	#get upper level
	for ii in range(width):
		var queue = [[ii,j+1]]
		while not queue.empty():
			var pop = queue.pop_front()
			for dir in Utils.DIR4:
				var new_pos = [dir[0]+pop[0],dir[1]+pop[1]]
				if vis.get(new_pos) or out_border(new_pos,start_pos,end_pos) or car_table.get(new_pos) == true:
					continue
				vis[new_pos] = true
				queue.push_back(new_pos)
				check_position[new_pos] = true
			if queue.size()>100:
				print("something is wrong ",queue)
				break
	
	#set back to false
	car_table[[i,j]] = false			
	#if all three are available, return true
	for ii in range(width):
		if car_table.get([ii,check_y]) or check_position.get([ii,check_y]):
			continue
		return false
	return true
	
func should_add_car(i,j):
	if car_table.get([i,j-1]) and car_table.get([i,j-2]) and car_table.get([i,j-3]):
		return false
	return true

func npc_car_generation():
	var change_order = 0
	
	for j in range(height):
		for ii in range(width):
			var i = (ii+change_order)%width
			if can_add_car(i,j) and should_add_car(i,j):
				if Utils.rng.randf()>0.5:
					car_table[[i,j]] = true
					var npc_car_instance = npc_car_scene.instance()
					var random_color_id = Utils.rng.randi()%color_list.size()
					var random_color_name = color_list[random_color_id]
					if question.has("color_count") and random_color_name == question["color_count"]:
						answer+=1
					npc_car_instance.modulate = color_map[random_color_name]
					cars.add_child(npc_car_instance)
					npc_car_instance.position = Vector2(x_center+(i-1)*car_width,y_min-j*car_height)
#				else:
#					print("dont add ",i," ",j)
			
			change_order+=1
	print("answer ",answer)
	Utils.answer = answer
func generate_row():
	pass
