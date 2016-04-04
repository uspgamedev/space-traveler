
extends RigidBody2D

var period = 60
var count = 0

func _ready():
	set_process(true)
	pass

func setPeriod (sp):
	period = 60*sp

func _process(delta):
	count += 1
	if (count%period < 1):
		var pos = self.get_parent().get_parent().get_child(0).get_pos()
		shot(pos)

func shot (pos):
	self.set_rot(atan2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y)+PI)
	var bulletScene = load("res://scenes/bullets/Bullet1.scn")
	var bullet = bulletScene.instance()
	bullet.setPosition(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y))
	get_parent().add_child(bullet)
	print("xupa pedro",pos)
	pass