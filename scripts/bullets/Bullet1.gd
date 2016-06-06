
extends KinematicBody2D

var target
var remaining
var speed = 100.0
var direction
var movem

func _init():
	target = self.get_pos()-self.get_pos()
	set_fixed_process(true)


func _ready():
	movem = self.get_child(2)
	movem.speed = 500.0

func _fixed_process(delta):
	if (movem.finished):
		self.queue_free()
	else:
		var ds = target.normalized()*speed*delta
		move (ds)
	if (!get_child(1).get_overlapping_bodies().empty()):
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 6):
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(50,1, direction)
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func setPosition(pos, dir):
	direction = dir
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*1600)
	self.set_transform(newTransform)

