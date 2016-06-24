
extends Node2D

var charges = 1
var finished = 0
var index
var didHitLast = 0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 0.7
	get_parent().player.skillCoolDown[i][0] = 0.7
	get_parent().skills[i].append(self.get_path())

func setup (i) :
	set_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().setBullet(i, "res://scenes/bullets/Bullet.scn")
	finished = 1

func _process(delta):
	if (finished == 1):
		self.queue_free()
