extends Label

var score_left = 0
var score_right = 0


func on_Left_goal():
	score_left += 1
	text = "%s vs %s" % [score_left, score_right]


func on_Right_goal():
	score_right += 1
	text = "%s vs %s" % [score_left, score_right]


func _on_GoalLeftArea_body_entered(body):
	if body.is_in_group("dice"):
		on_Left_goal()
		body.queue_free()


func _on_GoalRightArea_body_entered(body):
	if body.is_in_group("dice"):
		on_Right_goal()
		body.queue_free()
