extends Control

onready var healthBar : TextureProgress = $HealthBar
onready var ammoText : Label = $AmmoText
onready var scoreText : Label = $ScoreText

func update_health_bar(currentHP, maxHP):
	healthBar.max_value = maxHP
	healthBar.value = currentHP
	
func update_ammo_text(ammo):
	ammoText.text = "Ammo: " + str(ammo)
	
func update_score_text(score):
	scoreText.text = "Score: " + str(score) 
