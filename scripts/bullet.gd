
extends KinematicBody2D

var target
var remaining
var speed = 1000.0
var direction

var movem

func _init():
	target = self.get_pos()-self.get_pos()
	set_fixed_process(true)

func _ready():
	print (self.get_child(2))
	movem = self.get_child(2)
	movem.speed = 1000.0

func _fixed_process(delta):
	if (movem.finished):
		self.queue_free()
	if (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		print(get_child(1).get_overlapping_bodies()[0].get_collision_mask())
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			print ("flag")
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(50)
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func setPosition(pos, dir):
	print (self.get_child(2).get_name())
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*400)
	self.set_transform(newTransform)
