
extends Node2D

var index
var endTime = 0.0
var bulDir
var period
var lastShot = 0
var bulDist

var shooter

func _ready():
	pass

func _process(delta):
	if not weakref(shooter).get_ref():
		self.queue_free()
	if (lastShot + period/(shooter.bar.speed/shooter.STDSPEED) <= OS.get_ticks_msec()/1000.0):
		lastShot = OS.get_ticks_msec()/1000.0
		var bulletScene = load("res://scenes/bullets/BulletSk12.xscn")
		var bullet1 = bulletScene.instance()
		get_parent().add_child(bullet1)
		bullet1.shoot(shooter.get_pos()+bulDist, bulDir.normalized(), index, shooter)
		
		bulletScene = load("res://scenes/bullets/BulletSk12.xscn")
		var bullet2 = bulletScene.instance()
		get_parent().add_child(bullet2)
		bullet2.shoot(shooter.get_pos()-bulDist, bulDir.normalized(), index, shooter)
	if endTime <= OS.get_ticks_msec()/1000.0:
		if (index != -1) :
			shooter.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
			shooter.skillCoolDown[index][2] = 1
			shooter.bar.projectileBlock = 0
		self.queue_free()

func shoot (pos, dir, idx, shtr):
	shooter = shtr
	bulDir = dir
	index = idx
	period = 0.5
	bulDist = bulDir.rotated(PI/2).normalized()*20
	shooter.skillPre[index].hitCount = 0
	endTime = 1.0+shooter.bar.AP/100.0+OS.get_ticks_msec()/1000.0
	shooter.bar.projectileBlock = 1
	set_process(true)
	
