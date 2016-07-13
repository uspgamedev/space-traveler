
extends Node2D

var itens = [null, null, null, null]

func _ready():
	pass

func initHud (skillPre):
	set_process(true)
	var drag = 1.0*(get_parent().get_child(2).get_camera_screen_center()-get_parent().get_pos())
	self.set_pos(drag)
	drag = drag.rotated(-PI/8.0)*(get_viewport().get_rect().size.height /850.0)
	for i in range(0, 4):
		var itemScene = load("res://scenes/ItemVis.xscn")
		itens[i] = itemScene.instance()
		add_child(itens[i])
		itens[i].set_pos(Vector2(-get_viewport().get_rect().size.width/4 + get_viewport().get_rect().size.width/16 + i*get_viewport().get_rect().size.width/8, get_viewport().get_rect().size.height/2.5-40)+drag)
		drag = drag.rotated(PI/16.0)
		itens[i].initItem(skillPre[i], i)

func _process(delta):
	var drag = 1.0*(get_parent().get_child(2).get_camera_screen_center()-get_parent().get_pos())
	self.set_pos(drag)
	drag = drag.rotated(-PI/8.0)*(get_viewport().get_rect().size.height /850.0)
	for i in range(0, 4):
		if ((OS.get_ticks_msec()/1000.0 - get_parent().skillCoolDown[i][1]) < get_parent().skillCoolDown[i][0]/(get_parent().bar.speed/get_parent().STDSPEED)) :
			itens[i].get_child(0).set_modulate(Color(0.1,0.1,0.1, 0.2))
		elif (!get_parent().skillCoolDown[i][2]) :
			itens[i].get_child(0).set_modulate(Color(0.8,0.4,0.4, 0.6))
		else :
			itens[i].get_child(0).set_modulate(Color(1,1,1, 1))
		itens[i].set_pos(Vector2(-get_viewport().get_rect().size.width/4 + get_viewport().get_rect().size.width/16 + i*get_viewport().get_rect().size.width/8, get_viewport().get_rect().size.height/2.5-40)+drag)
		drag = drag.rotated(PI/16.0)
	
	