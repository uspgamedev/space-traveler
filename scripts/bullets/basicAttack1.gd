
extends Node2D

var charges = 1
var finished = 0

func _init():
	set_process(true)

func _ready():
	pass

func setup (i) :
	if (get_parent().player.skillCharges[i] == -1) :
		get_parent().player.skillCharges[i] = charges
	get_parent().player.skillCharges[i] -= 1
	get_parent().setBullet(i, "res://scenes/bullets/Bullet.scn")
	finished = 1

func _process(delta):
	if (finished == 1):
		self.queue_free()
