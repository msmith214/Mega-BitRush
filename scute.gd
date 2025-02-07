extends CharacterBody2D

var gravity = 30
var jump_force = 1200
var speed = 700
var speed_delta = 300
enum state {FOUR, EIGHT, SIXTEEN}
var cur_state = state.SIXTEEN
var invincible = false
var rng = RandomNumberGenerator.new()
var max_volume = 0
var double_jumps = 0
var one_ups = 0
var magnetic = false

func _ready():
	randomize()
	switch(state.SIXTEEN)

func _process(_delta):
	velocity.x = speed
	if (position.y < get_parent().ground):
		velocity.y += gravity
	else:
		velocity.y = 0
	if velocity.y > 0 && cur_state == state.SIXTEEN:
		velocity.y -= gravity/4 * 3
		if (position.y < 190):
			$animation.play("glide")
		else:
			$animation.play("big_run")
	
	if (cur_state == state.FOUR):
		get_parent().get_node("4_main_theme").volume_db = max_volume
	elif (cur_state == state.EIGHT):
		get_parent().get_node("8_main_theme").volume_db = max_volume
	elif (cur_state == state.SIXTEEN):
		get_parent().get_node("16_main_theme").volume_db = max_volume
	
	if (Input.is_action_just_pressed("cycle_up")):
		get_parent().get_node("gimbal/state_indicator").rotate_left()
		if (cur_state == state.FOUR):
			switch(state.EIGHT)
		elif (cur_state == state.EIGHT):
			switch(state.SIXTEEN)
		elif (cur_state == state.SIXTEEN):
			switch(state.FOUR)
	if (Input.is_action_just_pressed("cycle_down")):
		get_parent().get_node("gimbal/state_indicator").rotate_right()
		if (cur_state == state.FOUR):
			switch(state.SIXTEEN)
		elif (cur_state == state.EIGHT):
			switch(state.FOUR)
		elif (cur_state == state.SIXTEEN):
			switch(state.EIGHT)
	if (Input.is_action_pressed("move_right")):
		velocity.x += speed_delta
	if (Input.is_action_pressed("move_left")):
		velocity.x -= speed_delta
	if (Input.is_action_just_pressed("jump") && ((position.y >= get_parent().ground) or (double_jumps > 0))):
		if (double_jumps > 0 && position.y < get_parent().ground):
			double_jumps -= 1
		velocity.y -= jump_force
		$jump.play()
		var chance = rng.randi() % 20
		if chance == 0:
			$flip_timer.start()
	if (!$flip_timer.is_stopped()):
		rotation = lerp(deg_to_rad(0), deg_to_rad(360), $flip_timer.time_left*2)
	else:
		rotation = 0

	if (!Input.is_action_pressed("jump") && position.y < get_parent().ground):
		velocity.y += 80

	position.y = clamp(position.y, 0, get_parent().ground)

	move_and_slide()
	
	get_parent().get_node("gimbal/double_jumps/Label").text = str(double_jumps)
	get_parent().get_node("gimbal/one_ups/Label").text = str(one_ups)
	if !$magnet_timer.is_stopped():
		if ($magnet_timer.time_left < 10):
			get_parent().get_node("gimbal/magnet/Label").text = "0:0"+str($magnet_timer.time_left).substr(0, 1)
		else:
			get_parent().get_node("gimbal/magnet/Label").text = "0:"+str($magnet_timer.time_left).substr(0, 2)
	else:
		get_parent().get_node("gimbal/magnet/Label").text = "-:--"
		
	if (get_parent().auto):
		for obstacle in get_tree().get_nodes_in_group("obstacles"):
			if position.distance_to(obstacle.position) < 100 && obstacle.position.x > position.x-50:
				if obstacle in get_tree().get_nodes_in_group("animals"):
					switch(state.FOUR)
				elif obstacle in get_tree().get_nodes_in_group("signs"):
					switch(state.EIGHT)
				elif obstacle in get_tree().get_nodes_in_group("people"):
					switch(state.SIXTEEN)

func switch(to):
	invincible = true
	$i_frame_timer.start()
	cur_state = to
	if to == state.FOUR:
		$animation.play("small_run", true)
		#hitboxes
		$small_hitbox.disabled = false
		$mid_hitbox.disabled = true
		$big_hitbox.disabled = true
		#themes
		get_parent().get_node("4_main_theme").volume_db = max_volume
		get_parent().get_node("8_main_theme").volume_db = -80
		get_parent().get_node("16_main_theme").volume_db = -80
		#soundbytes
		get_parent().get_node("4_grab").volume_db = max_volume
		get_parent().get_node("8_grab").volume_db = -80
		get_parent().get_node("16_grab").volume_db = -80
		#backgrounds
		get_tree().call_group("backgrounds", "play", "4_bit")
		#obstacles
		get_tree().call_group("sprites", "play", "4_bit")
		#indicators
		get_parent().get_node("gimbal/animal_indicator/nope").visible = false
		get_parent().get_node("gimbal/sign_indicator/nope").visible = true
		get_parent().get_node("gimbal/car_indicator/nope").visible = true
	elif to == state.EIGHT:
		$animation.play("mid_run", true)
		#hitboxes
		$small_hitbox.disabled = true
		$mid_hitbox.disabled = false
		$big_hitbox.disabled = true
		#themes
		get_parent().get_node("4_main_theme").volume_db = -80
		get_parent().get_node("8_main_theme").volume_db = max_volume
		get_parent().get_node("16_main_theme").volume_db = -80
		#soundbytes
		get_parent().get_node("4_grab").volume_db = -80
		get_parent().get_node("8_grab").volume_db = max_volume
		get_parent().get_node("16_grab").volume_db = -80
		#backgrounds
		get_tree().call_group("backgrounds", "play", "8_bit")
		#obstacles
		get_tree().call_group("sprites", "play", "8_bit")
		#indicators
		get_parent().get_node("gimbal/animal_indicator/nope").visible = true
		get_parent().get_node("gimbal/sign_indicator/nope").visible = false
		get_parent().get_node("gimbal/car_indicator/nope").visible = true
	elif to == state.SIXTEEN:
		$animation.play("big_run", true)
		#hitboxes
		$small_hitbox.disabled = true
		$mid_hitbox.disabled = true
		$big_hitbox.disabled = false
		#themes
		get_parent().get_node("4_main_theme").volume_db = -80
		get_parent().get_node("8_main_theme").volume_db = -80
		get_parent().get_node("16_main_theme").volume_db = max_volume
		#soundbytes
		get_parent().get_node("4_grab").volume_db = -80
		get_parent().get_node("8_grab").volume_db = -80
		get_parent().get_node("16_grab").volume_db = max_volume
		#backgrounds
		get_tree().call_group("backgrounds", "play", "16_bit")
		#obstacles
		get_tree().call_group("sprites", "play", "16_bit")
		#indicators
		get_parent().get_node("gimbal/animal_indicator/nope").visible = true
		get_parent().get_node("gimbal/sign_indicator/nope").visible = true
		get_parent().get_node("gimbal/car_indicator/nope").visible = false

func die():
	if (one_ups > 0):
		one_ups -= 1
		get_parent().get_node("gimbal/camera/loss/death_sound").play()
		invincible = true
		$i_frame_timer.start()
	else:
		get_tree().paused = true
		get_parent().get_node("gimbal/camera/loss").visible = true
		get_parent().get_node("gimbal/camera/loss/death_sound").play()
		double_jumps = 0
		magnetic = false
		$magnet_timer.stop()
		var leaderboard = await Leaderboards.get_scores("bitrush-high_score-AZCm", Leaderboards.ScoreFilter.ALL, 9, 10)
		var scores_dict = leaderboard["scores"]
		var tenth_highest = 0
		if (scores_dict.size() > 0):
			tenth_highest = scores_dict[min(scores_dict.size()-1, 9)]["score"]
		if (get_parent().score > tenth_highest):
			get_parent().show_leaderboard(true)
		else: 
			$respawn_timer.start()

func _on_magnet_timer_timeout():
	magnetic = false

func _on_i_frame_timer_timeout():
	invincible = false

