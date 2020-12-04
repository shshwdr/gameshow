extends Node

var chitchat_list

var dialog_folder = "res://resources/dialog"
var dialog = preload("res://Scenes/UI/Dialog.tscn")

func _ready():
	load_chitchat()
	
func load_chitchat():
	var file_path = '%s/%s.json' % [dialog_folder, "chitchat"]
	chitchat_list = Utils.load_json(file_path)

func select_chitchat(dianosaur):
	var random_i = Utils.randomi_array_size(chitchat_list)
	
	return select_dialog(dianosaur,chitchat_list[random_i])


func select_dialog(dianosaur,chat,_is_quest = false):
	var is_quest = _is_quest or chat.has("name")
	var quest_param = {"quest_time":dianosaur.get_quest_waiting_time()} if is_quest else null
	var dialog_position = dianosaur.dialog_position()
	var dialog_instance = dialog.instance()
	var dialog_size = Utils.visitor_dialog_size
	dialog_instance.init(dialog_position, chat,quest_param, dialog_size)
	return dialog_instance

func select_dialog_multiple(_parent_node, chat, dialog_size = null):
	var is_quest = chat.has("name")
	var dialog_instance = dialog.instance()
	dialog_instance.init_with_parent_node(_parent_node, chat,is_quest, dialog_size)
	return dialog_instance
