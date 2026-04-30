extends Node2D

@onready var preview = $PreviewLine

# Scenes
var wall_scene = preload("res://wall.tscn")
var boundary_scene = preload("res://boundary.tscn")

# Placeholder values
var start_pos = Vector2.ZERO
var drawing = false
var line_width = 10

func _ready() -> void:
	var w = get_viewport_rect().size.x
	var h = get_viewport_rect().size.y
	
	# Boundaries
	create_bound(Vector2(0, 0), Vector2(w, 0), line_width) # Top
	create_bound(Vector2(0, h), Vector2(w, h), line_width) # Bottom
	create_bound(Vector2(0, 0), Vector2(0, h), line_width) # Left
	create_bound(Vector2(w, 0), Vector2(w, h), line_width) # Right

func create_bound(a, b, w):
	var bound = boundary_scene.instantiate()
	add_child(bound)
	bound.setup(a, b, w)

func create_wall(a, b, w, c):
	var wall = wall_scene.instantiate()
	add_child(wall)
	wall.setup(a, b, w, c)
	call_deferred("add_child", wall)

func pick_colour(length, alpha) -> Color:
	var colour = Color.WHITE
	
	# Picks wall colour dependent on length
	if length < 150:
		colour = Color(1, 1, 0, alpha)
	elif length < 250:
		colour = Color(0, 1, 0, alpha)
	elif length < 450:
		colour = Color(0, 0, 1, alpha)
	else:
		colour = Color(1, 0, 0, alpha)
	return colour
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				start_pos = get_global_mouse_position()
				drawing = true
			else:
				var length = start_pos.distance_to(get_global_mouse_position())
				
				# Creates the wall
				drawing = false
				create_wall(start_pos, get_global_mouse_position(), line_width, pick_colour(length, 1.0))
				preview.clear_points()
	
	# Draws the wall preview
	if event is InputEventMouseMotion and drawing:
		var length = start_pos.distance_to(get_global_mouse_position())
		preview.width = line_width
		preview.default_color = pick_colour(length, 0.25)
		preview.clear_points()
		preview.add_point(start_pos)
		preview.add_point(get_global_mouse_position())
