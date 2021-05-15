# 4x_planet_generator_godot
 
This is one of my first programming projects (made in the summer of 2020, 2 months after I've learnt to program). It randomly generates a planet of hexagons and pentagons using a system of tectonic planets. Everything is coded by myself (except the camera system) in the Godot coding language (a Python-like language).

Features:
- simple tectonic plates simulation that results in mountain ranges and oceanic rifts
- can choose anywhere between 7 and 21 tectonic plates
- multiple sized planets
- 7 levels of terrain ranging from Deep Oceanic to High Mountains
- island chains (like the Hawaii chain)
- Goldberg Polyhedron generation
- control water amount ( by default it is set to Earth like levels, so around 66%)
- ability to add different types of planetary generation, similar to Civilization map types (only Continents implemented)

Instructions:
- To change some variables simply go to the Universal Constants folder and the universal_constants.gd file. Note that when changing the size of the planet you must also modify the number of polys according to the comments of the size you chose. Other variables such as water amount need to be modified in the MapTypes folder.

Examples:

![example0](https://github.com/VictorGordan/4x_planet_generator_godot/blob/main/gif/example0.gif)

![example1](https://github.com/VictorGordan/4x_planet_generator_godot/blob/main/gif/example1.gif)

![example2](https://github.com/VictorGordan/4x_planet_generator_godot/blob/main/gif/example2.gif)

![example3](https://github.com/VictorGordan/4x_planet_generator_godot/blob/main/gif/example3.gif)
