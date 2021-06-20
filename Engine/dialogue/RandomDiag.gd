extends "res://NPC/NPCBasic/NPCBasic.gd"

var firsts = [
	"I was", "I am", "I will be", "You were", "You are", "You'll be",
	"We are", "We aren't", "We'll be", "We'll'nt be", "I wish I was"
]

var seconds = [
	"eating at", "sleeping at", "going to", "dying in", "exploding",
	"marrying a person in", "watching him die in", "falling out of"
]

var thirds = [
	"the store", "Scarlette Cafe", "Poppyhart", "Glasstown",
	"Purple's place", "the sky", "a world of pain", "a traincar"
]

func interact():
	randomize()
	var first_word = randi() % firsts.size()
	var second_word = randi() % seconds.size()
	var third_word = randi() % thirds.size()
	
#	print(firsts[first_word], " ",
#	 seconds[second_word], " ", thirds[third_word])
	var new_message = "%s %s %s." % [String(firsts[first_word]),
	String(seconds[second_word]), String(thirds[third_word])]
	
	$DialogueTree/DiagPiece.message = new_message
	DiagHelper.start_talk(self, "DiagPiece")

#	$DialogueTree/DiagPiece.message = "%s %s %s." % firsts[first_word] % \
#	 seconds[second_word] % thirds[third_word]
