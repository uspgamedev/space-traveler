
extends KinematicBody2D

var period = 120
var count = 0
var target
var remaining
var speed = 200.0
var direction
var bar

func _init():
	set_process(true)

func _ready():
	var barScene = load("res://scenes/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(500.0)
	add_child(bar)


func setPeriod (sp):
	period = 60*sp

func _process(delta):
	count += 1
	var pos = self.get_parent().get_parent().get_child(0).get_pos()
	get_child(0).set_rot(atan2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y)+PI)
	target = Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y)
	remaining = Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y)
	var ds
	remaining = remaining - target.normalized()*speed*delta
	if (target - remaining).length() < target.length():
		ds = target.normalized()*speed*delta
		direction = (target - self.get_pos()).normalized()
		move(ds)
		if (is_colliding()):
			var n = get_collision_normal().slide(ds)
			move(n)
	if (count%period < 1):
		shot(pos)
	if (bar.curHp == 0):
		self.queue_free()

func shot (pos):
	var bulletScene = load("res://scenes/bullets/Bullet2.xscn")
	var bullet = bulletScene.instance()
	bullet.setPosition(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y))
	get_parent().add_child(bullet)
	pass