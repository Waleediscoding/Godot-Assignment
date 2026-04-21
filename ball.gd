extends CharacterBody2D

var scaling = 0.1

func set_size(r):
	$CollisionShape2D.shape.radius = r * 4
	$Sprite2D.scale = Vector2(r/16.0, r/16.0)
	
func _ready() -> void:
	var center = get_viewport_rect().size / 2
	set_size(5)
	position = center


var speed = 500.0
var velocity_dir = Vector2(randf(), randf()).normalized()

func _physics_process(delta):
	var collision = move_and_collide(speed * velocity_dir * delta)
	if collision:
		velocity_dir = velocity_dir.bounce(collision.get_normal()).normalized()
		move_and_collide(velocity_dir * 1.0)
		var wall = collision.get_collider()
		
		if wall.has_method("wall_flash"):
			red_ball(wall.get_wall_colour())
			wall.wall_flash(collision.get_position())
			wall.play_note(wall.get_wall_colour())

func red_ball(colour):
	modulate = colour
	
	await get_tree().create_timer(0.1).timeout
	
	modulate = Color.WHITE
