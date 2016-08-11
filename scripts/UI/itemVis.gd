
extends Node2D

var index

func _ready():
	pass

func initItem (skillPre, idx):
	index = idx
	self.get_child(0).set_texture(skillPre.get_child(0).get_texture())
	self.get_child(0).set_z(10)
	skillPre.get_child(0).set_texture(null)
	skillPre.get_child(0).queue_free()

func startEditItem () :
	pass

func editGoUp () :
	pass

func editGoDown () :
	pass
