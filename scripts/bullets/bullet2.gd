
extends KinematicBody2D

var target
var remaining
var speed = 400.0
var direction
var AD = 60.0
var crit = 20.0

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
			if weakref(shooter).get_ref() :
				var damage = 1.5*shooter.bar.AD
				get_child(1).get_overlapping_bodies()[0].bar.takeNerf(1.3, 0.5 , 1.5)
				if (randf() <= crit/(get_child(1).get_overlapping_bodies()[0].bar.armor + crit)):
					damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1.5, direction)
					shooter.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
				else :
					damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
					shooter.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
			else :
				var damage = 1.5*AD
				if (randf() <= crit/(get_child(1).get_overlapping_bodies()[0].bar.armor + crit)):
					damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1.5, direction)
				else :
					damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
		
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func shoot(pos, dir, shtr):
	direction = dir
	shooter = shtr
	var newTransform = Matrix32(0, pos)
	AD = shooter.bar.AD
	target = dir.normalized()*600
	remaining = target
	self.set_transform(newTransform)

