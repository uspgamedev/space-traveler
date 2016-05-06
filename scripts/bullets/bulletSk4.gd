
extends Area2D

func _ready():
	set_fixed_process(true)
	
func setPos(pos):
	self.set_pos(pos)

func _fixed_process(delta):
	if (!self.get_overlapping_bodies().empty()):
		if (self.get_overlapping_bodies()[0].get_collision_mask() == 12):
			get_parent().collideWith(self.get_overlapping_bodies()[0])
	if (!self.get_overlapping_areas().empty()):
		pass
