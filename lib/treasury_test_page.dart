import 'dart:math' as m;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:treasury_test/base_statefull.dart';
import 'package:treasury_test/treasury_test_state.dart';
import 'package:treasury_test/v_color.dart';
import 'package:treasury_test/v_widgets.dart';

import 'size_config.dart';



class TreasuryTestPage extends StatefulWidget {
  @override
  _TreasuryTestPageState createState() => _TreasuryTestPageState();
}

class _TreasuryTestPageState extends BaseStateful<TreasuryTestPage,TreasuryTestState> {
  @override
  Widget layout(BuildContext context) {
    return createNotifier(builder: (context, state, child) {
      return Scaffold(
        floatingActionButton: VCircleIconButton(imgPath: "plus_icon.svg",onPressed: (){},),
        body: state.isLoading ?  VLoadingPage() : _body(),
      );
    });
  }
  Widget _body(){
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).viewPadding.top+10,
            bottom: getProportionateScreenWidth(10),
            left: getProportionateScreenWidth(10),
            right: getProportionateScreenWidth(10),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VText("Main Page",color: VColor.primary,fontSize: getProportionateScreenWidth(17),isBold: true,align: TextAlign.left,),
                    VText("Welcome",color: VColor.primary,fontSize: getProportionateScreenWidth(14),isBold: false,align: TextAlign.left,),
                  ],
                ),
              ),
              InkWell(
                onTap: (){},
                child: VText("Add",color: VColor.primary,fontSize: getProportionateScreenWidth(14),isBold: true,),
              ),
            ],
          ),
        ),
        Divider(
          color: VColor.primary,
          height: getProportionateScreenWidth(2),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(
              top: getProportionateScreenWidth(15),
              left: getProportionateScreenWidth(10),
              right: getProportionateScreenWidth(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 3,
                        child: AspectRatio(
                          aspectRatio: 1 / 1.25,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: VColor.primary),
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: getProportionateScreenWidth(15),),
                    Expanded(
                        flex: 3,
                        child: AspectRatio(
                          aspectRatio: 1 / 1.25,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: VColor.primary),
                            ),
                          ),
                        )
                    ),
                    SizedBox(width: getProportionateScreenWidth(15),),
                    Expanded(
                        flex: 3,
                        child: AspectRatio(
                          aspectRatio: 1 / 1.25,
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: VColor.primary),
                            ),
                          ),
                        )
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenWidth(100),),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.totalList,
                    itemBuilder: (context,index){
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(color: VColor.primary)
                        ),
                        padding: EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(10)),
                        margin: EdgeInsets.only(bottom: getProportionateScreenWidth(10)),
                        child: VExpansionTile(
                          title: VText("Menu "+(index+1).toString(),color: VColor.primary,isBold: true,fontSize: getProportionateScreenWidth(17),),
                          childrenPadding: EdgeInsets.all(getProportionateScreenWidth(10)),
                          iconColor: VColor.white,
                          collapsedIconColor: VColor.white,
                          key: Key(state.expansionTileKey[index].toString()),
                          tilePadding: EdgeInsets.zero,
                          expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
                          onExpansionChanged: (value){
                            collapse(index);
                          },
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                VText("Information",color: VColor.primary,isBold: true,fontSize: getProportionateScreenWidth(14),),
                                VButton(
                                  "Ok",
                                  textPadding : getProportionateScreenWidth(10),
                                  onPressed: (){
                                    Fluttertoast.showToast(msg: "Menu "+(index+1).toString());
                                  },
                                ),
                              ],
                            ),
                            VText("Name "+(index+1).toString(),color: VColor.primary,isBold: false,fontSize: getProportionateScreenWidth(14),),
                            VText("Address "+(index+1).toString(),color: VColor.primary,isBold: false,fontSize: getProportionateScreenWidth(14),),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  collapse(int index) {
    int newKey;
    for(var i = 0;i<state.totalList;i++){
      if(i!=index){
        do {
          newKey = m.Random().nextInt(10000);
        } while(newKey == state.expansionTileKey[i]);
        state.expansionTileKey[i] = newKey;
      }
    }
    state.notifyListeners();
  }

  @override
  void registerState() {
    state = TreasuryTestState();
    state.initExpansionKey();
    state.isLoading = false;
  }


}


