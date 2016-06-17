
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

func setup (i) :
	set_fixed_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	get_parent().setBullet(i, "res://scenes/bullets/BulletSk7.xscn")
	self.queue_free()
