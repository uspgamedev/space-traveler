
extends Node2D

var bullet
var index
var charges = 1
var size = 30
var positions = [Vector2(0, 0)]
var collisions = []
var indicatorRadious = 8
var bullets = []
var endTime = 0.25

func setup(i):
	var initTime = OS.get_ticks_msec()/1000.0
	endTime += initTime
	get_parent().player.skillCoolDown[i][1] = OS.get_ticks_msec()/1000.0
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

func _process(delta):
	if endTime <= OS.get_ticks_msec()/1000.0:
		self.queue_free()
	update()

func _ready():
	set_process(true)
	for skill in get_parent().skills :
		if (skill[1] == (self.get_filename())):
			index = get_parent().skills.find(skill)
	if (get_parent().player.skillCharges[index] == -1) :
		get_parent().player.skillCharges[index] = charges
	get_parent().player.skillCharges[index] -= 1
	
func _draw():
	if (indicatorRadious > 0):
		for i in bullets:
			draw_circle(i.get_pos(), indicatorRadious, Color(178.0/255, 89.0/255, 255.0/255, 0.5))
		indicatorRadious -= 1
	
func collideWith(object):
	for i in collisions:
		if (i == object):
			return
	object.bar.takeDamage(200)
	collisions.append(object)
	
func setPosition(pos, dir):
	pass
