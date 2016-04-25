
extends Node

var index
var charges = 1
var initTime = 0.0
var endTime = 2.0
var oldAS = 0.0
var oldArmor = 0.0

func _init():
	set_fixed_process(true)

func _ready():
	for skill in get_parent().skills :
		if (skill[1] == (self.get_filename())):
			index = get_parent().skills.find(skill)
	if (get_parent().player.skillCharges[index] == -1) :
		get_parent().player.skillCharges[index] = charges
	get_parent().player.skillCharges[index] -= 1
	initTime = OS.get_ticks_msec()/1000.0
	endTime += initTime
	oldAS = get_parent().player.baCoolDown[0]
	oldArmor = get_parent().player.bar.armor
	get_parent().player.baCoolDown[0] *= 0.1
	get_parent().player.bar.armor += 500

func _fixed_process(delta):
	if (OS.get_ticks_msec()/1000.0 > endTime):
		get_parent().player.baCoolDown[0] = oldAS
		get_parent().player.bar.armor = oldArmor
		self.queue_free()

func setPosition(pos, dir):
	pass