import 'package:data_connection_checker/data_connection_checker.dart';
import 'dart:async';

class Connectivity {
  var clr = StreamController<bool>.broadcast();
  bool status;
  bool get thatStatus => status;
  Future<void> checker() async {
    status = await DataConnectionChecker().hasConnection;
    clr.sink.add(status);
  }

  Timer timeIt;
  void startTimer() {
    timeIt = Timer.periodic(Duration(seconds: 3), (_) {
      checker();
    });
  }

  Stream<bool> get strClr => clr.stream;
  void disabler() async {
    print("thy is done!");
    await clr.close();
    timeIt.cancel();
  }
}
