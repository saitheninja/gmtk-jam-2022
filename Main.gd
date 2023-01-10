extends Node

export (PackedScene) var spawn_scene


func _ready():
	randomize()
	$UserInterface/Retry.show()


func _process(delta):
	$UserInterface/Score/TimerLabel.text = "%d" % $GameTimer.time_left
	
	if Input.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()


func _on_GameTimer_timeout():
	$MobTimer.autostart = false
	$Player.queue_free()
	$Player2.queue_free()
	$UserInterface/Retry.show()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		if $UserInterface/Retry.visible:
			$UserInterface/Retry.hide()
		else:
			$UserInterface/Retry.show()


func _on_SpawnTimer_timeout():
	var mob = spawn_scene.instance()

	# Choose a random location on the SpawnPath and give it a random offset.
	var mob_spawn_location = get_node("SpawnPath/SpawnLocation")
	mob_spawn_location.unit_offset = randf()

	var player_position = $Player.transform.origin
	mob.initialize(mob_spawn_location.translation, player_position)

	add_child(mob)


