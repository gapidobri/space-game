import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

@immutable
class SettingsData {
  const SettingsData({this.musicVolume = 0.25, this.sfxVolume = 1.0});

  final double musicVolume;
  final double sfxVolume;

  SettingsData copyWith({double? musicVolume, double? sfxVolume}) =>
      SettingsData(
        musicVolume: musicVolume ?? this.musicVolume,
        sfxVolume: sfxVolume ?? this.sfxVolume,
      );
}

class SettingsController extends ValueNotifier<SettingsData> {
  SettingsController(this._prefs) : super(const SettingsData());

  static const _kMusic = 'settings.musicVolume';
  static const _kSfx = 'settings.sfxVolume';

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
    );
  }

  Future<void> setMusicVolume(double v, {bool persist = true}) async {
    final next = v.clamp(0.0, 1.0);
    if (next == value.musicVolume) return;
    value = value.copyWith(musicVolume: next);
    if (persist) await _prefs.setDouble(_kMusic, next);
  }

  Future<void> setSfxVolume(double v, {bool persist = true}) async {
    final next = v.clamp(0.0, 1.0);
    if (next == value.sfxVolume) return;
    value = value.copyWith(sfxVolume: next);
    if (persist) await _prefs.setDouble(_kSfx, next);
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
