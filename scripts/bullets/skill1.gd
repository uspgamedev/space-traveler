
extends Node2D

var charges = 1
var finished = 0
var index

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 2.0
	get_parent().player.skillCoolDown[i][0] = 2.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.AD += 30
	get_parent().player.bar.crit += 20
	get_parent().player.bar.armor += 20
	#self.queue_free()

func setup (i) :
	set_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	index = i
	get_parent().setBullet(i, "res://scenes/bullets/BulletSk1.xscn")
	finished = 1

func _process(delta):
	if (finished == 1):
		self.queue_free()
