
extends KinematicBody2D

var target
var remaining
var speed = 400.0
var direction

func _init():
	target = self.get_pos()-self.get_pos()
	set_fixed_process(true)

func _fixed_process(delta):
	remaining = remaining - target.normalized()*speed*delta
	if ((target - remaining).length() > target.length()):
		self.queue_free()
	else:
		var ds = target.normalized()*speed*delta
		direction = (target - self.get_pos()).normalized()
		move (ds)
	if (!get_child(1).get_overlapping_bodies().empty()):
		print(get_child(1).get_overlapping_bodies()[0].get_collision_mask())
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 6):
			print ("flag")
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(20)
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func setPosition(pos, dir):
	var newTransform = Matrix32(0, pos)
	target = dir.normalized()*400
	remaining = target
	self.set_transform(newTransform)

