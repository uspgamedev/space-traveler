
extends KinematicBody2D

var angle = 0

func _ready():
	set_fixed_process(true)
	pass
	
func _fixed_process(delta):
	if (!get_child(1).get_overlapping_bodies().empty()):
		for i in get_child(1).get_overlapping_bodies():
			if (i.get_collision_mask() == 12 and not (i in self.get_parent().doDamage)):
				self.get_parent().doDamage.append(i)
	if (self.get_parent().iniTime + self.get_parent().duration <= OS.get_ticks_msec()):
		set_fixed_process(false)
		self.get_parent().damage()
		self.queue_free()
	else:
		angle = float((OS.get_ticks_msec()-self.get_parent().iniTime))*((2*PI)/(float(self.get_parent().duration)))
		self.set_rot(-angle)
	update()

func _draw():
	draw_line(Vector2(0.0,0.0), Vector2(300.0,0.0), Color(102.0/255.0, 187.0/255.0, 106.0/255.0, 1.0), 5.0)