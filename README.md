#Code documentation

##Main Node:
###Game -> 
*Script (On transition dequeue current screen, instantiate and add to tree next screen)

##AutoLoads:
	###game_data 
        *(Persistent script can be called from anywhere, stores persistent game data such as inventory, where you are on the map, stats, etc) 
		

##Screen List: (each with their own script that inherits from Screen Note: Must at some point emit screen change in each screen) 
	###Main Menu
	###Inventory
    ###Battle?
	###Map
	###Event* 
    *(maybe inherit from another Event class?) 
	
