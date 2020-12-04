extends Node2D

onready var camera = $Camera2D
onready var controlled_car = $controlled_car

var npc_car_scene = preload("res://Scenes/Object/npc_car.tscn")
onready var cars = $cars

var height = 10
var width = 3

var x_center
var y_min
var car_width = 100
var car_height = 150

var car_table = {}

var camera_to_car

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_to_car = camera.position - controlled_car.position
	yield(get_tree().create_timer(1), "timeout")
	controlled_car.is_started = true
	x_center = controlled_car.position.y
	y_min = controlled_car.position.x - car_height
	npc_car_generation()
	pass # Replace with function body.

func _physics_process(delta):
	camera.position = Vector2(camera.position.x,(controlled_car.position+camera_to_car).y)
	#print(camera.position)

func npc_car_generation():
	for i in range(width):
		for j in range(height):
			car_table[[i,j]] = true
			var npc_car_instance = npc_car_scene.instance()
			cars.add_child(npc_car_instance)
			npc_car_instance.position = Vector2(x_center+(i-1)*car_width,y_min-j*car_height)

func generate_row():
	pass
