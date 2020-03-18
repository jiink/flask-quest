extends TextureRect

var level = 5

func setup(effect_in, level_in):
	name = effect_in + "Icon"
	texture = load("res://Engine/Battle/StatusEffects/Icons/Sprites/%s.png"
			% effect_in.to_lower())
	level = level_in
	$Label.text = int_to_roman(level)

func int_to_roman(num):  
	# storing roman values of digits from 0-9  
	# when placed at different places 
	var m = ["", "M", "MM", "MMM"]
	var c = ["", "C", "CC", "CCC", "CD", "D",  
					"DC", "DCC", "DCCC", "CM"]
	var x = ["", "X", "XX", "XXX", "XL", "L",  
					"LX", "LXX", "LXXX", "XC"]
	var i = ["", "I", "II", "III", "IV", "V",  
					"VI", "VII", "VIII", "IX"]
		
	# Converting to roman 
	var thousands = m[num/1000]
	var hundereds = c[(num%1000)/100]
	var tens =  x[(num%100)/10]
	var ones = i[num%10]
		
	var ans = thousands + hundereds + tens + ones
		
	return ans
