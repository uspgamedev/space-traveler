
extends Label

var target
var remaining
var speed

func _ready():
	set_process(true)

func showDamage (damage, dir, nature):
	dir = dir.rotated(PI/9 - (randi()%40)*(PI/180.0))
	speed = 50000/(150+damage)
	target = dir.normalized() * (80.0*damage/(400.0+damage)+40.0)
	remaining = target
	self.set_text(str(int(damage)))
	if nature == 1 :
		self.add_color_override("font_color", Color(183.0/255, 28.0/255, 28.0/255, 0.8))
	elif nature == 2 :
		self.add_color_override("font_color", Color(98.0/255, 0.0/255, 234.0/255, 0.8))
	self.add_font_override("font", load("res://font32.fnt"))
	self.set_scale(Vector2(damage/(500.0+damage)+0.2, damage/(500.0+damage)+0.2))

func _process(delta):
	var ds
	remaining = remaining - target.normalized()*speed*delta
	if (target - remaining).length() < target.length():
		ds = target.normalized()*speed*delta
		set_pos(ds+self.get_pos())
	else :
		self.queue_free()
