import 'package:emoji_picker/core/di/di.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

var getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() {
  getIt.init();
}
