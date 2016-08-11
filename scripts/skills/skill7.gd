
extends Node2D

var finished = 0

var index

var didUseSkill = 0

func _init():
	pass

func _ready():
	pass

func preSetup (i) :
	index = i
	get_parent().player.skillCoolDown[i][2] = 1
	get_parent().player.skillCoolDown[i][1] = - 7.0
	get_parent().player.skillCoolDown[i][0] = 7.0
	get_parent().skills[i].append(self.get_path())
	get_parent().player.bar.takeBuff(60, 0, -(index+1))
	get_parent().player.bar.takeBuff(40, 3, -(index+1))

func setup (i, caster) :
	set_process(true)
	self.get_child(0).queue_free()
	index = i
	get_parent().player.skillCoolDown[index][2] = 0
	#get_parent().setBullet(i, "res://scenes/bullets/BulletSk7.xscn")
	#(get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2).normalized()
	var bulletScene = load("res://scenes/bullets/BulletSk7.xscn")
	var bullet = bulletScene.instance()
	get_parent().add_child(bullet)
	bullet.shoot(caster.get_pos(),(get_viewport().get_mouse_pos()-get_viewport().get_rect().size/2).normalized(), index, caster)
	return 0

func _process(delta):
	self.queue_free()