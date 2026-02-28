import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart' hide Transform;
import 'package:flutter/services.dart';
import 'package:gamengine/gamengine.dart';

void main() {
  runApp(const SpaceGameApp());
}

class SpaceGameApp extends StatelessWidget {
  const SpaceGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: EngineDemoPage(),
    );
  }
}

class EngineDemoPage extends StatefulWidget {
  const EngineDemoPage({super.key});

  @override
  State<EngineDemoPage> createState() => _EngineDemoPageState();
}

class _EngineDemoPageState extends State<EngineDemoPage> {
  late final Engine _engine;
  late final World _world;
  late final Entity _rocketEntity;
  late final RenderQueue _queue;
  late final RenderMetrics _renderMetrics;
  late final DebugStats _debugStats;
  late final CameraState _camera;
  late final Future<void> _setupFuture;

  final FocusNode _focusNode = FocusNode();
  final FlightInputState _flightInput = FlightInputState();
  final math.Random _rng = math.Random(42);

  @override
  void initState() {
    super.initState();
    _world = World();
    _engine = Engine(world: _world);
    _queue = RenderQueue();
    _renderMetrics = RenderMetrics();
    _debugStats = DebugStats();
    _camera = CameraState()
      ..zoom = 1
      ..cullingPadding = 280
      ..viewportWidth = 1280
      ..viewportHeight = 720;
    _setupFuture = _setupDemo();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    final isDown = event is! KeyUpEvent;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.keyA) {
      _flightInput.turnLeft = isDown;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.keyD) {
      _flightInput.turnRight = isDown;
    } else if (event.logicalKey == LogicalKeyboardKey.space) {
      _flightInput.thrust = isDown;
    } else if (event.logicalKey == LogicalKeyboardKey.shiftLeft ||
        event.logicalKey == LogicalKeyboardKey.shiftRight) {
      _flightInput.boost = isDown;
    }

    return KeyEventResult.handled;
  }

  Future<void> _setupDemo() async {
    final rocketImage = await _createRocketImage();
    final rockImage = await _createRockImage();

    final planetImages = <ui.Image>[
      await _createPlanetImage(
        radius: 90,
        coreColor: const Color(0xFF2B6CB0),
        rimColor: const Color(0xFF7BC9FF),
      ),
      await _createPlanetImage(
        radius: 72,
        coreColor: const Color(0xFF805AD5),
        rimColor: const Color(0xFFC4B5FD),
      ),
      await _createPlanetImage(
        radius: 110,
        coreColor: const Color(0xFF0F766E),
        rimColor: const Color(0xFF5EEAD4),
      ),
    ];

    _addPlanet(
      x: 0,
      y: 0,
      radius: 90,
      mass: 420000,
      spriteImage: planetImages[0],
    );
    _addPlanet(
      x: 920,
      y: -420,
      radius: 72,
      mass: 260000,
      spriteImage: planetImages[1],
    );
    _addPlanet(
      x: -980,
      y: 520,
      radius: 110,
      mass: 550000,
      spriteImage: planetImages[2],
    );

    _rocketEntity = _addRocket(
      x: 0,
      y: -250,
      orbitCenterX: 0,
      orbitCenterY: 0,
      orbitMass: 420000,
      spriteImage: rocketImage,
    );

    _spawnDebrisField(
      centerX: 0,
      centerY: 0,
      centerMass: 420000,
      count: 18,
      minRadius: 180,
      maxRadius: 440,
      spriteImage: rockImage,
    );
    _spawnDebrisField(
      centerX: 920,
      centerY: -420,
      centerMass: 260000,
      count: 12,
      minRadius: 150,
      maxRadius: 320,
      spriteImage: rockImage,
    );

    final physicsSystem = PhysicsSystem(
      world: _world,
      gravitationalConstant: 1.0,
    );
    final collisionSystem = CollisionSystem(world: _world);
    final particleSystem = ParticleSystem(world: _world, maxParticles: 6000);

    _engine.addSystem(
      RocketControlSystem(world: _world, input: _flightInput),
      700,
    );
    _engine.addSystem(
      CameraFollowSystem(camera: _camera, target: _rocketEntity),
      650,
    );
    _engine.addSystem(physicsSystem, 500);
    _engine.addSystem(collisionSystem, 490);
    _engine.addSystem(
      CollisionParticleEffectsSystem(
        collisionSystem: collisionSystem,
        particleSystem: particleSystem,
      ),
      485,
    );
    _engine.addSystem(particleSystem, 480);
    _engine.addSystem(
      RenderSystem(
        world: _world,
        queue: _queue,
        camera: _camera,
        metrics: _renderMetrics,
        particleSystem: particleSystem,
      ),
      1000,
    );
    _engine.addSystem(
      DebugSystem(stats: _debugStats, renderMetrics: _renderMetrics),
      900,
    );
    _engine.addSystem(
      PhysicsDebugSystem(
        world: _world,
        stats: _debugStats,
        physicsSystem: physicsSystem,
      ),
      450,
    );
  }

  void _addPlanet({
    required double x,
    required double y,
    required double radius,
    required double mass,
    required ui.Image spriteImage,
  }) {
    final entity = Entity();
    final transform = Transform();
    transform.position.x = x;
    transform.position.y = y;

    entity.add(transform);
    entity.add(GravitySource(mass: mass, minDistance: radius * 0.65));
    entity.add(
      Collider(
        radius: radius,
        restitution: 0.1,
        staticFriction: 0.9,
        dynamicFriction: 0.72,
      ),
    );
    entity.add(Sprite(image: spriteImage, visible: true));

    _engine.addEntity(entity);
  }

  Entity _addRocket({
    required double x,
    required double y,
    required double orbitCenterX,
    required double orbitCenterY,
    required double orbitMass,
    required ui.Image spriteImage,
  }) {
    final entity = Entity();
    final transform = Transform();
    transform.position.x = x;
    transform.position.y = y;
    transform.rotation = 0;

    final dx = x - orbitCenterX;
    final dy = y - orbitCenterY;
    final radius = math.sqrt((dx * dx) + (dy * dy));
    final orbitalSpeed = math.sqrt(orbitMass / radius);
    final tangentX = -dy / radius;
    final tangentY = dx / radius;

    final body = RigidBody(
      mass: 1.2,
      linearDamping: 0.003,
      angularDamping: 3,
      gravityScale: 1,
    );
    body.velocity.x = tangentX * orbitalSpeed;
    body.velocity.y = tangentY * orbitalSpeed;

    entity.add(transform);
    entity.add(body);
    entity.add(
      Collider(
        radius: 14,
        restitution: 0.28,
        staticFriction: 0.62,
        dynamicFriction: 0.5,
      ),
    );
    final boosterEmitter = ParticleEmitter(
      emissionRate: 0,
      spread: 0.32,
      speedMin: 35,
      speedMax: 90,
      lifetimeMin: 0.18,
      lifetimeMax: 0.45,
      sizeStartMin: 1.6,
      sizeStartMax: 3.2,
      sizeEndMin: 0.1,
      sizeEndMax: 1.1,
      drag: 1.8,
      colorStart: const Color(0xFFFFF1B8),
      colorEnd: const Color(0x00FF5D00),
      z: 3,
    );
    boosterEmitter.localOffset
      ..x = 0
      ..y = 24;
    boosterEmitter.localDirection
      ..x = 0
      ..y = 1;
    entity.add(boosterEmitter);
    entity.add(
      RocketPilot(thrustForce: 1050, turnSpeed: 5.0, boostMultiplier: 2.2),
    );
    entity.add(Sprite(image: spriteImage, visible: true));

    _engine.addEntity(entity);
    return entity;
  }

  void _spawnDebrisField({
    required double centerX,
    required double centerY,
    required double centerMass,
    required int count,
    required double minRadius,
    required double maxRadius,
    required ui.Image spriteImage,
  }) {
    for (var i = 0; i < count; i++) {
      final angle = _rng.nextDouble() * math.pi * 2;
      final radius = minRadius + (_rng.nextDouble() * (maxRadius - minRadius));

      final entity = Entity();
      final transform = Transform();
      transform.position.x = centerX + (math.cos(angle) * radius);
      transform.position.y = centerY + (math.sin(angle) * radius);

      final scale = 0.55 + (_rng.nextDouble() * 0.95);
      transform.scale.x = scale;
      transform.scale.y = scale;

      final speed =
          math.sqrt(centerMass / radius) * (0.9 + _rng.nextDouble() * 0.25);
      final tangentX = -math.sin(angle);
      final tangentY = math.cos(angle);

      final body = RigidBody(
        mass: 0.4 + _rng.nextDouble() * 0.8,
        linearDamping: 0,
        gravityScale: 1,
      );
      body.velocity.x = tangentX * speed;
      body.velocity.y = tangentY * speed;

      entity.add(transform);
      entity.add(body);
      entity.add(
        Collider(
          radius: 10 * scale,
          restitution: 0.12,
          staticFriction: 0.78,
          dynamicFriction: 0.62,
        ),
      );
      entity.add(Sprite(image: spriteImage, visible: true));

      _engine.addEntity(entity);
    }
  }

  Future<ui.Image> _createRocketImage() async {
    const width = 34.0;
    const height = 56.0;

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final glowPaint = Paint()..color = const Color(0xAA0D1A2E);
    final hullPaint = Paint()..color = const Color(0xFFE2E8F0);
    final accentPaint = Paint()..color = const Color(0xFF38BDF8);
    final finPaint = Paint()..color = const Color(0xFFFF6B6B);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, width, height),
        const Radius.circular(18),
      ),
      glowPaint,
    );

    final bodyRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(7, 8, width - 14, height - 16),
      const Radius.circular(10),
    );
    canvas.drawRRect(bodyRect, hullPaint);

    final nose = Path()
      ..moveTo(width / 2, 0)
      ..lineTo(width - 8, 14)
      ..lineTo(8, 14)
      ..close();
    canvas.drawPath(nose, accentPaint);

    final leftFin = Path()
      ..moveTo(7, height - 10)
      ..lineTo(1, height)
      ..lineTo(11, height - 3)
      ..close();
    final rightFin = Path()
      ..moveTo(width - 7, height - 10)
      ..lineTo(width - 1, height)
      ..lineTo(width - 11, height - 3)
      ..close();
    canvas.drawPath(leftFin, finPaint);
    canvas.drawPath(rightFin, finPaint);

    final picture = recorder.endRecording();
    return picture.toImage(width.toInt(), height.toInt());
  }

  Future<ui.Image> _createPlanetImage({
    required double radius,
    required Color coreColor,
    required Color rimColor,
  }) async {
    final size = (radius * 2).ceilToDouble();
    final center = Offset(size / 2, size / 2);

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final planetPaint = Paint()
      ..shader = ui.Gradient.radial(
        Offset(center.dx - (radius * 0.3), center.dy - (radius * 0.35)),
        radius * 1.1,
        [rimColor, coreColor],
      );
    canvas.drawCircle(center, radius, planetPaint);

    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(2.0, radius * 0.06)
      ..color = rimColor.withValues(alpha: 0.6);
    canvas.drawCircle(center, radius * 0.95, ringPaint);

    final picture = recorder.endRecording();
    return picture.toImage(size.toInt(), size.toInt());
  }

  Future<ui.Image> _createRockImage() async {
    const size = 20.0;
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    final bodyPaint = Paint()..color = const Color(0xFF8B8F98);
    final detailPaint = Paint()..color = const Color(0xFF5E626A);

    final rock = Path()
      ..moveTo(2, 8)
      ..lineTo(7, 2)
      ..lineTo(15, 3)
      ..lineTo(19, 10)
      ..lineTo(14, 18)
      ..lineTo(6, 17)
      ..close();
    canvas.drawPath(rock, bodyPaint);

    canvas.drawCircle(const Offset(9, 8), 2.2, detailPaint);
    canvas.drawCircle(const Offset(13, 13), 1.6, detailPaint);

    final picture = recorder.endRecording();
    return picture.toImage(size.toInt(), size.toInt());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: Focus(
        focusNode: _focusNode,
        autofocus: true,
        onKeyEvent: _onKeyEvent,
        child: SafeArea(
          child: FutureBuilder<void>(
            future: _setupFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              return Stack(
                children: [
                  Positioned.fill(
                    child: GameView(
                      engine: _engine,
                      queue: _queue,
                      camera: _camera,
                      debugStats: _debugStats,
                      physicsOverlayWorld: _world,
                      showPhysicsVectors: true,
                    ),
                  ),
                  const Positioned(
                    right: 14,
                    bottom: 14,
                    child: _ControlHint(),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ControlHint extends StatelessWidget {
  const _ControlHint();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x99000000),
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Text(
          'Left/Right: Rotate\nSpace: Thrust\nShift: Boost',
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

class FlightInputState {
  bool turnLeft = false;
  bool turnRight = false;
  bool thrust = false;
  bool boost = false;
}

class RocketPilot extends Component {
  final double thrustForce;
  final double turnSpeed;
  final double boostMultiplier;

  RocketPilot({
    required this.thrustForce,
    required this.turnSpeed,
    required this.boostMultiplier,
  });
}

class RocketControlSystem extends System {
  final World world;
  final FlightInputState input;

  RocketControlSystem({required this.world, required this.input});

  @override
  int get priority => 700;

  @override
  void update(double dt) {
    for (final entity in world.query2<Transform, RocketPilot>()) {
      final transform = world.get<Transform>(entity);
      final body = world.get<RigidBody>(entity);
      final pilot = world.get<RocketPilot>(entity);
      final emitter = entity.get<ParticleEmitter>();

      var turnInput = 0.0;
      if (input.turnLeft) {
        turnInput -= 1.0;
      }
      if (input.turnRight) {
        turnInput += 1.0;
      }
      body.angularVelocity = turnInput * pilot.turnSpeed;

      if (!input.thrust) {
        if (emitter != null) {
          emitter.emissionRate = 0;
        }
        continue;
      }

      final boost = input.boost ? pilot.boostMultiplier : 1.0;
      final thrust = pilot.thrustForce * boost;
      if (emitter != null) {
        emitter.emissionRate = 100.0 * boost;
      }

      final sinR = math.sin(transform.rotation);
      final cosR = math.cos(transform.rotation);

      body.accumulatedForce.x += sinR * thrust;
      body.accumulatedForce.y += -cosR * thrust;
    }
  }
}

class CollisionParticleEffectsSystem extends System {
  final CollisionSystem collisionSystem;
  final ParticleSystem particleSystem;

  CollisionParticleEffectsSystem({
    required this.collisionSystem,
    required this.particleSystem,
  });

  @override
  int get priority => 485;

  @override
  void update(double dt) {
    for (final event in collisionSystem.events) {
      final isPlanetHit =
          event.entityA.get<GravitySource>() != null ||
          event.entityB.get<GravitySource>() != null;
      if (!isPlanetHit || event.relativeSpeed < 10) {
        continue;
      }

      final burstCount = 8 + (event.relativeSpeed * 0.08).clamp(0, 18).toInt();
      particleSystem.emitBurst(
        origin: event.point,
        direction: event.normal,
        burstCount: burstCount,
        spread: 1.05,
        speedMin: 35,
        speedMax: 185,
        lifetimeMin: 0.12,
        lifetimeMax: 0.42,
        sizeStartMin: 1.2,
        sizeStartMax: 2.8,
        sizeEndMin: 0.1,
        sizeEndMax: 0.7,
        dragMin: 1.5,
        dragMax: 4.2,
        colorStart: const Color(0xFFFFF1C2),
        colorEnd: const Color(0x00FF6A00),
        z: 2,
      );
    }
  }
}
