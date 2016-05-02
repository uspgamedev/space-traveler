
extends Node2D

var index
var charges = 1

func _init():
	set_fixed_process(true)

func _ready():
	for skill in get_parent().skills :
		if (skill[1] == (self.get_filename())):
			index = get_parent().skills.find(skill)
	if (get_parent().player.skillCharges[index] == -1) :
		get_parent().player.skillCharges[index] = charges
	get_parent().player.skillCharges[index] -= 1


func setup (i):
	get_parent().player.skillCoolDown[i][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.movem.moveTo((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2).normalized()*350+get_parent().player.get_pos(), 1800)

func _fixed_process(delta):
	pass

func setPosition(pos, dir):
	pass