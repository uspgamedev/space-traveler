
extends KinematicBody2D

var period = 120
var count = 0
var bar
var movem

func _init():
	set_process(true)

func _ready():
	movem = self.get_child(0)
	movem.shouldRotate = true
	movem.setSpeed(200.0)
	movem.setRotScene(self.get_child(1))
	var barScene = load("res://scenes/HealthBar.scn")
	bar = barScene.instance()
	bar.initBar(800.0)
	add_child(bar)
	bar.armor +=100
	bar.shield +=100


func setPeriod (sp):
	period = 60*sp

func _process(delta):
	count += 1
	var pos = self.get_parent().get_parent().player.get_pos()
	movem.moveTo(pos - self.get_parent().get_pos())
	if (count%period < 1):
		shot(pos)
	if (bar.curHp == 0):
		self.get_parent().get_parent().player.skillPath[1] =  "res://scenes/bullets/Skill1.xscn"
		get_parent().get_parent().player.experience +=25
		get_parent().get_parent().player.getLevel()
		get_parent().get_parent().player.initSkill()
		self.get_parent().get_parent().save.save_game()
		self.queue_free()

func shot (pos):
	var bulletScene = load("res://scenes/bullets/Bullet2.xscn")
	var bullet = bulletScene.instance()
	get_parent().add_child(bullet)
	bullet.setPosition(self.get_pos(), Vector2(pos.x-self.get_pos().x-self.get_parent().get_pos().x, pos.y-self.get_pos().y-self.get_parent().get_pos().y))
	pass