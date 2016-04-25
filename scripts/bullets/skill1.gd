
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
	print (self.get_child(2))
	movem = self.get_child(2)
	movem.setSpeed(1000.0)
	for skill in get_parent().skills :
		if (skill[1] == (self.get_filename())):
			index = get_parent().skills.find(skill)
	print ("oi = ", get_parent().player.skillCharges[index])
	if (get_parent().player.skillCharges[index] == -1) :
		get_parent().player.skillCharges[index] = charges
	get_parent().player.skillCharges[index] -= 1
	print ("oioi = ", get_parent().player.skillCharges[index])

func _fixed_process(delta):
	if (movem.finished):
		var bulletScene = load("res://scenes/bullets/Bullet.scn")
		ndirection = direction.rotated(PI/8)
		for x in range(5) :
			var bullet = bulletScene.instance()
			self.get_parent().add_child(bullet)
			bullet.setPosition(self.get_pos() + ndirection.normalized()*80 - direction.normalized()*60, ndirection)
			ndirection = ndirection.rotated(-PI/16)
		
		self.queue_free()
	if (!get_child(1).get_overlapping_bodies().empty()):
		self.get_child(0).set_texture(null)
		#print(get_child(1).get_overlapping_bodies()[0].get_collision_mask())
		if (get_child(1).get_overlapping_bodies()[0].get_collision_mask() == 12):
			get_child(1).get_overlapping_bodies()[0].bar.takeDamage(100)
		self.queue_free()
	if (!get_child(1).get_overlapping_areas().empty()):
		self.get_child(0).set_texture(null)
		self.queue_free()

func setPosition(pos, dir):
	direction = dir
	movem.shouldRotate = true
	movem.setRotScene(self.get_child(0))
	print (self.get_child(2).get_name())
	var newTransform = Matrix32(0, pos)
	movem.moveTo(dir.normalized()*200)
	self.set_transform(newTransform)
