extends KinematicBody

signal goal

export var fall_acceleration = 75
export var bounce_impulse = 20
export var bump_impulse = 1
export var rotation_deg = 25
export var friction = 10
export var min_speed = 1
export var max_speed = 10

var velocity = Vector3.ZERO


# We will call this function from the Main scene.
func initialize(start_position, player_position):
	# We position the mob and turn it so that it looks at the player.
	look_at_from_position(start_position, player_position, Vector3.UP)
	# And rotate it randomly so it doesn't move exactly toward the player.
	rotate_y(rand_range(-PI / 4, PI / 4))
	# We calculate a random speed.
	var random_speed = rand_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD * random_speed
	# We then rotate the vector based on the mob's Y rotation to move in the direction it's looking.
	velocity = velocity.rotated(Vector3.UP, rotation.y)


func _physics_process(delta):
	# gravity
	velocity.y -= fall_acceleration * delta
	
	#friction
	if is_on_floor():
		velocity.y = bounce_impulse
		if velocity.x > friction:
			velocity.x -= friction
		if velocity.x <= friction:
			velocity.x = 0
		if velocity.z > friction:
			velocity.z -= friction
		if velocity.z <= friction:
			velocity.z = 0

	# check every collision that occurred this frame
	for index in range(get_slide_count()):
		var collision = get_slide_collision(index)

		if collision.collider.is_in_group("players"):
			velocity.x += collision.collider_velocity.x * bump_impulse
			velocity.z += collision.collider_velocity.z * bump_impulse
			velocity.y = bounce_impulse

		if collision.collider.is_in_group("goals"):
			emit_signal("goal")
			queue_free()

	velocity = move_and_slide(velocity, Vector3.UP)
