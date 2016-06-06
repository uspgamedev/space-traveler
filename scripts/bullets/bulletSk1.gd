
extends KinematicBody2D
var speed = 1000.0
var direction
var ndirection
var movem
var index
var charges = 1

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
			bullet.shoot(self.get_pos() + ndirection.normalized()*10 - direction.normalized()*10, ndirection, -1)
			ndirection = ndirection.rotated(-PI/32)
		
		self.queue_free()
	if (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(100+1.3*get_parent().player.AD,1, direction)
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(1.3*get_parent().player.AP,2, direction)
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func shoot (pos, dir, index):
	direction = dir
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	get_parent().player.skillCoolDown[index][2] = 1
	get_parent().player.skillCoolDown[index][1] = OS.get_ticks_msec()/1000.0
	direction = dir
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*200)
	self.set_transform(newTransform)
