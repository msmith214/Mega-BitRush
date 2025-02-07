extends Node2D

var ground = 202
var rng = RandomNumberGenerator.new()
@export var cat_resource = load("res://cat.tscn")
@export var possum_resource = load("res://possum.tscn")
@export var bat_resource = load("res://bat.tscn")
@export var fox_resource = load("res://fox.tscn")
@export var orange_thing_resource = load("res://orange_thing.tscn")
@export var stop_sign_resource = load("res://stopsign.tscn")
@export var dave_resource = load("res://worker.tscn")
@export var blue_car_resource = load("res://blue_car.tscn")
@export var red_car_resource = load("res://red_car.tscn")
@export var green_coin_resource = load("res://green_coin.tscn")
@export var blue_coin_resource = load("res://blue_coin.tscn")
@export var red_coin_resource = load("res://red_coin.tscn")
@export var leaf_resource = load("res://leaf.tscn")
@export var acorn_resource = load("res://acorn.tscn")
@export var magnet_resource = load("res://magnet.tscn")
var score = 0
var high_score = 0
var auto = false
var entering_score = false


func _ready():
	randomize()
	$scute.switch($scute.state.SIXTEEN)
	$gimbal.velocity.x = 700
	get_tree().paused = true
	if (!PlayerAccounts.is_logged_in()):
		var success: bool = await PlayerAccounts.register_guest()

func _process(delta):
	if !get_tree().paused:
		$gimbal.move_and_slide()
		$gimbal/score.text = "Score: "+str(score)
		if score > high_score:
			high_score = score
		$gimbal/high_score.text = "Highest: "+str(high_score)
	if (Input.is_action_just_released("advance")):
		$gimbal/accept.play()
		
		if $gimbal/credit.visible:
			$gimbal/credit.visible = false
		elif $gimbal/title_card.visible:
			$gimbal/title_card.visible = false
			$run.stop()
			$"16_main_theme".play()
			$"8_main_theme".play()
			$"4_main_theme".play()
		elif $gimbal/camera/score_screen.visible:
			entering_score = false
			await Leaderboards.post_guest_score("bitrush-high_score-AZCm", score, $gimbal/camera/score_screen/name.text)
			$gimbal/camera/score_screen/name.text = ""
			$scute/respawn_timer.start()
			$gimbal/camera/score_screen.visible = false
		else:
			if $gimbal/pause_screen_continue.visible:
				get_tree().paused = false
				$gimbal/pause_screen_continue.visible = false
				$gimbal/pause_screen_quit.visible = false
			elif $gimbal/pause_screen_quit.visible:
				get_tree().quit()
	if (Input.is_action_pressed("jump") && get_tree().paused && !$gimbal/credit.visible && !$gimbal/title_card.visible):
		if $gimbal/instructions.visible:
			$gimbal/instructions.visible = false
			get_tree().paused = false
	if (Input.is_action_just_pressed("pause")):
		if (get_tree().paused):
			get_tree().paused = false
			$gimbal/pause_screen_continue.visible = false
			$gimbal/pause_screen_quit.visible = false
		else:
			get_tree().paused = true
			$gimbal/pause_screen_continue.visible = true
	if (Input.is_action_just_released("up")):
		if (get_tree().paused && $gimbal/pause_screen_quit.visible):
			$gimbal/pause_screen_continue.visible = true
			$gimbal/pause_screen_quit.visible = false
		else:
			$scute.max_volume = min(0, $scute.max_volume+10)
			for sound in get_tree().get_nodes_in_group("sound"):
				if sound.volume_db != -80:
					sound.volume_db = $scute.max_volume
	if (Input.is_action_just_released("down")):
		if (get_tree().paused && $gimbal/pause_screen_continue.visible):
			$gimbal/pause_screen_continue.visible = false
			$gimbal/pause_screen_quit.visible = true
		else:
			$scute.max_volume = max(-70, $scute.max_volume-10)
			for sound in get_tree().get_nodes_in_group("sound"):
				if sound.volume_db != -80:
					sound.volume_db = $scute.max_volume
	if (Input.is_action_just_pressed("leaderboard") && !$gimbal/credit.visible && !$gimbal/title_card.visible && !$gimbal/instructions.visible):
		if (!$gimbal/camera/score_screen.visible):
			show_leaderboard(false)
		elif (!entering_score):
			$gimbal/camera/score_screen.visible = false
			get_tree().paused = false

func _on_enemy_timer_timeout():
	var chance = rng.randi() % 100
	if chance < 15:
		var cat = cat_resource.instantiate()
		cat.position.x = $scute.position.x + 960
		cat.position.y = 208
		add_child(cat)
	elif chance < 25:
		var fox = fox_resource.instantiate()
		fox.position.x = $scute.position.x + 960
		fox.position.y = 192
		add_child(fox)
	elif chance < 40:
		var possum = possum_resource.instantiate()
		possum.position.x = $scute.position.x + 960
		possum.position.y = 216
		add_child(possum)
	elif chance < 45:
		var bat = bat_resource.instantiate()
		bat.position.x = $scute.position.x + 960
		bat.position.y = 64
		add_child(bat)
	elif chance < 55:
		var orange_thing = orange_thing_resource.instantiate()
		orange_thing.position.x = $scute.position.x + 960
		orange_thing.position.y = 200
		add_child(orange_thing)
	elif chance < 75:
		var stop_sign = stop_sign_resource.instantiate()
		stop_sign.position.x = $scute.position.x + 960
		stop_sign.position.y = 180
		add_child(stop_sign)
	elif chance < 85:
		var dave = dave_resource.instantiate()
		dave.position.x = $scute.position.x + 960
		dave.position.y = 192
		add_child(dave)
	elif chance < 95:
		var blue_car = blue_car_resource.instantiate()
		blue_car.position.x = $scute.position.x + 960
		blue_car.position.y = 200
		add_child(blue_car)
	elif chance < 100:
		var red_car = red_car_resource.instantiate()
		red_car.position.x = $scute.position.x + 960
		red_car.position.y = 200
		add_child(red_car)
	$enemy_timer.start(rng.randf_range(0.8, 1.5))

func _on_coin_timer_timeout():
	var chance = rng.randi() % 9
	if chance < 5:
		var green_coin = green_coin_resource.instantiate()
		green_coin.position.x = $scute.position.x + 960
		green_coin.position.y = ((rng.randi() % 6) + 2) * 30
		add_child(green_coin)
	elif chance < 8:
		var blue_coin = blue_coin_resource.instantiate()
		blue_coin.position.x = $scute.position.x + 960
		blue_coin.position.y = ((rng.randi() % 6) + 2) * 30
		add_child(blue_coin)
	elif chance < 9:
		var red_coin = red_coin_resource.instantiate()
		red_coin.position.x = $scute.position.x + 960
		red_coin.position.y = ((rng.randi() % 6) + 2) * 30
		add_child(red_coin)
	$coin_timer.start(rng.randf_range(0.3, 0.7))

func _on_powerup_timer_timeout():
	var chance = rng.randi() % 9
	if chance < 5:
		var leaf = leaf_resource.instantiate()
		leaf.position.x = $scute.position.x + 960
		leaf.position.y = ((rng.randi() % 6) + 2) * 30
		add_child(leaf)
	elif chance < 8:
		var magnet = magnet_resource.instantiate()
		magnet.position.x = $scute.position.x + 960
		magnet.position.y = ((rng.randi() % 6) + 2) * 30
		add_child(magnet)
	elif chance < 9:
		var acorn = acorn_resource.instantiate()
		acorn.position.x = $scute.position.x + 960
		acorn.position.y = ((rng.randi() % 6) + 2) * 30
		add_child(acorn)
	$powerup_timer.start(rng.randf_range(5, 10))

func _on_score_timer_timeout():
	score += 10
	
func _on_credit_animation_finished():
	$gimbal/credit.visible = false
	
func _on_respawn_timer_timeout():
	$scute.switch($scute.state.SIXTEEN)
	get_tree().paused = false
	get_tree().call_group("obstacles", "queue_free")
	get_tree().call_group("pickups", "queue_free")
	$scute.position.x = 40
	$scute.position.y = ground
	$gimbal.position.x = 0
	$gimbal.position.y = 0
	$gimbal/camera/loss.visible = false
	$gimbal/state_indicator.rotation = 0
	score = 0

func show_leaderboard(enter_score):
	if (!get_tree().paused):
		get_tree().paused = true
	if (!enter_score):
		$gimbal/camera/score_screen/title.text = "Leaderboard"
		$gimbal/camera/score_screen/name.visible = false
		$gimbal/camera/score_screen/new_score.visible = false
	else:
		$gimbal/camera/score_screen/title.text = "New High Score!"
		$gimbal/camera/score_screen/name.visible = true
		$gimbal/camera/score_screen/new_score.visible = true
		$gimbal/camera/score_screen/new_score.text = ": "+str(score)
		entering_score = true
	var board = ""
	var scores_dict = await Leaderboards.get_scores("bitrush-high_score-AZCm")
	var scores = scores_dict.get("scores")
	for this_score in scores:
		board += this_score["name"].substr(0, this_score["name"].length()-1)+": "+str(this_score["score"])+"\n"
	$gimbal/camera/score_screen/leaderboard.text = board
	$gimbal/camera/score_screen.visible = true


func _on_auto_jump_timer_timeout():
	if (auto):
		$scute.velocity.y -= $scute.jump_force * 1.9
		$scute/jump.play()
		$scute.move_and_slide()
	$scute/auto_jump_timer.start(rng.randf_range(2, 7))
