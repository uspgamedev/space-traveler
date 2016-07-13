
extends KinematicBody2D
var speed = 1000.0
var direction
var ndirection
var movem
var index
var charges = 1
var collisions = []
var queueCount = 0

var shooter

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	if (movem.finished):
		var bulletScene = load("res://scenes/bullets/Bullet3.xscn")
		ndirection = direction.rotated(PI/8)
		for x in range(8) :
			var bullet = bulletScene.instance()
			self.get_parent().add_child(bullet)
			bullet.shoot(self.get_pos() + ndirection.normalized()*10 - direction.normalized()*10, ndirection, self, shooter)
			ndirection = ndirection.rotated(-PI/32)
		get_parent().player.skillCoolDown[index][2] = 1
		set_fixed_process(false)
		self.get_child(0).set_texture(null)
		return
	if (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			var damage = 100+1.3*shooter.bar.AD
			if (randf() <= get_parent().player.bar.luck/(get_child(1).get_overlapping_bodies()[0].bar.armor + get_parent().player.bar.luck)):
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage,1.5, direction)
			else :
				damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage,1, direction)
			get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
			damage = 1.3*shooter.bar.AP
			damage = get_child(1).get_overlapping_bodies()[0].bar.takeDamage(damage,2, direction)
			shooter.bar.curHp += damage*(shooter.bar.vampirism)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() != 9):
			self.queue_free()

func collideWith(object):
	for i in collisions:
		if (i == object):
			var damage = 0.4*shooter.bar.AD
			if (randf() <= get_parent().player.bar.luck/(object.bar.armor + get_parent().player.bar.luck)):
				damage = object.bar.takeDamage(damage, 1.5, direction)
			else :
				damage = object.bar.takeDamage(damage, 1, direction)
			get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
			damage = object.bar.takeDamage(0.8*get_parent().player.bar.AP, 2, direction)
			get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
			return
	var damage = 1.0*shooter.bar.AD
	if (randf() <= get_parent().player.bar.luck/(object.bar.armor + get_parent().player.bar.luck)):
		damage = object.bar.takeDamage(damage, 1.5, direction)
	else :
		damage = object.bar.takeDamage(damage, 1, direction)
	get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
	damage = object.bar.takeDamage(1.0*get_parent().player.bar.AP, 2, direction)
	get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
	collisions.append(object)

func shouldFree():
	queueCount += 1
	if queueCount == 12 :
		queue_free()

func shoot (pos, dir, idx, shtr):
	shooter = shtr
	index = idx
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	direction = dir
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*200)
	self.set_transform(newTransform)
