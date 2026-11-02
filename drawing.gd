extends Control

var is_mouse_in_drawing_area = false
var last_mouse_pos = Vector2()
var mouse_click_start_pos = null
var brush_size = 32
var brush_color = Color.BLACK
var brush_pos = Vector2()

@onready var drawing_area = $"../DrawingAreaBG"

func _process(_delta):
	var mouse_pos = get_viewport().get_mouse_position()

	# Check if the mouse is currently inside the canvas/drawing-area.
	var drawing_area_rect := Rect2(drawing_area.position, drawing_area.size)
	is_mouse_in_drawing_area = drawing_area_rect.has_point(mouse_pos)

	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		# If we do not have a position for when the mouse was first clicked, then this must
		# be the first time is_mouse_button_pressed has been called since the mouse button was
		# released, so we need to store the position.
		if mouse_click_start_pos == null:
			mouse_click_start_pos = mouse_pos

		# If the mouse is inside the canvas and the mouse is 1px away from the position of the mouse last _process call.
		if check_if_mouse_is_inside_canvas():
			if mouse_pos.distance_to(last_mouse_pos) >= 1:
				# If we are in pencil or eraser mode, then we need to draw.
				brush_pos = mouse_pos

	else:
		# If the mouse is inside the canvas.
		if check_if_mouse_is_inside_canvas():
			brush_pos = mouse_pos
		# Since we've released the left mouse, we need to get a new mouse_click_start_pos next time
		#is_mouse_button_pressed is true.
		mouse_click_start_pos = null

	# Store mouse_pos as last_mouse_pos now that we're done with _process.
	last_mouse_pos = mouse_pos

func check_if_mouse_is_inside_canvas() -> bool:
	if mouse_click_start_pos != null:
		if Rect2(drawing_area.position, drawing_area.size).has_point(mouse_click_start_pos):
			if is_mouse_in_drawing_area:
				return true
	return false
	

func _draw():
	draw_circle(brush_pos, brush_size / 2, brush_color)
