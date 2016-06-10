
extends Node2D

var index

func _ready():
	pass

func initItem (skillPre):
	self.get_child(0).set_texture(skillPre.get_child(0).get_texture())
	skillPre.get_child(0).queue_free()
	
