extends Area2D

func _ready():
	if get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.FOUR:
		$AnimatedSprite2D.play("4_bit")
	elif get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.EIGHT:
		$AnimatedSprite2D.play("8_bit")
	elif get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.SIXTEEN:
		$AnimatedSprite2D.play("16_bit")

func _on_body_entered(body):
	if "max_slides" in body:
		if (body.one_ups < 5):
			body.one_ups += 1
			get_parent().get_node("4_grab").play()
			get_parent().get_node("8_grab").play()
			get_parent().get_node("16_grab").play()
			queue_free()
