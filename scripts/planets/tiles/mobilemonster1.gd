
extends KinematicBody2D

var period = 120
var count = 0
var bar
var movem
var minDist = 300
var maxDist = 800
var pos = Vector2(0.0,0.0)
var colVec = Vector2(0.0,0.0)
var norArm
var proArm

func _init():
	set_process(true)

func _ready():
	movem = self.get_child(0)
	movem.shouldRotate = false
	movem.setSpeed(260.0)
	var barScene = load("res://scenes/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(1200.0)
	add_child(bar)
	bar.AD +=50
	bar.luck +=60
	bar.armor +=110
	bar.shield +=110
	bar.vampirism += 0.1
	norArm = bar.armor
	proArm = bar.armor*2

func setPeriod (sp):
	period = 60*sp

func _process(delta):
	count += 1
	var dist = minDist
	if (bar.curHp < 0.5*bar.maxHp):
		bar.armor = proArm
		dist = maxDist
	else :
		bar.armor = norArm
	pos = self.get_parent().get_parent().player.get_pos() - self.get_parent().get_pos()
	colVec = Vector2(0.0,0.0)
	for i in self.get_child(3).get_overlapping_areas():
		if (i.get_collision_mask() == 12):
			colVec = (self.get_pos() - i.get_parent().get_pos())
			colVec = colVec.normalized()*(126-colVec.length())
			self.move(colVec)
	movem.moveTo(pos - dist*(pos - self.get_pos()).normalized())
	self.get_child(1).set_rot((pos - self.get_pos()).angle()+PI)
	if (count%period < 1):
		shot(pos+self.get_parent().get_pos())
	if (bar.curHp == 0):
		#self.get_parent().get_parent().player.skillPath[1] =  "res://scenes/bullets/Skill1.xscn"
		get_parent().get_parent().player.experience += 50
		self.get_parent().get_parent().save.save_game()
		self.get_parent().get_parent().save.load_game()
		self.queue_free()
	update()
	
func _draw():
	#draw_circle(Vector2(0,0), 63.0, Color(255.0/255, 160.0/255, 0.0/255, 0.5))
	pass

func shot (pos):
	var bulletScene = load("res://scenes/bullets/Bullet2.xscn")
	var bullet = bulletScene.instance()
	get_parent().add_child(bullet)
	bullet.setPosition(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y))
	pass