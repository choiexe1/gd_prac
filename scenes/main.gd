extends Control

@onready var iron_label: Label = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/MineSpace/MarginContainer/VBoxContainer/Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var output_upgrade: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/Upgrades/MarginContainer/VBoxContainer/OutputUpgrade
@onready var speed_upgrade: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/Upgrades/MarginContainer/VBoxContainer/SpeedUpgrade
@onready var auto_upgrade: Button = $MarginContainer/PanelContainer/MarginContainer/HBoxContainer/Upgrades/MarginContainer/VBoxContainer/AutoUpgrade

var iron: int = 0

var output: int = 1
var output_cost: float = 2.0

var speed: float = 1.0
var speed_cost: float = 3.0

var auto_cost: float = 80.0
var is_auto: bool = false

const COST_GROWTH: float = 1.2


func _ready() -> void:
	_update_all_labels()


func _on_button_pressed() -> void:
	_start_mining()


func _start_mining() -> void:
	if animation_player.is_playing():
		return
	animation_player.speed_scale = speed
	animation_player.play("mine")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	iron += output
	_update_all_labels()
	animation_player.seek(0, true)

	if is_auto:
		_start_mining()


func _on_output_upgrade_pressed() -> void:
	if iron < int(ceil(output_cost)):
		return
	iron -= int(ceil(output_cost))
	output_cost *= COST_GROWTH
	output *= 2
	_update_all_labels()


func _on_speed_upgrade_pressed() -> void:
	if iron < int(ceil(speed_cost)):
		return
	iron -= int(ceil(speed_cost))
	speed_cost *= COST_GROWTH
	speed += speed * 0.5
	_update_all_labels()


func _on_auto_upgrade_pressed() -> void:
	if is_auto:
		return
	if iron < int(ceil(auto_cost)):
		return
	iron -= int(ceil(auto_cost))
	is_auto = true
	_update_all_labels()
	_start_mining()


func _get_mine_duration() -> float:
	return animation_player.get_animation("mine").length / speed


func _update_all_labels() -> void:
	iron_label.text = "철: %d" % iron
	output_upgrade.text = "현재 철 출력: %d\n가격: %d" % [output, ceil(output_cost)]
	speed_upgrade.text = "채굴 시간: %.2fs\n가격: %d" % [_get_mine_duration(), ceil(speed_cost)]

	if is_auto:
		auto_upgrade.text = "자동 채굴: ON"
		auto_upgrade.disabled = true
	else:
		auto_upgrade.text = "자동 채굴\n가격: %d" % ceil(auto_cost)
