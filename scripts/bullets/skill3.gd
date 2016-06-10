
extends Node2D

var index
var charges = 1

func _init():
	set_fixed_process(true)

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 3.0
	get_parent().player.skillCoolDown[i][0] = 3.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.armor += 20
	get_parent().player.bar.shield += 20
	get_parent().player.bar.speed += 20
	self.queue_free()

func setup (i):
	index = i
	#get_parent().player.skillCoolDown[index][2] = 0
	get_parent().player.skillCoolDown[i][1] = OS.get_ticks_msec()/1000.0
	#get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.movem.moveTo((get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2).normalized()*350+get_parent().player.get_pos(), 1800)

func _fixed_process(delta):
	pass

func setPosition(pos, dir):
	pass