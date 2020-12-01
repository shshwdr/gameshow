extends Node2D

onready var camera = $Camera2D
onready var controlled_car = $controlled_car
var camera_to_car

# Called when the node enters the scene tree for the first time.
func _ready():
	camera_to_car = camera.position - controlled_car.position
	yield(get_tree().create_timer(1), "timeout")
	controlled_car.is_started = true
	pass # Replace with function body.

func _physics_process(delta):
	camera.position = Vector2(camera.position.x,(controlled_car.position+camera_to_car).y)
	#print(camera.position)

func generate_row():
	pass
