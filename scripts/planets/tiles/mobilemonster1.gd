
extends KinematicBody2D

var period = 90
var count = 0
var bar
var movem
var minDist = 300
var maxDist = 600
var pos = Vector2(0.0,0.0)
var colVec = Vector2(0.0,0.0)
var norArm
var proArm
var STDSPEED = 200
var lastShot = 0.0

func _init():
	set_process(true)

func _ready():
	movem = self.get_child(0)
	movem.shouldRotate = false
	var barScene = load("res://scenes/UI/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(2000.0)
	add_child(bar)
	bar.setSpeed(200.0)
	bar.AD +=50
	bar.luck +=100
	bar.armor +=150
	bar.shield +=150
	bar.vampirism += 0.2
	norArm = bar.armor
	proArm = bar.armor*2
	period = 0.75

func setPeriod (sp):
	pass
	#period = 60*sp

func _process(delta):
	count += 1
	var dist = minDist
	if (bar.curHp < 0.5*bar.maxHp):
		#bar.armor = proArm
		dist = maxDist
	else :
		bar.armor = norArm
	pos = self.get_parent().get_parent().player.get_pos() - self.get_parent().get_pos()
	colVec = Vector2(0.0,0.0)
	
	movem.moveTo(pos - dist*(pos - self.get_pos()).normalized())
	self.get_child(1).set_rot((pos - self.get_pos()).angle()+PI)
	if (lastShot + period/(bar.speed/STDSPEED) <= OS.get_ticks_msec()/1000.0):
		lastShot = OS.get_ticks_msec()/1000.0
		shot(pos+self.get_parent().get_pos())
	if (bar.curHp == 0):
		get_parent().get_parent().player.getXP(50)
		self.get_parent().get_parent().save.save_game()
		self.queue_free()
	update()
	
func _draw():
	pass

func shot (pos):
	var bulletScene = load("res://scenes/bullets/Bullet2.xscn")
	var bullet = bulletScene.instance()
	get_parent().add_child(bullet)
	bullet.shoot(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y), self)
	#bullet.launch(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y), self.get_parent().get_parent().player, -1, self)
	pass