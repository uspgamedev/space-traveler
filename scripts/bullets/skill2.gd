
extends Node2D

var index
var charges = 1
var initTime = 0.0
var endTime = 2.0
var oldAS = 0.0
var oldArmor = 0.0
var oldSpeed = 0.0

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
	initTime = OS.get_ticks_msec()/1000.0
	endTime += initTime
	oldAS = get_parent().player.baCoolDown[0]
	oldArmor = get_parent().player.bar.armor
	oldSpeed = get_parent().player.movem.speed
	get_parent().player.baCoolDown[0] *= 0.1
	get_parent().player.bar.armor += 500
	get_parent().player.movem.setSpeed(oldSpeed/3)

func _fixed_process(delta):
	if (OS.get_ticks_msec()/1000.0 > endTime):
		get_parent().player.baCoolDown[0] = oldAS
		get_parent().player.bar.armor = oldArmor
		get_parent().player.movem.setSpeed(oldSpeed)
		self.queue_free()
	else :
		self.set_pos(get_parent().player.get_pos())
		update()

func _draw():
	draw_circle(Vector2(0, 0), 55.0, Color(255.0/255, 160.0/255, 0.0/255, 0.1))

func setPosition(pos, dir):
	pass