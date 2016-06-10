
extends Node2D

var finished = 0
var index

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 4.0
	get_parent().player.skillCoolDown[i][0] = 4.0
	get_parent().skills[i].append(self.get_path())
	self.queue_free()

func setup (i) :
	set_fixed_process(true)
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	get_parent().setBullet(i, "res://scenes/bullets/BulletSk6_1.xscn")
	finished = 1

func _process(delta):
	if (finished == 1):
		self.queue_free()