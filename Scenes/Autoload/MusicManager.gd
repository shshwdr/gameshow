extends Node

onready var player = $AudioStreamPlayer

var music_dict = {
	"level_game" : preload("res://sound/bg/bensound-funnysong.ogg"),
	"ending" : preload("res://sound/bg/bensound-slowmotion.ogg"),
	"start": preload("res://sound/bg/bensound-goinghigher.ogg"),
}

var sfx_dict = {
	"typing": preload("res://sound/fx/425161__chazzravenelle__smartphone-texting-sound-and-vibrate-high-quality.ogg"),
	"ouch":preload("res://sound/fx/ouch.wav"),
	"throw":preload("res://sound/fx/throw4.wav"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

func play_music(music_name):
	if player.stream != music_dict[music_name]:
		player.stream = music_dict[music_name]
		player.playing = true
	
func get_sfx(sfx_name):
	return sfx_dict[sfx_name]
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
