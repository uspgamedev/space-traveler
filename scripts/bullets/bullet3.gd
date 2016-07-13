
extends KinematicBody2D
var speed = 1000.0
var direction
var father
var charges = 1

var speedBoost = 30

var movem

var shooter

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished):
		father.shouldFree()
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			father.collideWith(get_child(1).get_overlapping_bodies()[0])
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			father.shouldFree()
			self.queue_free()

func shoot(pos, dir, ftr, shtr):
	shooter = shtr
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	father = ftr
	#get_parent().player.bar.takeBuff(30, 0, 1.0)
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*500)
	self.set_transform(newTransform)
