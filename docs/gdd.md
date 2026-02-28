Here’s a **detailed Game Design Document (GDD)** for your 2D game based on what you’ve already built. I’ll expand your mechanics into a full game loop, systems, upgrades, story, and progression. 🚀👾

---

# Game Design Document

## Working Title: **Orbital Rescue**

### Genre

2D Physics-Based Action / Exploration / Rescue

### Core Fantasy

You pilot a fragile but upgradeable rescue rocket through dangerous planetary systems, saving stranded astronauts while being hunted by alien forces and managing limited resources.

The game mixes:

* physics flight
* survival/resource management
* combat
* exploration
* rescue strategy

---

# Story & World

## Premise

In the year **2347**, humanity has expanded into distant planetary systems.

A massive alien civilization suddenly appears and begins attacking human colonies.

Your role:
**Pilot of the Interstellar Emergency Rescue Unit (IERU).**

Your mission:

* Enter hostile systems
* Rescue stranded astronauts
* Recover valuable research
* Escape alive

Every system you enter is partially overrun by alien lifeforms.

The longer you stay, the more enemies arrive.

---

# Core Gameplay Loop

1. Enter a planetary system
2. Scan planets/moons
3. Land on planets carefully using physics controls
4. Rescue astronauts
5. Mine resources
6. Fight or evade aliens
7. Manage fuel and health
8. Upgrade your rocket
9. Escape the system

Repeat with increasing difficulty.

---

# Player Controls (Current + Expanded)

**Left Arrow** – rotate left
**Right Arrow** – rotate right
**Space** – main thruster

Possible additions:

**Shift** – boost thrusters (high fuel usage)
**Z** – fire weapon
**X** – deploy mini-bot
**E** – interact / rescue / mine

Difficulty option:

* Assist Mode: automatic counter-rotation
* Simulation Mode: full physics drift

---

# Rocket Systems

### 1. Fuel

Used for:

* thrust
* boost
* escaping gravity wells

Fuel forces the player to plan movement carefully.

---

### 2. Health

Represents hull integrity.

Damage sources:

* alien attacks
* hard landings
* collisions
* hazardous environments

---

# How to Replenish Fuel

Multiple ways keep gameplay varied.

### 1. Fuel Crystals

Found on planets.

Mechanic:

* land
* mine crystals
* convert into fuel

Risk: aliens guard rich deposits.

---

### 2. Fuel Stations (Rare)

Abandoned human outposts.

Provides:

* full fuel refill
* small repairs

But may activate alien waves.

---

### 3. Astronaut Engineers

Some rescued astronauts can temporarily improve fuel efficiency.

Example:
+25% fuel efficiency for the level.

---

### 4. Atmospheric Skimming

Certain gas planets allow fuel harvesting.

Mechanic:

* fly low in atmosphere
* avoid storms
* slowly regenerate fuel.

High risk / high reward.

---

# How to Restore Health

### 1. Repair Kits

Found in wreckage.

Restores a portion of health.

---

### 2. Landing Platforms

Stable landing pads auto-repair slowly.

Encourages safe landing gameplay.

---

### 3. Rescue Medics

Some astronauts heal your ship on pickup.

---

### 4. Nano-Repair Upgrade

Passive hull regeneration when not taking damage.

Late-game upgrade.

---

# Astronaut Rescue System

Astronauts are scattered across planets.

Types:

### Scientist

Unlocks research and upgrades.

### Engineer

Improves ship performance temporarily.

### Soldier

Adds combat support.

### Civilian

Increases mission score.

---

Rescue mechanics:

1. Land safely
2. Open hatch
3. Astronaut boards
4. Protect them until extraction

If you die → mission failed.

---

# Alien Enemies

Aliens actively hunt the player.

## Types

### Scout Drones

Fast
Weak
Swarm behavior

### Hunters

Track you across the map.

### Artillery Organisms

Stationary planet defenses.

### Leechers

Drain your fuel.

### Titans (Mini Bosses)

Guard astronauts or resources.

---

# Combat System

Your rocket **can shoot**, but combat should never overpower navigation skill.

---

# Weapon Types

### 1. Pulse Blaster

Default weapon.

Fast
Low damage
Infinite ammo with cooldown.

---

### 2. Plasma Rockets

Slow
Heavy damage
Consumes fuel.

---

### 3. Gravity Bomb

Pulls enemies into a vortex.

Great near planets.

---

### 4. Ion Beam

Continuous beam
High energy drain.

---

# Mini Bot Companion

A floating support drone.

Unlock early in the game.

Functions:

Auto-targets enemies
Collects nearby resources
Warns of threats

Upgradeable:

Level 1 – simple shooter
Level 2 – shield generator
Level 3 – dual cannons
Level 4 – repair drone
Level 5 – missile drone

Player can recall or deploy it.

---

# Mining System

Adds exploration depth.

Resources found on planets:

Iron
Plasma Crystals
Alien Biomass
Dark Matter Fragments

Used for upgrades.

Mining methods:

Laser mining
Landing drill
Mini-bot auto collector

Danger:
Mining noise attracts aliens.

---

# Planet Types

Each planet changes gameplay.

### Rocky

Safe landing zones
Basic resources

### Gas Giant

No landing
Fuel harvesting

### Ice Planet

Low gravity
Slippery physics

### Lava Planet

High damage environment

### Alien Hive World

Constant enemies
High rewards

---

# Level Structure

Each level = **Star System**

Contains:

* several planets
* asteroid fields
* alien nests
* stranded astronauts

---

# Objectives

Primary:
Rescue required astronauts.

Secondary:

* mine resources
* destroy alien hives
* retrieve black boxes
* activate ancient alien tech
* escort damaged ships

---

# Dynamic Events

Random events increase replayability.

Examples:

Solar flare
Meteor shower
Alien swarm migration
Distress signals
Derelict mega-ships

---

# Difficulty Progression

Difficulty increases through:

More aggressive aliens
Complex gravity fields
Multiple objectives
Hazardous environments
Limited fuel availability

Later systems become **puzzle-like survival challenges**.

---

# Boss Encounters

End of some systems.

Examples:

Alien Mothership
Planetary Brain Organism
Gravity Leviathan

Boss fights require:
movement mastery
resource management

---

# Upgrades

Resources allow permanent improvements.

---

# Rocket Upgrades

### Engine

Fuel efficiency
More thrust
Boost unlock

### Hull

More health
Damage resistance

### Weapons

Unlock new weapons
Higher damage

### Fuel Tanks

Increase capacity

### Landing Stabilizers

Reduce crash damage.

---

# Special Modules

Shield Generator
Auto Stabilizer
Cloaking Device
Wormhole Escape

---

# Player Progression

Player builds their own **rescue ship style**:

Combat focused
Exploration focused
Speed runner
Resource collector

---

# UI / HUD

Important for physics gameplay.

---

# Main HUD

Top Left
Health Bar

Top Right
Fuel Gauge

Center
Velocity Vector Indicator

Bottom Left
Mini-Map / Radar

Bottom Right
Weapon + Mini-bot status

---

# Additional Indicators

Landing stability meter
Gravity direction arrow
Alien proximity alert
Astronaut tracker

---

# Radar System

Shows:
Astronauts
Aliens
Resources
Fuel stations

Upgradable for better range.

---

# Landing UI

When near surface:

Altitude meter
Safe landing speed indicator
Surface slope warning

This helps avoid crashes.

---

# Mission End Screen

Displays:

Astronauts rescued
Resources collected
Aliens destroyed
Time survived
Accuracy
Landing quality

Rewards upgrade currency.

---

# Audio Design

Thruster sound changes with power.

Alien sounds directional.

Music intensity increases when chased.

Silence in deep space moments.

---

# Visual Style

2D but atmospheric.

Inspirations:

* FTL
* Noita
* Lunar Lander
* Dome Keeper

Features:

Glowing alien biomes
Dynamic thruster particles
Planet atmospheres
Debris fields

---

# Replayability

Procedural elements:

Planet layouts
Astronaut locations
Alien spawns
Resource distribution
Events

Every system feels new.

---

# Endgame

Final systems reveal the alien motive.

Possible twist:

Aliens are **protecting something**.

Final mission:
Enter the alien homeworld and rescue the last survivors.

---

# Possible Title Ideas

Orbital Rescue
Gravity Salvager
Last Rocket
Astral Lifeline
Rescue Vector

---

# If you want

I can also help you design:

* the **game architecture for your engine**
* **entity systems**
* **physics model**
* **enemy AI**
* **procedural planet generation**
* **upgrade trees**
* **fun mechanics that make the game addictive**.
