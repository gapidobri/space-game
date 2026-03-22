# Game Design Document

## Working Title

**Orbital Rescue**

## Genre

2D physics-based action roguelike with exploration, combat, mining, and rescue objectives.

## Core Fantasy

The player pilots a fragile but upgradeable rocket through hostile space sectors, improvising a run one stage at a time. Each stage offers objectives, resources, shops, escalating alien pressure, and a risky choice between leaving early or staying longer for power.

## High-Level Pillars

- Physics-driven ship control is always central.
- Each run is a sequence of generated stages, not an infinite open universe.
- The player progresses by completing objectives, gathering resources, and upgrading the rocket.
- Difficulty rises over time and across stages.
- The player can continue deeper into the run or intentionally end it by pursuing the final boss.

## Run Structure

The game is an "endless" roguelike run in the sense that the player can keep advancing through stages as long as they survive. The run does not end automatically after a fixed number of stages.

Each run follows this loop:

1. Spawn into a randomly generated stage.
2. Discover the local map, planets, hazards, and points of interest.
3. Complete required objectives.
4. Optionally complete side objectives for more money, resources, and upgrades.
5. Gather the materials or key parts needed to repair the stage teleporter.
6. Visit shops to upgrade the rocket.
7. Activate the teleporter and survive the exit event.
8. Jump to the next stage with higher difficulty.
9. Eventually choose to summon and defeat the final boss to end the run.

Failure ends the run when the rocket is destroyed or the player becomes unable to continue because of critical resource depletion.

## Stage Structure

Each stage is a finite generated star sector. It should feel large enough to explore but small enough that the player does not get lost or drift away from the core loop.

A stage contains:

- several planets or moons
- asteroid fields or debris zones
- alien nests or patrol routes
- objective sites
- one or more shops on selected planets
- a damaged teleporter or jump gate
- optional special events

The player is not expected to clear the whole stage. Each stage should contain more content than is required for progression.

## Why Stages Instead of an Infinite World

The game should use discrete generated stages rather than a fully infinite world.

Reasons:

- objective placement is easier to control
- pacing is easier to understand and balance
- shops, mini-bosses, and teleporter progression can be authored more intentionally
- players have freedom without becoming directionless
- performance, save/load, and generation are easier to manage
- the final boss becomes a deliberate goal rather than a random discovery

The target feeling is "large but guided", not "boundless but unfocused".

## Objectives

Each stage generates a set of required objectives plus a smaller set of optional objectives.

### Required Objectives

Required objectives are the main way the player earns teleporter repair progress and stage rewards.

Examples:

- rescue stranded astronauts
- destroy alien nests
- mine a target amount of rare resources
- eliminate elite alien packs
- recover black boxes from wreckage

The player should usually need to complete 2-3 required objectives per stage.

### Optional Objectives

Optional objectives provide extra money, rare resources, special upgrades, or safety advantages for later stages.

Examples:

- investigate a distress signal
- escort a damaged ship
- clear an elite ambush
- raid a high-risk alien cache
- salvage a drifting research station

Optional content should reward greed and skill, but should not be mandatory for stage completion.

## Teleporter Progression

Each stage ends with repairing and activating a teleporter or jump gate.

The teleporter is the stage exit and the main pacing anchor.

### Repair Rules

- the teleporter begins damaged or partially offline
- it requires a small number of repair parts, energy cells, or resources
- required objectives always provide enough progress to make the teleporter usable
- optional objectives can provide bonus repair parts, money, or reduced activation risk

The repair system should feel integrated with the stage rather than like a separate grind. Players should not need to mine random rocks for an extended period just to leave.

### Activation Event

Once repaired, the teleporter can be activated. Activation should trigger a short high-pressure sequence such as:

- alien defense wave
- mini-boss ambush
- environmental instability
- power-up countdown that attracts enemies

This gives each stage a strong climax before transition.

## Difficulty Progression

Difficulty rises through both time and stage depth.

### Time Pressure

The longer the player stays in a stage, the more dangerous it becomes.

Examples:

- more aliens spawn
- elite variants appear
- patrol density increases
- resource sites become contested
- random attack events happen more often

### Stage Depth

Each new stage raises the baseline challenge.

Examples:

- stronger enemy stats
- more advanced alien types
- harsher environmental hazards
- more complex objective combinations
- tougher teleporter activation events

This creates the core tension of the run:

- leave early and stay underpowered
- stay longer and risk death for more upgrades

## Final Boss and Ending the Run

The run can continue through stage after stage, but the player needs a clear intentional way to end it.

After reaching a late-run threshold, the player unlocks the ability to pursue a final boss.

Examples:

- a special beacon appears after a certain stage
- enough alien cores have been collected
- a final gateway can be powered after several teleporter activations

The player chooses when to commit to the final boss path.

Defeating the final boss counts as a successful run completion.

## Core Gameplay Loop Inside a Stage

1. Enter stage.
2. Scout the area and identify objectives, shops, and hazards.
3. Choose a route based on fuel, health, and current build.
4. Complete required objectives while fighting or avoiding aliens.
5. Gather resources and upgrades.
6. Decide whether to push optional content.
7. Repair and activate the teleporter.
8. Survive the activation event.
9. Travel to the next stage.

## Rocket Systems

### Fuel

Fuel is used for:

- thrust
- boost
- combat tools that consume energy or fuel
- recovering from bad flight paths

Fuel is both a survival resource and a routing constraint.

### Health

Health represents hull integrity.

Damage sources include:

- alien attacks
- collisions
- hard landings
- hazardous environments

### Money

Money is the main shop currency.

It is earned from:

- objective rewards
- salvaging
- elite kills
- optional events

### Materials

Materials are used for teleporter repair, crafting-like upgrades, or special purchases.

Examples:

- ore
- fuel crystals
- alien cores
- circuit fragments

## Player Actions

Core controls:

- rotate left
- rotate right
- thrust
- interact
- fire weapon
- boost

Potential advanced actions:

- deploy support drone
- use active equipment
- harvest resources
- activate temporary defense tools

## Exploration and Navigation

Exploration should be meaningful but bounded.

Design goals:

- the player should usually have 2-3 meaningful route choices
- radar, scans, and visual landmarks should help players orient themselves
- travel time should create tension, not dead space
- the player should never feel fully lost

Points of interest should be readable on the map:

- objective locations
- shops
- teleporter
- rare events
- dangerous zones

## Shops and Upgrades

Some planets contain shops, stations, or traders that offer rocket upgrades during the run.

Shops are not guaranteed to be equally accessible every stage. Route planning matters.

### Shop Goals

- give players a way to convert money into power
- create route decisions
- encourage short detours
- support different builds across runs

### Upgrade Categories

- shields and hull durability
- fuel efficiency and tank size
- engine power and mobility
- primary weapon upgrades
- secondary weapon unlocks
- utility modules
- mining efficiency
- radar and detection systems

### Example Utility Modules

- shield generator
- auto stabilizer
- emergency fuel recycler
- repair nanites
- cargo magnet
- teleporter charge booster

## Objective Types

The objective pool should support varied run pacing.

### Rescue

Land near survivors, secure the zone, and extract astronauts.

### Mining

Harvest target resources from risky locations.

### Elimination

Destroy alien nests, elite squads, or fortified targets.

### Recovery

Collect parts, research, or black boxes from wreckage.

### Defense

Hold a position while systems charge, civilians evacuate, or machinery repairs.

### Escort

Protect damaged ships, drones, or transports.

## Alien Pressure

Aliens should feel like a growing environmental threat, not only discrete enemies.

Threat escalates through:

- random ambushes
- roaming patrols
- objective defenders
- teleporter activation waves
- timed pressure increases

Enemy variety can include:

- scouts
- hunters
- artillery organisms
- shielded elites
- fuel-draining parasites
- mini-boss creatures

## Mini-Bosses

Mini-bosses appear in higher-threat moments and help punctuate stage pacing.

Possible triggers:

- late-stage threat level
- optional challenge contracts
- teleporter activation
- special planets or alien hives

Mini-bosses should drop high-value rewards such as:

- rare upgrades
- large money payouts
- guaranteed repair parts
- boss progression items

## Resource Sources

Resources and recovery should come from multiple gameplay verbs so the run stays varied.

### Fuel Sources

- fuel crystals
- refueling stations
- mission rewards
- atmospheric harvesting on specific planets

### Health Recovery

- repair kits
- safe repair pads
- shop repairs
- passive repair upgrades

### Money and Materials

- objectives
- optional events
- salvage
- elite encounters
- mining

## Build Variety

The player should be able to shape a run around different strengths.

Examples:

- mobility and evasion
- shield-heavy survival
- precision combat
- explosive heavy weapons
- mining and economy
- support drone utility

The system should support strong combinations without requiring one dominant build.

## Replayability

Replayability comes from:

- generated stage layouts
- varied objective combinations
- changing shop locations
- random events
- different upgrade offers
- build diversity
- different timing decisions around teleporter exits

The goal is that players remember runs by the choices they made, not only by the random seed.

## UI and Feedback

The HUD should clearly communicate:

- health
- fuel
- money
- current objective progress
- teleporter repair progress
- threat level
- mini-map or radar
- weapon and utility cooldowns

Important support indicators:

- landing safety
- nearby hazards
- incoming attacks
- shop markers
- teleporter readiness

## Audio and Visual Direction

Visual style should support readable physics movement and strong atmosphere.

Key visual goals:

- readable planets and hazard zones
- satisfying thruster and weapon feedback
- clear objective markers
- escalating teleporter event spectacle
- distinct silhouettes for enemy tiers

Audio goals:

- powerful thruster feedback
- rising combat intensity under pressure
- readable teleporter and objective cues
- contrasting calm exploration and panic moments

## Long-Term Direction

The project should prioritize:

1. satisfying flight and landing
2. clean stage loop with teleporter progression
3. objective variety
4. enemy pressure scaling
5. shops and build variety
6. mini-boss and final boss structure

## Design Summary

The game should be built around stage-based roguelike runs rather than an infinite open world. Each stage presents a bounded but replayable sandbox with required objectives, optional opportunities, shops, rising alien pressure, and a teleporter exit. The player grows stronger through upgrades while the game grows more dangerous over time. The run ends either in failure or by intentionally defeating the final boss.
