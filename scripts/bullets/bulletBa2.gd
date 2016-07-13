
extends KinematicBody2D
var speed = 1000.0
var direction
var index
var charges = 1

var shooter

var speedBoost = 0

var movem


func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished):
		get_parent().player.movem.speedAdds -= speedBoost
		self.queue_free()
	elif (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			var damage = 0.8*shooter.bar.AD
			if (get_parent().player.skillPre[0].didUseSkill == 1):
				get_parent().player.bar.takeBuff(100, 0, 1.0)
				get_parent().player.skillPre[0].didUseSkill = 0
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(shooter.bar.AD*0.7, 1, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism, 0.5, shooter.get_pos() - self.get_pos())
				damage = get_child(1).get_overlapping_bodies()[0].bar.maxHp*(0.10+0.1/100.0*shooter.bar.AP)
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 2, direction)
				get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
				get_parent().player.bar.takeHeal(damage*(0.5), 0, shooter.get_pos() - self.get_pos())
			else :
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism, 0.5, shooter.get_pos() - self.get_pos())
				damage = shooter.bar.AP*0.3
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage, 2, direction)
				get_parent().player.bar.takeHeal(damage*shooter.bar.vampirism, 0.5, shooter.get_pos() - self.get_pos())
				print (shooter.bar.vampirism)
			print (shooter.bar.AD, shooter.bar.AP)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			get_parent().player.skillCoolDown[index][2] = 1
			get_parent().player.movem.speedAdds -= speedBoost
			self.queue_free()

func shoot(pos, dir, idx, shtr):
	shooter = shtr
	index = idx
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	get_parent().player.movem.speedAdds += speedBoost
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*500)
	self.set_transform(newTransform)

