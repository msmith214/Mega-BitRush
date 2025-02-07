extends Area2D

func _ready():
	if get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.FOUR:
		$AnimatedSprite2D.play("4_bit")
	elif get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.EIGHT:
		$AnimatedSprite2D.play("8_bit")
	elif get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.SIXTEEN:
		$AnimatedSprite2D.play("16_bit")
		
func _process(_delta):
	position.x -= 4

func _on_body_entered(body):
	if "max_slides" in body && body.cur_state != get_parent().get_node("scute").state.SIXTEEN:
		if body.velocity.y > 0:
			body.velocity.y *= -1
		else:
			body.die()
