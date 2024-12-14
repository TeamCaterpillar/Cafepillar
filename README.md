# The title of your game #

## Summary ##

**A paragraph-length pitch for your game.**

## Project Resources

[Web-playable version of your game.](https://aroshia.itch.io/cafepillar?secret=sxRkwzsfKWNpgYkhKWZI1OWhH0)  
[Trailor](https://youtu.be/aDJ_-KLX_5c)  
[Press Kit](https://github.com/TeamCaterpillar/Cafepillar/blob/1f56d638723ec2c0116c272568b60dbe65acfa32/PressKit.md)  
[Proposal: make your own copy of the linked doc.](https://docs.google.com/document/d/1qwWCpMwKJGOLQ-rRJt8G8zisCa2XHFhv6zSWars0eWM/edit?usp=sharing)  

## Gameplay Explanation ##

**In this section, explain how the game should be played. Treat this as a manual within a game. Explaining the button mappings and the most optimal gameplay strategy is encouraged.**


**Add it here if you did work that should be factored into your grade but does not fit easily into the proscribed roles! Please include links to resources and descriptions of game-related material that does not fit into roles here.**

# Main Roles #

Your goal is to relate the work of your role and sub-role in terms of the content of the course. Please look at the role sections below for specific instructions for each role.

Below is a template for you to highlight items of your work. These provide the evidence needed for your work to be evaluated. Try to have at least four such descriptions. They will be assessed on the quality of the underlying system and how they are linked to course content. 

*Short Description* - Long description of your work item that includes how it is relevant to topics discussed in class. [link to evidence in your repository](https://github.com/dr-jam/ECS189L/edit/project-description/ProjectDocumentTemplate.md)

Here is an example:  
*Procedural Terrain* - The game's background consists of procedurally generated terrain produced with Perlin noise. The game can modify this terrain at run-time via a call to its script methods. The intent is to allow the player to modify the terrain. This system is based on the component design pattern and the procedural content generation portions of the course. [The PCG terrain generation script](https://github.com/dr-jam/CameraControlExercise/blob/513b927e87fc686fe627bf7d4ff6ff841cf34e9f/Obscura/Assets/Scripts/TerrainGenerator.cs#L6).

You should replay any **bold text** with your relevant information. Liberally use the template when necessary and appropriate.

## Producer

**Describe the steps you took in your role as producer. Typical items include group scheduling mechanisms, links to meeting notes, descriptions of team logistics problems with their resolution, project organization tools (e.g., timelines, dependency/task tracking, Gantt charts, etc.), and repository management methodology.**

## User Interface and Input

**Describe your user interface and how it relates to gameplay. This can be done via the template.**
**Describe the default input configuration.**

**Add an entry for each platform or input style your project supports.**

## Movement/Physics

**Describe the basics of movement and physics in your game. Is it the standard physics model? What did you change or modify? Did you make your movement scripts that do not use the physics system?**

## Animation and Visuals

**List your assets, including their sources and licenses.**

**Describe how your work intersects with game feel, graphic design, and world-building. Include your visual style guide if one exists.**

## Kitchen Mechanics/Logic

### Minh Nguyen

Taking the main responsibility of implementing the kitchen logic, I was tasked with creating and connecting different kitchen appliances and components through scripts in order to ensure a smooth gameplay process for when the player heads to the kitchen to create food items to fulfill customer orders at the front of house. 

**Cooking Appliances**

Working to extend the script gcard_hand_layout.gd provided by Emma that manages the card hand and card dragging mechanics, I implemented drop handlers that are specific to each of the drop locations in the kitchen scene. For appliances, when the dragged card is released within the boundaries of the drop off slot, the card is removed from the hand and the appliance will hold the card as a child, extracting its resource into an array for condition checks. Subsequence cards that are dropped are placed with a randomly generated offset to create a card stacking effect. 

![Screenshot 2024-12-13 at 8 29 50 PM](https://github.com/user-attachments/assets/2a9d109c-2332-4c76-b714-0aaafe2877ad)

**Recipe Comparator**

Within slot.gd, which handles the handling of the dropped cards, I implemented a formatter that takes in each of the entries in the recipe dictionary in recipes.gd, bound to the RecipesBook object and transforms them into appropriate strings and sorted arrays for comparison with the resources that the appliance is holding.

![Screenshot 2024-12-13 at 8 45 31 PM](https://github.com/user-attachments/assets/d12e4688-4ccc-422b-bed4-bc81c303d281)

For example, a typical entry in the recipes dictionary can look like this:

{ \
    "use": "Stove",\
    "title": "Sunny Side Up",\
    "ingredients": ["Eggs x2"]\
}

Going through the formatter, the title would transform to snake case, in this case, sunny_side_up, consistent with our resources file naming conventions in order to generate the correct card texture and resource. The formatter would also handle the “x2” at the end the ingredient element, creating a duplicate element or more corresponding to the amount specified. It also removes the ‘s’ at the end of the ingredient’s name for consistent plurality of our resource naming methodologies. In this example, [“Eggs x2”] is transformed into [egg, egg], matching the slot’s resource array, which when compared will return the recipe that matches the exact name and quantity of ingredients present. 

**Kitchen Logic**

I also implemented various game restrictions to ensure that gameplay actions stay within the intended rules and boundaries of Cafepillar:
-Each appliance can only be used to produce dishes that are unique to it, for example, Sunny Side Ups cannot be made using the Counter or Blender. This is handled within the recipe check handling in slot.gd
-Ingredient cards cannot be placed into the trash bin to be discarded, or onto the serving tray. Vice versa, a dish cannot be added into the Ingredients hand, or back onto the appliances. This is managed in gcard_hand_layout.gd
-When cooking starts, cards cannot be moved in or out of the appliances, managed in cooking_timer.gd

**Other Components**
* Added a trash bin for player to discard dish if they are not satisfied with the grade
* Reworked the recipe book made by Michelle which will be discussed more in the game feel section.
* Reworked the serving tray which will be discussed in the game feel section.
* Reworked the hand and ingredients system which will be discussed in the game feel section.

## DayNight Cycle, RecipeBook, Audio

### Michelle Lu

I mainly took care of implementing the Day/Night Cycle for our game, making sure that there is an in-game timer to keep track and make a sense of progression in the game. In addition, I built the recipebook scene and added buttons to navigate through it.

**Day/Night Cycle**

The implementation of the Day/Night cycle involved placing a timer at the very top that scaled to however long we wanted the day to be, and making sure it started at 6am and would display and end of day screen once it hit 6pm. In addition, I implemented the next day and skip day buttons to navigate through all the cycles.

**Recipe Book**

The Recipe Book makes sure the player has an easy-to-navigate system to look up any recipe that they might need in order to make their food. In a time-pressured environment like the kitchen, it had to be easy to read and simple enough to manage that it doesn't inadventedly add an additional difficulty on top of the already existing gameplay. Minh later improved upon my original design to make everything more streamlined.

# Sub-Roles

## Audio
### Michelle Lu

**Audio Sources**

The button and shuffling sound effects were sourced from [freesound.org](https://freesound.org/search/?q=shuffle+card&f=tag%3A%22shuffling%22), and the background music was sourced from a [youtube video](https://www.youtube.com/watch?v=zhhA3drWwcw&pp=ygUQY2F0ZXJwaWxsYXIgc29uZw%3D%3D) that allowed viewers to use their music for free. Signals are sent every time a button is pressed, and for each scene, there is a script that is listening for the signals and emits the button_pressed sound effect when it reads the signal. The background music is autoloaded when the game boots up and loops, ensuring no breakups in the music when switching between the front of house and the kitchen. The sound style is meant to be relaxing and reminiscent of a coffee shop, so we chose a comfy bossa-nova track to play in our game.

## Gameplay Testing

**Add a link to the full results of your gameplay tests.**

**Summarize the key findings from your gameplay tests.**

## Narrative Design

**Document how the narrative is present in the game via assets, gameplay systems, and gameplay.** 

## Press Kit and Trailer

**Include links to your presskit materials and trailer.**

**Describe how you showcased your work. How did you choose what to show in the trailer? Why did you choose your screenshots?**

## Game Feel - Code Refactoring

### Minh Nguyen

Working primarily on connecting the components within the Kitchen scene, it makes sense for me to also ensure the gameplay in the kitchen flows well and intuitively. 

**Card Hand**

Initially, each card was a single instance of an ingredient, and the game would provide the player with multiple copies of each ingredient by calling the card factory multiple times. We found this to not scale well as the player unlocks more recipes and ingredients. This clutters the hand excessively with copies of the same card, and also allows for instances where the player could scroll through multiple hands before finding a copy of a card that they need, which can be frustrating.

I reimplemented the card system to be a single instance, and when the player drags a card into a slot, the hand requests the factory to reproduce that same card and re-add it into the hand. This is handled in gcard_hand_layout.gd. This allows the player to find the ingredients they need more easily, especially if they remember which page each ingredient can be found at. This also streamlined the unlocking process for additional ingredients as only a single request for the factory is needed in game_manager.gd. This implementation also optimizes the card generation, as the factory is only called when an interaction requests it, whereas the previous implementation calls a surplus amount of requests for each ingredient to ensure they do not run out.

![Screenshot 2024-12-13 at 11 20 59 PM](https://github.com/user-attachments/assets/044bcbee-8d36-4995-8795-2eb549c1d1bb)

**Recipe Book**

Originally, the recipe book consisted of individual pages describing the recipes, and the only navigation method was either back or continue, essentially flipping through the pages one by one. This became unreasonable as our recipe list grew, so instead, I refactored the recipe’s main page to be a generated list of buttons for each of the recipe titles. When the button is pressed, its corresponding recipe will show. 

![Screenshot 2024-12-13 at 10 30 36 PM](https://github.com/user-attachments/assets/f8a10797-069e-47ec-b5da-479f2b256cda)


![Screenshot 2024-12-13 at 10 30 46 PM](https://github.com/user-attachments/assets/83a628bd-f3dd-4fbf-a471-ce1c519d34cd)

Furthermore, the recipe book took up a portion of the screen real estate, which clutters the already hectic kitchen scene with a lot of components and buttons. A solution we have reached is that the recipe book should be able to be minimized to reduce text and clutter, but also easily accessible and open on command.

![Screenshot 2024-12-13 at 10 24 42 PM](https://github.com/user-attachments/assets/985eb23b-4cb0-400b-acf5-0705b674bdcb)

![Screenshot 2024-12-13 at 10 24 55 PM](https://github.com/user-attachments/assets/0afde47f-30d2-459f-933a-d97bdbfcc186)

**Serving Tray**

The serving tray used to have a “Yes” button that transported the dish into the player’s inventory. We found it to be a redundant command when the player already can choose to discard or keep the dish by either dragging the card into the trash or the tray, so we decided to ditch the confirm button and initiate the transport directly on the drop. 

**Kitchen Layout**

As we added more components, the kitchen scene became cluttered and the flow of each action became more difficult or awkward. I consulted an arrangement of different card games’ UI elements and layout (Slay the Spire, Monster Train, Balatro, etc.) to find patterns in what was considered ideal or intuitive. What I found was the hand and the primary interactions should be centered while the other informative elements surrounding the main playing area. I still find the discard location (trashcan) to be slightly awkward, but I felt that the game area is optimized decently with the available space that I had.

**Code Refactoring**

When building the project up from scratch, there were instances where too many components were in the same scene at once, as well as long and cluttered code files that could be refactored to adhere to good coding practices. I took initiatives to refactor whatever I can to maintain a clean workspace for better navigation and debugging. 

* Refactored components of the recipe book into a single RecipesBook scene.
* Separate the recipe list into an independent global script recipes.gd from the recipes book for safer referencing from other scenes.
* Attempted to separate the drag and drop mechanics from the hand layout into different code files, but since the code is provided by a plugin with a lot of dependencies, I invested a lot of time but had little success. 
* Refactored the Stove into a separate scene for better reusability, which I used to create the Counter and the Blender appliances. 
* Combined tray.gd, which handles the dropping of the dish card onto the serving tray, to gcard_hand_layout.gd which handles other dropping functionalities to centralize the code for the dropping mechanics.

