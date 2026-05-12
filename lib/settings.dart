import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsData {
  const SettingsData({
    this.musicVolume = 0.25,
    this.sfxVolume = 1.0,
    this.sfxEnabled = true,
  });

  final double musicVolume;
  final double sfxVolume;
  final bool sfxEnabled;

  SettingsData copyWith({
    double? musicVolume,
    double? sfxVolume,
    bool? sfxEnabled,
  }) => SettingsData(
    musicVolume: musicVolume ?? this.musicVolume,
    sfxVolume: sfxVolume ?? this.sfxVolume,
    sfxEnabled: sfxEnabled ?? this.sfxEnabled,
  );
}

class SettingsController extends ValueNotifier<SettingsData> {
  SettingsController(this._prefs) : super(const SettingsData());

  static const _kMusic = 'settings.musicVolume';
  static const _kSfx = 'settings.sfxVolume';
  static const _kSfxEnabled = 'settings.sfxEnabled';

  final SharedPreferences _prefs;

  Future<void> load() async {
    value = value.copyWith(
      musicVolume: ((_prefs.getDouble(_kMusic) ?? value.musicVolume).clamp(
        0.0,
        1.0,
      )).toDouble(),
      sfxVolume: ((_prefs.getDouble(_kSfx) ?? value.sfxVolume).clamp(
        0.0,
        1.0,
      )).toDouble(),
      sfxEnabled: _prefs.getBool(_kSfxEnabled) ?? value.sfxEnabled,
    );
  }

  Future<void> setMusicVolume(double v, {bool persist = true}) async {
    final next = v.clamp(0.0, 1.0);
    if (!persist && next == value.musicVolume) return;
    value = value.copyWith(musicVolume: next);
    if (persist) await _prefs.setDouble(_kMusic, next);
  }

  Future<void> setSfxVolume(double v, {bool persist = true}) async {
    final next = v.clamp(0.0, 1.0);
    if (!persist && next == value.sfxVolume) return;
    value = value.copyWith(sfxVolume: next);
    if (persist) await _prefs.setDouble(_kSfx, next);
  }

  Future<void> setSfxEnabled(bool enabled, {bool persist = true}) async {
    if (!persist && enabled == value.sfxEnabled) return;
    value = value.copyWith(sfxEnabled: enabled);
    if (persist) await _prefs.setBool(_kSfxEnabled, enabled);
  }
}

class SettingsScope extends InheritedNotifier<SettingsController> {
  const SettingsScope({
    super.key,
    required SettingsController controller,
    required super.child,
  }) : super(notifier: controller);

  static SettingsController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SettingsScope>();
    assert(scope != null, 'SettingsScope not found in widget tree');
    return scope!.notifier!;
  }
}
