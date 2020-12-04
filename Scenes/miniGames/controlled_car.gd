extends KinematicBody2D

var velocity =Vector2(0,-1)#Vector2(0,-100)

var is_started = false
var  column_width = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if not is_started:
		return
	var change = velocity * delta
	#print("move ",delta)
	if Input.is_action_just_pressed("ui_right"):
		#print("right")
		# Move as long as the key/button is pressed.
		change +=(Vector2.RIGHT*column_width)
	if Input.is_action_just_pressed("ui_left"):
		# Move as long as the key/button is pressed.
		change +=(Vector2.LEFT*column_width)
	
	if move_and_collide(change):
		return
		get_tree().change_scene("res://Scenes/mainGame.tscn")
