
extends Node2D

var shouldDraw = 1

func _ready():
	set_process(true)

func _draw():
	if (shouldDraw == 1):
		draw_empty_circle(Vector2(0,0), Vector2(50, 0), 6, 360 - 360*((OS.get_ticks_msec()/1000.0 - get_parent().skillCoolDown[0][1])/get_parent().skillCoolDown[0][0]), Color(180.0/255, 140.0/255, 150.0/255, 0.6))
		draw_empty_circle(Vector2(0,0), Vector2(75, 0), 6, 360 - 360*((OS.get_ticks_msec()/1000.0 - get_parent().skillCoolDown[1][1])/get_parent().skillCoolDown[1][0]), Color(239.0/255, 83.0/255, 80.0/255, 0.6))
		draw_empty_circle(Vector2(0,0), Vector2(100, 0), 6, 360 - 360*((OS.get_ticks_msec()/1000.0 - get_parent().skillCoolDown[2][1])/get_parent().skillCoolDown[2][0]), Color(236.0/255, 164.0/255, 122.0/255, 0.6))
		draw_empty_circle(Vector2(0,0), Vector2(125, 0), 6, 360 - 360*((OS.get_ticks_msec()/1000.0 - get_parent().skillCoolDown[3][1])/get_parent().skillCoolDown[3][0]), Color(171.0/255, 71.0/255, 188.0/255, 0.6))
		#draw_rect(Rect2(Vector2 (0,0), Vector2 (150, 150)), Color(130/255, 130/255, 130/255, 0.5))
		

func _process(delta):
	update()

func draw_empty_circle(circle_center, circle_radius, thickness, angle, color):
	var resolution = 5
	var draw_counter = resolution
	var line_origin = circle_radius + circle_center
	var line_end = line_origin

	while draw_counter <= angle:
		line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
		draw_line(line_origin, line_end, color, thickness)
		draw_counter += resolution
		line_origin = line_end

