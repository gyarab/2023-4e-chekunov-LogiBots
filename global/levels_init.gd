extends Node

"""
saves:
1. (1,[Vector2(5,5)],[],[],[],[Vector2(10,5)],"movement","move to the plate")
2. 
3. (3,[Vector2(3,4)],borders,[[Vector2(10,5),0]],[[Vector2(5,5),-12057]],[],"first counting!","take number from red speaker double it and say it to the green one")
4. (4,[Vector2(3,4)],boxes,[[Vector2(10,5),0]],[[Vector2(5,5),-10000]],[],"simple switch","if the number is negative, say 0 to green microphone, if not, say 1")
5. 
10. 	LevelClass.save_level(5,[Vector2(3,4)],boxes,[[Vector2(10,5),0]],spks,[],"Huge problems","Find the biggest number from red speakers, say it to the green")
	"""

func create_levels():
	
	#level 1
	LevelClass.save_level(1,[Vector2(5,5)],[],[],[],[Vector2(10,5)],"movement","move to the plate")
	
	# level 2
	var boxes := []
	for i in range(4,12):
		boxes.append(Vector2(i,4))
		boxes.append(Vector2(i,2))
		boxes.append(Vector2(i,6))
	boxes.append(Vector2(4,5))
	boxes.append(Vector2(11,5))
	boxes.append(Vector2(11,3))
	boxes.append(Vector2(4,3))
	LevelClass.save_level(2,[Vector2(5,3),Vector2(10,5)],boxes,[],[],[Vector2(10,3),Vector2(5,5)],"movement 2","move every bot to plate")
	
	# level 3
	LevelClass.save_level(3,[Vector2(1,1),Vector2(14,8)],[Vector2(2,0),Vector2(2,1),Vector2(2,2),Vector2(2,3),Vector2(2,4),Vector2(2,5),Vector2(2,6),Vector2(2,7),Vector2(2,8),Vector2(3,2),Vector2(3,6),Vector2(4,2),Vector2(4,8),Vector2(4,9),Vector2(4,4),Vector2(5,2),Vector2(5,4),Vector2(5,5),Vector2(5,6),Vector2(5,7),Vector2(5,8),Vector2(6,2),Vector2(6,4),Vector2(7,2),Vector2(7,3),Vector2(7,4),Vector2(9,0),Vector2(9,1),Vector2(9,2),Vector2(9,3),Vector2(9,4),Vector2(9,5),Vector2(10,0),Vector2(10,5),Vector2(11,0),Vector2(11,1),Vector2(11,2),Vector2(11,3),Vector2(11,5),Vector2(12,5),Vector2(13,1),Vector2(13,2),Vector2(13,3),Vector2(13,4),Vector2(13,5),Vector2(13,6),Vector2(13,7),Vector2(13,8),Vector2(13,9)],[],[],[Vector2(6,3),Vector2(10,1)],"movement 3","Move every bot to plate")
	
	# level 4
	boxes = []
	for i in range(3,14):
		if i == 8:
			boxes.append(Vector2(i,3))
			boxes.append(Vector2(i-1,3))
			boxes.append(Vector2(i+1,3))
			boxes.append(Vector2(i,7))
			boxes.append(Vector2(i-1,7))
			boxes.append(Vector2(i+1,7))
		else:
			boxes.append(Vector2(i,4))
			boxes.append(Vector2(i,6))
	boxes.append(Vector2(13,5))
	boxes.append(Vector2(3,5))
	
	LevelClass.save_level(4,[Vector2(4,5),Vector2(12,5)],boxes,[],[],[Vector2(4,5),Vector2(12,5)],"movement 3","change bot position between them")
	
	# level 5
	boxes = []
	for i in range(3,14):
		if i == 8:
			boxes.append(Vector2(i,0))
			boxes.append(Vector2(i-1,0))
			boxes.append(Vector2(i+1,0))
			boxes.append(Vector2(i-1,1))
			boxes.append(Vector2(i+1,1))
			boxes.append(Vector2(i-1,2))
			boxes.append(Vector2(i+1,2))
			boxes.append(Vector2(i-1,3))
			boxes.append(Vector2(i+1,3))
			boxes.append(Vector2(i-1,4))
			boxes.append(Vector2(i+1,4))
			
			boxes.append(Vector2(i,6))
		else:
			boxes.append(Vector2(i,4))
			boxes.append(Vector2(i,6))
	boxes.append(Vector2(13,5))
	boxes.append(Vector2(3,5))
	
	LevelClass.save_level(5,[Vector2(4,5),Vector2(12,5),Vector2(8,1)],boxes,[],[],[Vector2(4,5),Vector2(8,1),Vector2(12,5)],"movement 3","change bot position between them")
	
	# level 6
	
	
	
