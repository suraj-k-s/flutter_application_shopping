import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';

class ScreenLoader {
  Timer? _timer;
  ScreenLoader._internal();
  static ScreenLoader instance = ScreenLoader._internal();
  factory ScreenLoader() {
    return ScreenLoader.instance;
  }
  Future<void> screenLoaderSuccessFailStart() async {
    _timer?.cancel();
    await EasyLoading.show(
      status: 'loading...',
      maskType: EasyLoadingMaskType.black,
    );
  }

  void screenLoaderDismiss(String type, String msg) async {
    if (type == '1') {
      EasyLoading.showSuccess(msg);
      await Future.delayed(const Duration(seconds: 2));
    }
    if (type == '0') {
      EasyLoading.showError(msg);
      await Future.delayed(const Duration(seconds: 2));
    } else {
      await Future.delayed(const Duration(seconds: 1));
    }

    EasyLoading.dismiss();
  }
}
