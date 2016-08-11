
extends KinematicBody2D

var speed = 1000.0
var direction
var ndirection
var movem
var index
var charges = 1
var acel = 700.0;
var alreadyCollided = []
var indicatorRadious = 20;

var shooter

func _init():
	set_fixed_process(true)

func _ready():
	pass

func _fixed_process(delta):
	var pos = self.get_parent().player.get_pos()
	movem.moveTo(pos)
	movem.setSpeed(movem.speed0+acel*delta)
	acel+=15.0
	if (movem.finished):
		self.queue_free()
	if (!get_child(1).get_overlapping_bodies().empty()):
		for i in get_child(1).get_overlapping_bodies():
			if (i.get_collision_mask() == 12 and not (i in alreadyCollided)):
				var damage = acel/100.0*(10+0.09*shooter.bar.AP) + 0.4*shooter.bar.AP
				damage = i.bar.takeDamage(damage, 2, direction)
				get_parent().player.bar.takeHeal(damage*(shooter.bar.vampirism), 0.5, shooter.get_pos() - self.get_pos())
				alreadyCollided.append(i)
	for j in alreadyCollided:
		if (not j in get_child(1).get_overlapping_bodies()):
			alreadyCollided.remove(alreadyCollided.find(j))
	if (!get_child(1).get_overlapping_areas().empty()):
		pass
	update()

func _draw():
	draw_circle(Vector2(0,0), indicatorRadious, Color((255.0*((acel-500.0)/acel)/255.0), 80.0/255, 80.0/255, 0.8))

func shoot (pos, dir, index, shtr):
	shooter = shtr
	movem = self.get_child(2)
	movem.setSpeed(-700.0)
	get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	direction = dir
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	var newTransform = Matrix32(0, pos)
	self.set_transform(newTransform)
	self.set_pos(pos+dir.normalized()*50)
	movem.moveTo(self.get_parent().player.get_pos())
