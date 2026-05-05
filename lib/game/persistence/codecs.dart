import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/background/parallax.dart';
import 'package:space_game/game/entry_portal/entry_portal_state.dart';
import 'package:space_game/game/entry_portal/entry_portal_tag.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/interaction/interaction_indicator_system.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
import 'package:space_game/game/mining/drill.dart';
import 'package:space_game/game/mining/mineral_tag.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/objective/components/mine_objective_data.dart';
import 'package:space_game/game/objective/components/objective.dart';
import 'package:space_game/game/objective/components/rescue_objective_data.dart';
import 'package:space_game/game/particle_system/particle.dart';
import 'package:space_game/game/particle_system/particle_emitter.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';
import 'package:space_game/game/planet/planet_tag.dart';
import 'package:space_game/game/portal/portal_state.dart';
import 'package:space_game/game/portal/portal_tag.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/difficulty_state.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';
import 'package:space_game/game/shared/damage/damage_dealer.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_spawn_point.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/components/stage_transition_state.dart';
import 'package:space_game/game/stage/stage_tag.dart';

void registerCodecs(WorldStateSerializer serializer) {
  // alien
  serializer.registerCodec<AlienTag>(_AlienTagCodec());

  // astronaut
  serializer.registerCodec<AstronautTag>(_AstronautTagCodec());
  serializer.registerCodec<AstronautLocationStore>(
    _AstronautLocationStoreCodec(),
  );

  // background
  serializer.registerCodec<Parallax>(_ParallaxCodec());

  // entry portal
  serializer.registerCodec<EntryPortalTag>(_EntryPortalTagCodec());
  serializer.registerCodec<EntryPortalState>(_EntryPortalStateCodec());

  // hud
  serializer.registerCodec<OffscreenIndicator>(_OffscreenIndicatorCodec());

  // interaction
  serializer.registerCodec<InteractionTarget>(_InteractionTargetCodec());
  serializer.registerCodec<InteractionIndicatorRef>(
    _InteractionIndicatorRefCodec(),
  );

  // mining
  serializer.registerCodec<Drill>(_DrillCodec());
  serializer.registerCodec<MineralTag>(_MineralTagCodec());
  serializer.registerCodec<ResourceNode>(_ResourceNodeCodec());

  // objective
  serializer.registerCodec<Objective>(_ObjectiveCodec());
  serializer.registerCodec<MineObjectiveData>(_MineObjectiveDataCodec());
  serializer.registerCodec<RescueObjectiveData>(_RescueObjectiveDataCodec());

  // particle system
  serializer.registerCodec<ParticleEmitter>(_ParticleEmitterCodec());
  serializer.registerCodec<Particle>(_ParticleCodec());

  // planet
  serializer.registerCodec<PlanetTag>(_PlanetTagCodec());
  serializer.registerCodec<Atmosphere>(_AtmosphereCodec());
  serializer.registerCodec<PlanetOccupant>(_PlanetOccupantCodec());

  // portal
  serializer.registerCodec<PortalTag>(_PortalTagCodec());
  serializer.registerCodec<PortalState>(_PortalStateCodec());

  // rocket
  serializer.registerCodec<RocketTag>(_RocketTagCodec());
  serializer.registerCodec<Eva>(_EvaCodec());
  serializer.registerCodec<FuelTank>(_FuelTankCodec());
  serializer.registerCodec<RocketEngine>(_RocketEngineCodec());
  serializer.registerCodec<RocketLocationStore>(_RocketLocationStoreCodec());

  // damage
  serializer.registerCodec<ConstantDamageDealer>(_ConstantDamageDealerCodec());
  serializer.registerCodec<VelocityDamageDealer>(_VelocityDamageDealerCodec());
  serializer.registerCodec<Health>(_HealthCodec());

  // run
  serializer.registerCodec<RunTag>(_RunTag());
  serializer.registerCodec<CurrentStage>(_CurrentStageCodec());
  serializer.registerCodec<DifficultyState>(_DifficultyStateCodec());
  serializer.registerCodec<RunState>(_RunStateCodec());

  // stage
  serializer.registerCodec<StageTag>(_StageTagCodec());
  serializer.registerCodec<StageSetupState>(_StageSetupStateCodec());
  serializer.registerCodec<StageSpawnPoint>(_StageSpawnPointCodec());
  serializer.registerCodec<StageState>(_StageStateCodec());
  serializer.registerCodec<StageTransitionState>(_StageTransitionStateCodec());
}

class _AlienTagCodec extends ComponentCodec<AlienTag> {
  @override
  String get typeId => 'alien.tag';

  @override
  AlienTag decode(Map<String, Object?> data) => AlienTag();

  @override
  Map<String, Object?> encode(AlienTag component) => {};
}

class _AstronautTagCodec extends ComponentCodec<AstronautTag> {
  @override
  String get typeId => 'astronaut.tag';

  @override
  AstronautTag decode(Map<String, Object?> data) => AstronautTag();

  @override
  Map<String, Object?> encode(AstronautTag component) => {};
}

class _AstronautLocationStoreCodec
    extends ComponentCodec<AstronautLocationStore> {
  @override
  String get typeId => 'astronaut.locationStore';

  @override
  AstronautLocationStore decode(Map<String, Object?> data) {
    final locationString = data['location'] as String;
    final location = switch (locationString) {
      'onPlanet' => AstronautLocationOnPlanet(
        planet: data['planet'] as Entity,
        angle: decodeDouble(data, 'angle')!,
      ),
      'inRocket' => AstronautLocationInRocket(),
      _ => throw 'Invalid astronaut location $locationString',
    };
    return AstronautLocationStore(location: location);
  }

  @override
  Map<String, Object?> encode(AstronautLocationStore component) {
    return switch (component.location) {
      AstronautLocationOnPlanet(:final planet, :final angle) => {
        'location': 'onPlanet',
        'planet': planet,
        'angle': angle,
      },
      AstronautLocationInRocket() => {'location': 'inRocket'},
    };
  }
}

class _ParallaxCodec extends ComponentCodec<Parallax> {
  @override
  String get typeId => 'background.parallax';

  @override
  Parallax decode(Map<String, Object?> data) =>
      Parallax(multiplier: decodeDouble(data, 'multiplier')!);

  @override
  Map<String, Object?> encode(Parallax component) => {
    'multiplier': component.multiplier,
  };
}

class _EntryPortalTagCodec extends ComponentCodec<EntryPortalTag> {
  @override
  String get typeId => 'entryPortal.tag';

  @override
  EntryPortalTag decode(Map<String, Object?> data) => EntryPortalTag();

  @override
  Map<String, Object?> encode(EntryPortalTag component) => {};
}

class _EntryPortalStateCodec extends ComponentCodec<EntryPortalState> {
  @override
  String get typeId => 'entryPortal.state';

  @override
  EntryPortalState decode(Map<String, Object?> data) => EntryPortalState(
    status: EntryPortalStatus.values.firstWhere(
      (v) => v.name == data['status'],
    ),
    openProgress: decodeDouble(data, 'openProgress')!,
    teleportProgress: decodeDouble(data, 'teleportProgress')!,
  );

  @override
  Map<String, Object?> encode(EntryPortalState component) => {
    'status': component.status.name,
    'openProgress': component.openProgress,
    'teleportProgress': component.teleportProgress,
  };
}

class _OffscreenIndicatorCodec extends ComponentCodec<OffscreenIndicator> {
  @override
  String get typeId => 'hud.offscreenIndicator';

  @override
  OffscreenIndicator decode(Map<String, Object?> data) =>
      OffscreenIndicator(enabled: decodeBool(data, 'enabled')!);

  @override
  Map<String, Object?> encode(OffscreenIndicator component) => {
    'enabled': component.enabled,
  };
}

class _InteractionTargetCodec extends ComponentCodec<InteractionTarget> {
  @override
  String get typeId => 'interaction.target';

  @override
  InteractionTarget decode(Map<String, Object?> data) => InteractionTarget();

  @override
  Map<String, Object?> encode(InteractionTarget component) => {};
}

class _InteractionIndicatorRefCodec
    extends ComponentCodec<InteractionIndicatorRef> {
  @override
  String get typeId => 'interaction.indicatorRef';

  @override
  InteractionIndicatorRef decode(Map<String, Object?> data) =>
      InteractionIndicatorRef(data['indicator'] as Entity);

  @override
  Map<String, Object?> encode(InteractionIndicatorRef component) => {
    'indicator': component.indicator,
  };
}

class _DrillCodec extends ComponentCodec<Drill> {
  @override
  String get typeId => 'mining.drill';

  @override
  Drill decode(Map<String, Object?> data) => Drill(
    drillSpeed: decodeDouble(data, 'drillSpeed')!,
    drillingResource: data['drillingResource'] as Entity?,
  );

  @override
  Map<String, Object?> encode(Drill component) => {
    'drillSpeed': component.drillSpeed,
    'drillingResource': component.drillingResource,
  };
}

class _MineralTagCodec extends ComponentCodec<MineralTag> {
  @override
  String get typeId => 'mining.mineralTag';

  @override
  MineralTag decode(Map<String, Object?> data) => MineralTag();

  @override
  Map<String, Object?> encode(MineralTag component) => {};
}

class _ResourceNodeCodec extends ComponentCodec<ResourceNode> {
  @override
  String get typeId => 'mining.resourceNode';

  @override
  ResourceNode decode(Map<String, Object?> data) => ResourceNode(
    remaining: decodeDouble(data, 'remaining')!,
    resourceType: ResourceType.values.firstWhere(
      (v) => v.name == data['resourceType'],
    ),
  );

  @override
  Map<String, Object?> encode(ResourceNode component) => {
    'remaining': component.remaining,
    'resourceType': component.resourceType.name,
  };
}

class _ObjectiveCodec extends ComponentCodec<Objective> {
  @override
  String get typeId => 'objective.objective';

  @override
  Objective decode(Map<String, Object?> data) => Objective(
    kind: ObjectiveKind.values.firstWhere((v) => v.name == data['kind']),
    tier: ObjectiveTier.values.firstWhere((v) => v.name == data['tier']),
    completed: decodeBool(data, 'completed')!,
  );

  @override
  Map<String, Object?> encode(Objective component) => {
    'kind': component.kind.name,
    'tier': component.tier.name,
    'completed': component.completed,
  };
}

class _MineObjectiveDataCodec extends ComponentCodec<MineObjectiveData> {
  @override
  String get typeId => 'objective.mineObjectiveData';

  @override
  MineObjectiveData decode(Map<String, Object?> data) => MineObjectiveData();

  @override
  Map<String, Object?> encode(MineObjectiveData component) => {};
}

class _RescueObjectiveDataCodec extends ComponentCodec<RescueObjectiveData> {
  @override
  String get typeId => 'objective.rescueObjectiveData';

  @override
  RescueObjectiveData decode(Map<String, Object?> data) =>
      RescueObjectiveData(astronaut: data['astronaut'] as Entity);

  @override
  Map<String, Object?> encode(RescueObjectiveData component) => {
    'astronaut': component.astronaut,
  };
}

class _ParticleEmitterCodec extends ComponentCodec<ParticleEmitter> {
  @override
  String get typeId => 'particleSystem.particleEmitter';

  @override
  ParticleEmitter decode(Map<String, Object?> data) {
    return ParticleEmitter(
      spawnRate: decodeDouble(data, 'spawnRate')!,
      maxLifetime: decodeDouble(data, 'maxLifetime')!,
      colors: (data['colors'] as List<dynamic>)
          .map((c) => decodeColor(c)!)
          .toList(),
      particleSize: decodeSize(data, 'particleSize')!,
      enabled: decodeBool(data, 'enabled')!,
      velocitySource: data['velocitySource'] as Entity?,
      turbulence: decodeDouble(data, 'turbulence')!,
      spawnCount: decodeInt(data, 'spawnCount')!,
      fadeOutTime: decodeDouble(data, 'fadeOutTime')!,
      initialVelocity: decodeVector2(data, 'initialVelocity'),
      randomSpawnOffset: decodeVector2(data, 'randomSpawnOffset'),
      minLifetime: decodeDouble(data, 'minLifetime'),
    );
  }

  @override
  Map<String, Object?> encode(ParticleEmitter component) => {
    'spawnRate': component.spawnRate,
    'maxLifetime': component.maxLifetime,
    'colors': component.colors.map((c) => encodeColor(c)).toList(),
    'particleSize': encodeSize(component.particleSize),
    'enabled': component.enabled,
    'velocitySource': component.velocitySource,
    'turbulence': component.turbulence,
    'spawnCount': component.spawnCount,
    'fadeOutTime': component.fadeOutTime,
    'initialVelocity': encodeVector2(component.initialVelocity),
    'randomSpawnOffset': encodeVector2(component.randomSpawnOffset),
    'minLifetime': component.minLifetime,
  };
}

class _ParticleCodec extends ComponentCodec<Particle> {
  @override
  String get typeId => 'particleSystem.particle';

  @override
  Particle decode(Map<String, Object?> data) => Particle(
    lifetime: decodeDouble(data, 'lifetime')!,
    initialLifetime: decodeDouble(data, 'initialLifetime')!,
    fadeOutTime: decodeDouble(data, 'fadeOutTime')!,
  );

  @override
  Map<String, Object?> encode(Particle component) => {
    'lifetime': component.lifetime,
    'initialLifetime': component.initialLifetime,
    'fadeOutTime': component.fadeOutTime,
  };
}

class _PlanetTagCodec extends ComponentCodec<PlanetTag> {
  @override
  String get typeId => 'planet.tag';

  @override
  PlanetTag decode(Map<String, Object?> data) => PlanetTag();

  @override
  Map<String, Object?> encode(PlanetTag component) => {};
}

class _AtmosphereCodec extends ComponentCodec<Atmosphere> {
  @override
  String get typeId => 'planet.atmosphere';

  @override
  Atmosphere decode(Map<String, Object?> data) => Atmosphere(
    radius: decodeDouble(data, 'radius')!,
    drag: decodeDouble(data, 'drag')!,
    fuelRichness: decodeDouble(data, 'fuelRichness')!,
  );

  @override
  Map<String, Object?> encode(Atmosphere component) => {
    'radius': component.radius,
    'drag': component.drag,
    'fuelRichness': component.fuelRichness,
  };
}

class _PlanetOccupantCodec extends ComponentCodec<PlanetOccupant> {
  @override
  String get typeId => 'planet.occupant';

  @override
  PlanetOccupant decode(Map<String, Object?> data) => PlanetOccupant(
    planet: data['planet'] as Entity,
    angle: decodeDouble(data, 'angle')!,
  );

  @override
  Map<String, Object?> encode(PlanetOccupant component) => {
    'planet': component.planet,
    'angle': component.angle,
  };
}

class _PortalTagCodec extends ComponentCodec<PortalTag> {
  @override
  String get typeId => 'portal.tag';

  @override
  PortalTag decode(Map<String, Object?> data) => PortalTag();

  @override
  Map<String, Object?> encode(PortalTag component) => {};
}

class _PortalStateCodec extends ComponentCodec<PortalState> {
  @override
  String get typeId => 'portal.state';

  @override
  PortalState decode(Map<String, Object?> data) => PortalState(
    status: PortalStatus.values.firstWhere((v) => v.name == data['status']),
    openProgress: decodeDouble(data, 'openProgress')!,
    teleportProgress: decodeDouble(data, 'teleportProgress')!,
  );

  @override
  Map<String, Object?> encode(PortalState component) => {
    'status': component.status.name,
    'openProgress': component.openProgress,
    'teleportProgress': component.teleportProgress,
  };
}

class _RocketTagCodec extends ComponentCodec<RocketTag> {
  @override
  String get typeId => 'rocket.tag';

  @override
  RocketTag decode(Map<String, Object?> data) => RocketTag();

  @override
  Map<String, Object?> encode(RocketTag component) => {};
}

class _EvaCodec extends ComponentCodec<Eva> {
  @override
  String get typeId => 'rocket.eva';

  @override
  Eva decode(Map<String, Object?> data) => Eva(
    maxInteractionRange: decodeDouble(data, 'maxInteractionRange')!,
    interactables: Set<Entity>.from(data['interactables'] as List),
  );

  @override
  Map<String, Object?> encode(Eva component) => {
    'maxInteractionRange': component.maxInteractionRange,
    'interactables': component.interactables.toList(),
  };
}

class _FuelTankCodec extends ComponentCodec<FuelTank> {
  @override
  String get typeId => 'rocket.fuelTank';

  @override
  FuelTank decode(Map<String, Object?> data) => FuelTank(
    maxFuel: decodeDouble(data, 'maxFuel')!,
    fuel: decodeDouble(data, 'fuel'),
  );

  @override
  Map<String, Object?> encode(FuelTank component) => {
    'maxFuel': component.maxFuel,
    'fuel': component.fuel,
  };
}

class _RocketEngineCodec extends ComponentCodec<RocketEngine> {
  @override
  String get typeId => 'rocket.engine';

  @override
  RocketEngine decode(Map<String, Object?> data) => RocketEngine(
    enabled: decodeBool(data, 'enabled')!,
    thrustForce: decodeDouble(data, 'thrustForce')!,
    rotationForce: decodeDouble(data, 'rotationForce')!,
    boostMultiplier: decodeDouble(data, 'boostMultiplier')!,
  );

  @override
  Map<String, Object?> encode(RocketEngine component) => {
    'enabled': component.enabled,
    'thrustForce': component.thrustForce,
    'rotationForce': component.rotationForce,
    'boostMultiplier': component.boostMultiplier,
  };
}

class _RocketLocationStoreCodec extends ComponentCodec<RocketLocationStore> {
  @override
  String get typeId => 'rocket.locationStore';

  @override
  RocketLocationStore decode(Map<String, Object?> data) {
    final locationString = data['location'] as String;
    final location = switch (locationString) {
      'inSpace' => RocketLocationInSpace(),
      'landed' => RocketLocationLanded(planet: data['planet'] as Entity),
      _ => throw 'Invalid rocket location $locationString',
    };
    return RocketLocationStore(location: location);
  }

  @override
  Map<String, Object?> encode(RocketLocationStore component) {
    return switch (component.location) {
      RocketLocationInSpace() => {'location': 'inSpace'},
      RocketLocationLanded(:final planet) => {
        'location': 'landed',
        'planet': planet,
      },
    };
  }
}

class _RunTag extends ComponentCodec<RunTag> {
  @override
  String get typeId => 'run.tag';

  @override
  RunTag decode(Map<String, Object?> data) => RunTag();

  @override
  Map<String, Object?> encode(RunTag component) => {};
}

class _CurrentStageCodec extends ComponentCodec<CurrentStage> {
  @override
  String get typeId => 'run.currentStage';

  @override
  CurrentStage decode(Map<String, Object?> data) =>
      CurrentStage(stage: data['stage'] as Entity?);

  @override
  Map<String, Object?> encode(CurrentStage component) => {
    'stage': component.stage,
  };
}

class _DifficultyStateCodec extends ComponentCodec<DifficultyState> {
  @override
  String get typeId => 'run.difficultyState';

  @override
  DifficultyState decode(Map<String, Object?> data) =>
      DifficultyState(runTime: decodeDouble(data, 'runTime')!);

  @override
  Map<String, Object?> encode(DifficultyState component) => {
    'runTime': component.runTime,
  };
}

class _RunStateCodec extends ComponentCodec<RunState> {
  @override
  String get typeId => 'run.state';

  @override
  RunState decode(Map<String, Object?> data) => RunState(
    phase: RunPhase.values.firstWhere((v) => v.name == data['phase']),
    stageIndex: decodeInt(data, 'stageIndex')!,
  );

  @override
  Map<String, Object?> encode(RunState component) => {
    'phase': component.phase.name,
    'stageIndex': component.stageIndex,
  };
}

class _ConstantDamageDealerCodec extends ComponentCodec<ConstantDamageDealer> {
  @override
  String get typeId => 'damage.constantDamageDealer';

  @override
  ConstantDamageDealer decode(Map<String, Object?> data) =>
      ConstantDamageDealer(damage: decodeDouble(data, 'damage')!);

  @override
  Map<String, Object?> encode(ConstantDamageDealer component) => {
    'damage': component.damage,
  };
}

class _VelocityDamageDealerCodec extends ComponentCodec<VelocityDamageDealer> {
  @override
  String get typeId => 'damage.velocityDamageDealer';

  @override
  VelocityDamageDealer decode(Map<String, Object?> data) =>
      VelocityDamageDealer(
        damageMultiplier: decodeDouble(data, 'damageMultiplier')!,
        minVelocity: decodeDouble(data, 'minVelocity')!,
      );

  @override
  Map<String, Object?> encode(VelocityDamageDealer component) => {
    'damageMultiplier': component.damageMultiplier,
    'minVelocity': component.minVelocity,
  };
}

class _HealthCodec extends ComponentCodec<Health> {
  @override
  String get typeId => 'damage.health';

  @override
  Health decode(Map<String, Object?> data) => Health(
    maxHealth: decodeDouble(data, 'maxHealth')!,
    currentHealth: decodeDouble(data, 'currentHealth'),
  );

  @override
  Map<String, Object?> encode(Health component) => {
    'maxHealth': component.maxHealth,
    'currentHealth': component.currentHealth,
  };
}

class _StageTagCodec extends ComponentCodec<StageTag> {
  @override
  String get typeId => 'stage.tag';

  @override
  StageTag decode(Map<String, Object?> data) => StageTag();

  @override
  Map<String, Object?> encode(StageTag component) => {};
}

class _StageSetupStateCodec extends ComponentCodec<StageSetupState> {
  @override
  String get typeId => 'stage.setupState';

  @override
  StageSetupState decode(Map<String, Object?> data) => StageSetupState(
    status: StageSetupStatus.values.firstWhere((v) => v.name == data['status']),
  );

  @override
  Map<String, Object?> encode(StageSetupState component) => {
    'status': component.status.name,
  };
}

class _StageSpawnPointCodec extends ComponentCodec<StageSpawnPoint> {
  @override
  String get typeId => 'stage.spawnPoint';

  @override
  StageSpawnPoint decode(Map<String, Object?> data) =>
      StageSpawnPoint(playerPosition: decodeVector2(data, 'playerPosition'));

  @override
  Map<String, Object?> encode(StageSpawnPoint component) => {
    'playerPosition': encodeVector2(component.playerPosition),
  };
}

class _StageStateCodec extends ComponentCodec<StageState> {
  @override
  String get typeId => 'stage.state';

  @override
  StageState decode(Map<String, Object?> data) => StageState(
    phase: StagePhase.values.firstWhere((v) => v.name == data['phase']),
  );

  @override
  Map<String, Object?> encode(StageState component) => {
    'phase': component.phase.name,
  };
}

class _StageTransitionStateCodec extends ComponentCodec<StageTransitionState> {
  @override
  String get typeId => 'stage.transitionState';

  @override
  StageTransitionState decode(Map<String, Object?> data) =>
      StageTransitionState(playerPlaced: decodeBool(data, 'playerPlaced')!);

  @override
  Map<String, Object?> encode(StageTransitionState component) => {
    'playerPlaced': component.playerPlaced,
  };
}
