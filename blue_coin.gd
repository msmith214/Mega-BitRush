extends Node2D

var value = 500

func _ready():
	if get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.FOUR:
		$AnimatedSprite2D.play("4_bit")
	elif get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.EIGHT:
		$AnimatedSprite2D.play("8_bit")
	elif get_parent().get_node("scute").cur_state == get_parent().get_node("scute").state.SIXTEEN:
		$AnimatedSprite2D.play("16_bit")

func _process(_delta):
	if get_parent().get_node("scute").magnetic:
		if get_parent().get_node("scute").position.distance_to(position) < 100:
			position.x = lerp(position.x, get_parent().get_node("scute").position.x, 0.1)
			position.y = lerp(position.y, get_parent().get_node("scute").position.y, 0.1)

func _on_body_entered(body):
	if "max_slides" in body:
		get_parent().score += value
		get_parent().get_node("4_grab").play()
		get_parent().get_node("8_grab").play()
		get_parent().get_node("16_grab").play()
		queue_free()
