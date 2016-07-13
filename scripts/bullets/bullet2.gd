
extends KinematicBody2D

var target
var remaining
var speed = 400.0
var direction
var AD = 60.0
var crit = 30.0

var shooter

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
			if (randf() <= crit/(get_child(1).get_overlapping_bodies()[0].bar.armor + crit)):
				get_child(1).get_overlapping_bodies()[0].bar.takeDamage(40+AD, 1.5, direction)
			else :
				get_child(1).get_overlapping_bodies()[0].bar.takeDamage(40+AD, 1, direction)
		
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func setPosition(pos, dir):
	direction = dir
	var newTransform = Matrix32(0, pos)
	target = dir.normalized()*1600
	remaining = target
	self.set_transform(newTransform)

