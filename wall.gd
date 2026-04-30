extends StaticBody2D

# Placeholder to store the original colour of walls
var original_colour = Color.WHITE

func _ready() -> void:
	input_pickable = true
	

func setup(start_pos, end_pos, w, c):
	var center = (start_pos + end_pos) / 2.0
	global_position = center
	
	var length = start_pos.distance_to(end_pos)
	var angle = (end_pos - start_pos).angle()
	
	rotation = angle
	
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.size = Vector2(length, w)
	
	# Plots wall onto surface
	$Line2D.width = w
	$Line2D.default_color = c
	$Line2D.clear_points()
	$Line2D.add_point(Vector2(-length/2, 0))
	$Line2D.add_point(Vector2(length/2, 0))
	
	# Waits for wall to be fully drawn (safety)
	await get_tree().process_frame
	
	# Stores colour of wall
	original_colour = c

func _input_event(viewport, event, shape_idx):
	# Remove wall
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			queue_free()

func _input(event: InputEvent) -> void:
	# Remove all walls
	if event is InputEventKey:
		if event.keycode == KEY_X and  event.pressed:
			queue_free()

func get_wall_colour():
	return original_colour

func wall_flash(global_pos):
	# Flashes a white colour on the wall
	$Line2D.default_color = Color.WHITE
	
	await get_tree().create_timer(0.1).timeout
	
	$Line2D.default_color = original_colour

func play_note(colour):
	# Modulates pitch via colour, plays the note
	if colour == Color.YELLOW:
		$AudioStreamPlayer2D.pitch_scale = 1.2
	elif colour == Color.GREEN:
		$AudioStreamPlayer2D.pitch_scale = 1.0
	elif colour == Color.BLUE:
		$AudioStreamPlayer2D.pitch_scale = 0.8
	elif colour == Color.RED:
		$AudioStreamPlayer2D.pitch_scale = 0.6
	
	$AudioStreamPlayer2D.play()
