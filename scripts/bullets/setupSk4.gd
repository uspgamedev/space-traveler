
extends Node2D

var bullet
var index
var charges = 1
var size = 30
var positions = [Vector2(0, 0)]
var collisions = []
var indicatorRadious = 8*3
var bullets = []
var endTime = 0.5
var slow
var bulDir

var shooter

func _ready():
	pass

func _process(delta):
	if endTime <= OS.get_ticks_msec()/1000.0:
		for i in collisions:
			if (weakref(i).get_ref()):
				i.movem.speedMulti *= 1/slow
		self.queue_free()
	update()

func _draw():
	var curIndicatorRadious = (endTime-OS.get_ticks_msec()/1000.0)*indicatorRadious
	for i in bullets:
		draw_circle(i.get_pos(), curIndicatorRadious, Color(178.0/255, 89.0/255, 255.0/255, 0.5))

func collideWith(object):
	for i in collisions:
		if (i == object):
			return
	var damage = 100+1.3*shooter.bar.AP
	if (weakref(object).get_ref()):
		slow = 1.0 - shooter.bar.luck/(object.bar.shield + shooter.bar.luck)-0.1
		object.bar.takeDamage(damage,2, bulDir)
		object.movem.speedMulti *= slow
	get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, -bulDir)
	get_parent().player.bar.takeHeal(shooter.bar.maxHp*(shooter.bar.vampirism), 0, -bulDir)
	collisions.append(object)

func shoot (pos, dir, index, shtr):
	shooter = shtr
	bulDir = dir
	slow = 0.1
	if (index != -1) :
		get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
		get_parent().player.skillCoolDown[index][2] = 1
		endTime += OS.get_ticks_msec()/1000.0
	set_process(true)
	var i
	bullet = load("res://scenes/bullets/BulletSk4.xscn")
	randomize()
	for i in range(size):
		for v in range(positions.size()):
			var shouldDivide = randi()%100
			print("rotation: ", get_parent().player.rotationVector)
			var direction = 20*(get_parent().player.rotationVector.rotated(0)).normalized().rotated(PI/3 - (randi()%120)*(PI/180.0))
			positions[v] += direction
			if shouldDivide < 6:
				var b = bullet.instance()
				positions.append(positions[v])
				add_child(b)
				b.setPos(positions[v] + get_parent().player.get_pos())
				bullets.append(b)
			else:
				var b = bullet.instance()
				add_child(b)
				b.setPos(positions[v] + get_parent().player.get_pos())
				bullets.append(b)

