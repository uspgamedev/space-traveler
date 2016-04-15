
extends KinematicBody2D
var speed = 1000.0
var direction

var movem

func _init():
	set_fixed_process(true)

func _ready():
	movem = self.get_child(2)
	movem.speed = 1000.0

func _fixed_process(delta):
	if (movem.finished):
		self.queue_free()
	if (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(50)
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func setPosition(pos, dir):
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*400)
	self.set_transform(newTransform)
