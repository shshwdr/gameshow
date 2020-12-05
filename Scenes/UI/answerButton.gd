extends Button


var answer


# Called when the node enters the scene tree for the first time.
func _ready():
	text = String(answer)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button2_pressed():
	Events.emit_signal("select_answer",answer)
