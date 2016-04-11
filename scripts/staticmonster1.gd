
extends RigidBody2D

var period = 30
var count = 0

var target
var remaining
var speed = 500.0
var direction

func _ready():
	set_process(true)
	pass

func setPeriod (sp):
	period = 60*sp

func _process(delta):
	count += 1
	var pos = self.get_parent().get_parent().get_child(0).get_pos()
	self.set_rot(atan2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y)+PI)
	
	if (count%period < 1):
		shot(pos)

func shot (pos):
	var bulletScene = load("res://scenes/bullets/Bullet1.scn")
	var bullet = bulletScene.instance()
	bullet.setPosition(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y))
	get_parent().add_child(bullet)
	pass