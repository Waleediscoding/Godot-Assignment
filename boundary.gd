extends StaticBody2D

func setup(a, b, w):
	var center = (a + b) / 2.0
	global_position = center
	
	var length = a.distance_to(b)
	var angle = (b - a).angle()
	
	rotation = angle
	
	$CollisionShape2D.shape = $CollisionShape2D.shape.duplicate()
	$CollisionShape2D.shape.size = Vector2(length, w)
	
	# Boundary plotted onto screen
	$Line2D.width = w
	$Line2D.default_color = Color.SILVER
	$Line2D.clear_points()
	$Line2D.add_point(Vector2(-length/2, 0))
	$Line2D.add_point(Vector2(length/2, 0))
