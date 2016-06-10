
extends Node2D

var itens = [null, null, null, null]

func _ready():
	pass

func initHud (skillPre):
	set_process(true)
	var itemScene = load("res://scenes/ItemVis.xscn")
	itens[1] = itemScene.instance()
	add_child(itens[1])
	itens[1].set_pos(Vector2(-get_viewport().get_rect().size.width/4-40, get_viewport().get_rect().size.height/3-40))
	itens[1].initItem(skillPre[1])

func _process(delta):
	itens[1].set_pos(Vector2(-get_viewport().get_rect().size.width/4-40, get_viewport().get_rect().size.height/3-40)+1.3*(get_parent().get_child(2).get_camera_screen_center()-get_parent().get_pos()))
	