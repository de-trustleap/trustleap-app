import 'dart:async';

import 'package:finanzbegleiter/core/remote_config/app_remote_config_service.dart';
import 'package:finanzbegleiter/core/remote_config/app_remote_config_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRemoteConfigCubit extends Cubit<AppRemoteConfigState> {
  final AppRemoteConfigService _service;
  StreamSubscription<void>? _sub;

  AppRemoteConfigCubit(this._service)
      : super(AppRemoteConfigState(tremendousEnabled: _service.tremendousEnabled)) {
    _sub = _service.onConfigUpdated.listen((_) async {
      await _service.activate();
      emit(AppRemoteConfigState(tremendousEnabled: _service.tremendousEnabled));
    });
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
