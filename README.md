# Debug the Earth

An educational 2D platformer that teaches basic Python through environmental challenges. Built for the GameJam hackathon with Godot Engine 4.6.

## About

Debug the Earth combines programming education with environmental awareness. Players complete coding puzzles to solve environmental problems across three levels:

- **Level 1**: Recharge drones and jump across platforms
- **Level 2**: Sort trash into correct bins using if-elif-else logic
- **Level 3**: Restore coral reefs underwater 

(level 3 is incomplete...)

Puzzle answers are written below!

## Controls

| Key | Action |
|-----|--------|
| W | Jump |
| A/D | Move Left/Right |
| E | Interact |

## Puzzle Example

Players fill in Python code to sort waste correctly:

```python
if colour == "yellow":
    print("This belongs in the recycling bin!")
elif colour == "black":
    print("This belongs in the general waste bin!")
else:
    print("This belongs in the organic waste bin!")
```

## Installation

**Requirements**: Godot Engine 4.6+

```bash
git clone https://github.com/darelroa/GameJam1.git
cd GameJam1
```

Open `project.godot` in Godot Engine and press F5 to run.

## Credits

**Team**: Darel, Doris, Chanulya, Magdalene, Eric, Mia, and Bhoomini

**Font**: Pixel Operator 8

**Art**: All pixel artwork created with procreate by Eric, Mia and Bhoomini :)

## Puzzle Answers

Drones:
1. 63
2. TotalGas/(CurrentDrones*DroneCapacity)

Trash
1. if, print("This belongs in the recycling bin!")
2. elif, print("This belongs in the general waste bin!")
3. else, print("This belongs in the organic waste bin!")


## Tech Stack
- Godot Engine 4.6
- GDScript
- Original pixel art assets

---

**Repository**: [github.com/darelroa/GameJam1](https://github.com/darelroa/GameJam1)
