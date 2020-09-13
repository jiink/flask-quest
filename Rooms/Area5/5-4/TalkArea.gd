extends Area2D

var tunnel_entered = false
var introduction_stated = false
var outtro_stated = false

func _on_TalkArea_body_entered(body):
	if body == global.get_player():
		var toilet_paper = get_node_or_null("../YSort/ToiletPaper")
		if toilet_paper == null:
			tunnel_entered = true

		if tunnel_entered and (not outtro_stated):
			$"../YSort/PrisonerFrog".post_dialogue()
			outtro_stated = true
		elif (not tunnel_entered) and (not introduction_stated):
			$"../YSort/PrisonerFrog".instruction_dialogue()
			introduction_stated = true

