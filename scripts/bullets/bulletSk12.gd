
extends KinematicBody2D
var speed = 1000.0
var direction
var index

var shooter

var speedBoost = 0

var movem


func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished):
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			var damage = 0.5*shooter.bar.AD*(1+shooter.skillPre[index].hitCount/20.0)
			var critChance = get_parent().player.bar.luck/(get_child(1).get_overlapping_bodies()[0].bar.armor + get_parent().player.bar.luck)
			if (randf() <= critChance):
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1.5, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*1.0, 0.5, shooter.get_pos() - self.get_pos())
			else :
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism*1.0, 0.5, shooter.get_pos() - self.get_pos())
			damage = shooter.bar.AP*0.6
			damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 2, direction)
			shooter.bar.takeHeal(damage*shooter.bar.vampirism, 0.5, shooter.get_pos() - self.get_pos())
			shooter.skillPre[index].hitCount += 1
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			self.queue_free()

func shoot(pos, dir, idx, shtr):
	shooter = shtr
	index = idx
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(900.0+shooter.bar.AD)
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*(400+2*shooter.bar.AP))
	self.set_transform(newTransform)
