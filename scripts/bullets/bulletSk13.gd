
extends KinematicBody2D
var speed = 1000.0
var direction
var index

var shooter
var target

var speedBoost = 0

var alreadyCollided = []
var indicatorRadious = 20;

var movem


func _init():
	pass

func _ready():
	pass


func _process(delta):
	direction = direction.rotated(direction.angle_to(target.get_global_pos()-get_global_pos())*delta)
	movem.moveTo(direction*20)
	if (movem.finished):
		self.queue_free()
	if (!get_child(0).get_overlapping_bodies().empty()):
		for i in get_child(0).get_overlapping_bodies():
			if (i.get_collision_mask() == 6 and not (i in alreadyCollided)):
				var damage = 0.5*shooter.bar.AD
				var critChance = shooter.bar.luck/(get_child(0).get_overlapping_bodies()[0].bar.armor + shooter.bar.luck)
				if (randf() <= critChance):
					damage = get_child(0).get_overlapping_bodies()[0].bar.takeDamage(damage, 1.5, direction)
					shooter.bar.takeHeal(damage*shooter.bar.vampirism*1.0, 0.5, shooter.get_pos() - self.get_pos())
				else :
					damage = get_child(0).get_overlapping_bodies()[0].bar.takeDamage(damage, 1, direction)
					shooter.bar.takeHeal(damage*shooter.bar.vampirism*1.0, 0.5, shooter.get_pos() - self.get_pos())
				damage = shooter.bar.AP*0.6
				damage = get_child(0).get_overlapping_bodies()[0].bar.takeDamage(damage, 2, direction)
				shooter.bar.takeHeal(damage*shooter.bar.vampirism, 0.5, shooter.get_pos() - self.get_pos())
	for j in alreadyCollided:
		if (not j in get_child(0).get_overlapping_bodies()):
			alreadyCollided.remove(alreadyCollided.find(j))
	if (!get_child(0).get_overlapping_areas().empty()):
		pass
	update()

func _draw():
	draw_circle(Vector2(0,0), indicatorRadious, Color(80/255.0, 80.0/255, 160.0/255, 0.8))

func launch(pos, dir, trgt, idx, shtr):
	if not weakref(trgt).get_ref():
		self.queue_free()
	shooter = shtr
	target = trgt
	index = idx
	direction = dir.normalized()
	set_process(true)
	movem = self.get_child(1)
	movem.setSpeed(900.0)
	var newTransform = Matrix32(0, pos)
	movem.moveTo(direction*20)
	self.set_transform(newTransform)