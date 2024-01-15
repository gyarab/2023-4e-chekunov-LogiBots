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
	
	LevelClass.save_level(5,[Vector2(4,5),Vector2(12,5),Vector2(8,1)],boxes,[],[],[Vector2(4,5),Vector2(8,1),Vector2(12,5)],"movement 3","change bot position between them.")
	
	# level 6
	boxes = []
	for i in range(0,16):
		for j in range(0,10):
			if i == 0 or i == 15 or j == 0 or j == 9:
				boxes.append(Vector2(i,j))

	LevelClass.save_level(6,[Vector2(8,5)],boxes,[[Vector2(12,5),0]],[[Vector2(2,2),-10000],[Vector2(2,7),-10000]],[],"counting","sum two numbers from red speaker and say it to green mic.")
	
	# level 7
	
	LevelClass.save_level(7,[Vector2(8,5)],boxes,[[Vector2(12,5),0]],[[Vector2(2,5),-10000]],[],"If Else","Say to green mic 1 if the number is positive\nSay -1 if not.")
	
	# level 8
	
	LevelClass.save_level(8,[Vector2(8,5)],boxes,[[Vector2(12,5),0]],[[Vector2(2,2),-10000],[Vector2(2,7),-10000]],[],"Two numbers","Check if two numbers are the same if is, say 1. If not say -1.")
	
	#level 9
	for i in range(1,5):
		boxes.append(Vector2(i,1))
		boxes.append(Vector2(i,3))
		boxes.append(Vector2(i,5))
		boxes.append(Vector2(i,7))
		boxes.append(Vector2(i,1))
	
	boxes.append(Vector2(6,1))
	boxes.append(Vector2(6,2))
	boxes.append(Vector2(6,3))
	boxes.append(Vector2(6,4))
	boxes.append(Vector2(6,8))
	boxes.append(Vector2(6,7))
	boxes.append(Vector2(6,6))

	
	LevelClass.save_level(9,[Vector2(2,2),Vector2(2,4),Vector2(2,6),Vector2(2,8)],boxes,[[Vector2(12,5),0]],[[Vector2(1,2),-10000],[Vector2(1,4),-10000],[Vector2(1,6),-10000],[Vector2(1,8),-10000]],[],"Great sum","Sum all numbers from speakers. Say result to green mic.")
	
	#level 10
	boxes = []
	for i in range(0,16):
		for j in range(0,10):
			if i == 0 or i == 15 or j == 0 or j == 9:
				boxes.append(Vector2(i,j))
	LevelClass.save_level(10,[Vector2(8,5)],boxes,[[Vector2(12,5),0]],[[Vector2(2,5),-10000],[Vector2(2,2),-10000],[Vector2(2,7),-10000]],[],"Three numbers!","If the numbers are the same, say 1. If not, say -1.")

	#level 11

	LevelClass.save_level(11,[Vector2(8,5)],boxes,[[Vector2(12,5),0]],[[Vector2(2,5),-10000],[Vector2(2,2),-10000],[Vector2(2,7),-10000]],[],"Bigest problem","Find the biggest number and say it to green mic.")
	
	#level 12
	boxes = []
	for i in range(0,16):
		for j in range(0,10):
			if i == 0 or i == 15 or j == 0 or j == 9:
				boxes.append(Vector2(i,j))
	for i in range(6,10):
		for j in range(1,9):
			if j != 5:
				boxes.append(Vector2(i,j))
				
	LevelClass.save_level(12,[Vector2(5,5),Vector2(10,5),Vector2(8,5),Vector2(9,5),Vector2(7,5),Vector2(6,5)],boxes,[[Vector2(13,1),0],[Vector2(13,5),0],[Vector2(13,3),0],[Vector2(13,7),0]],[[Vector2(2,1),-10000],[Vector2(2,5),-10000],[Vector2(2,3),-10000],[Vector2(2,7),-10000]],[],"Copy Mashine","copy numbers from left to right")
	
	# level 13
	boxes = []
	for i in range(0,16):
		for j in range(0,10):
			if i == 0 or i == 15 or j == 0 or j == 9:
				boxes.append(Vector2(i,j))
			if j < 4 and not [2,4,6,9,11,13].has(i):
				boxes.append(Vector2(i,j))
				
	LevelClass.save_level(13,[Vector2(2,2),Vector2(4,2),Vector2(6,2),Vector2(9,2),Vector2(11,2),Vector2(13,2)],boxes,[[Vector2(8,8),0]],[[Vector2(2,1),-10000],[Vector2(4,1),-10000],[Vector2(6,1),-10000],[Vector2(9,1),-10000],[Vector2(11,1),-10000],[Vector2(13,1),-10000]],[],"Battle Royale","Every bot has a number above him. write bot INDEX with biggest number")
	
	# level 14
	boxes = []
	for i in range(0,16):
		for j in range(0,10):
			if i == 0 or i == 15 or j == 0 or j == 9:
				boxes.append(Vector2(i,j))
	
	
	LevelClass.save_level(14,[Vector2(5,6),Vector2(10,4)],boxes,[[Vector2(1,5),0],[Vector2(5,5),-10000],[Vector2(6,5),-10000],[Vector2(7,5),-10000],[Vector2(8,5),-10000],[Vector2(9,5),-10000],[Vector2(10,5),-10000],[Vector2(14,5),0]],[[Vector2(5,7),0],[Vector2(6,7),1],[Vector2(7,7),2],[Vector2(8,7),3],[Vector2(9,7),4],[Vector2(10,7),5],[Vector2(5,3),0],[Vector2(6,3),1],[Vector2(7,3),2],[Vector2(8,3),3],[Vector2(9,3),4],[Vector2(10,3),5]],[],"Best and worse","There is a GREEN ARRAY of numbers. Say the biggest number to right and the smallest to left. (red indexes might help)")
	
	# level 15
	LevelClass.save_level(15,[Vector2(5,6),Vector2(10,4)],boxes,[[Vector2(1,5),0],[Vector2(5,5),-10000],[Vector2(6,5),-10000],[Vector2(7,5),-10000],[Vector2(8,5),-10000],[Vector2(9,5),-10000],[Vector2(10,5),-10000],[Vector2(14,5),0]],[[Vector2(5,7),0],[Vector2(6,7),1],[Vector2(7,7),2],[Vector2(8,7),3],[Vector2(9,7),4],[Vector2(10,7),5],[Vector2(5,3),0],[Vector2(6,3),1],[Vector2(7,3),2],[Vector2(8,3),3],[Vector2(9,3),4],[Vector2(10,3),5]],[],"Profit graph","There is a GREEN ARRAY of numbers. Say index of the smallest number to left and index of biggest number to right. (indexes are red)")
	
	# level 16
	LevelClass.save_level(16,[Vector2(5,6),Vector2(10,4)],boxes,[[Vector2(5,5),-10000],[Vector2(6,5),-10000],[Vector2(7,5),-10000],[Vector2(8,5),-10000],[Vector2(9,5),-10000],[Vector2(10,5),-10000]],[[Vector2(5,7),0],[Vector2(6,7),1],[Vector2(7,7),2],[Vector2(8,7),3],[Vector2(9,7),4],[Vector2(10,7),5],[Vector2(5,3),0],[Vector2(6,3),1],[Vector2(7,3),2],[Vector2(8,3),3],[Vector2(9,3),4],[Vector2(10,3),5]],[],"sorter","There is an ARRAY of numbers. Sort it :) ")
	
	# level 17
	LevelClass.save_level(17,[Vector2(8,5)],boxes,[[Vector2(12,5),0]],[[Vector2(2,2),-10001],[Vector2(2,7),-10001]],[],"multiplying","multiply two numbers from red speaker and say result to green mic.")
	
	# level 19
	LevelClass.save_level(18,[Vector2(8,5),Vector2(14,1),Vector2(14,2),Vector2(14,3),Vector2(14,4),Vector2(14,5)],boxes,[[Vector2(1,1),-10000],[Vector2(1,2),-10000],[Vector2(1,3),-10000],[Vector2(1,4),-10000],[Vector2(1,5),-10000],[Vector2(1,6),-10000],[Vector2(1,7),-10000],[Vector2(1,8),-10000]],[],[],"sandbox","Have fun!")
	
	# level 20
	#LevelClass.save_level(19,[Vector2(8,5),Vector2(14,1),Vector2(14,2),Vector2(14,3),Vector2(14,4),Vector2(14,5)],boxes,[[Vector2(1,1),-10000],[Vector2(1,2),-10000],[Vector2(1,3),-10000],[Vector2(1,4),-10000],[Vector2(1,5),-10000],[Vector2(1,6),-10000],[Vector2(1,7),-10000],[Vector2(1,8),-10000]],[],[],"sandbox","Have fun!")
