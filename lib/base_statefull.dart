import 'package:treasury_test/base_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

abstract class BaseStateful<S extends StatefulWidget, T extends BaseProvider>
    extends State<S> {
  late T state;

  void back([data]) {
    Navigator.pop(context, data);
  }

  void multipleBack([data, int totalPop = 1]) {
    for (int i = 0; i < totalPop; i++) Navigator.pop(context, data);
  }

  void backToTop() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  void registerState() {}

  @override
  Widget build(BuildContext context) {
    registerState();
    return layout(context);
  }

  Widget layout(BuildContext context);

  Widget createNotifier(
      {Widget Function(BuildContext context, T state, Widget? child)?
      builder}) {
    // assert(state != null, 'Please initiate $T as state in registerState');
    return ChangeNotifierProvider<T>(
      create: (_) => state,
      child: Consumer<T>(
        builder: (BuildContext context, T state, Widget? child) {
          this.state = state;
          return builder!(context, state, child);
        },
      ),
    );
  }
}
