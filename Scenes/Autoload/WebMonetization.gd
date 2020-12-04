extends Node

var _paying: bool
var _poll: Timer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if JavaScript.eval("(document.monetization !== null);"):
		_poll = Timer.new()
		add_child(_poll)
		_poll.connect("timeout", self, "_on_poll_timeout")
		_poll.one_shot = false
		_poll.start(1)
		
func _on_poll_timeout() -> void:
	if JavaScript.eval("(document.monetization.state === 'started');"):
		if not _paying:
			_paying = true
			#_poll.queue_free()
	elif _paying:
		_paying = false
		
func is_paying() -> bool:
	return _paying


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
