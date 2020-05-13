import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';

class LVC {
  static var clr = StreamController<bool>.broadcast();
  static StreamSubscription<bool> tempStream;
  bool status;
  bool get thatStatus => status;
  Future<void> checker() async {
    status = await DataConnectionChecker().hasConnection;
    clr.sink.add(status);
  }

  Stream<bool> get strClr => clr.stream;
  LVC() {
    Timer.periodic(Duration(seconds: 3), (_) {
      checker();
    });
  }
}
