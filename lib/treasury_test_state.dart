import 'dart:math';

import 'package:treasury_test/base_provider.dart';

class TreasuryTestState extends BaseProvider{
  String? treasuryText = "Find a job, tap here !";
  List<int> expansionTileKey = List<int>.empty(growable: true);
  int totalList = 20;

  void setTreasuryText(){
    treasuryText = "Congratulation";
    notifyListeners();
  }

  void initExpansionKey(){
    for(var i=0;i<totalList;i++){
      expansionTileKey.add(Random().nextInt(10000));
    }
  }
}
