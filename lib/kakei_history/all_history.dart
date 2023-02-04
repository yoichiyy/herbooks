import 'package:counter/counter/book_count_area.dart';
import 'package:counter/counter/history_sum_card.dart';
import 'package:counter/counter/home_card_kakei.dart';
import 'package:counter/counter/kakei_count_area.dart';
import 'package:counter/counter/num_count.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

class AllHistory extends StatefulWidget {
  const AllHistory({Key? key}) : super(key: key);

  @override
  State<AllHistory> createState() => _AllHistoryState();
}

class _AllHistoryState extends State<AllHistory> {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final dailyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}${DateTime.now().day}";
  final monthlyCount =
      "${DateTime.now().year}${DateTime.now().month.toString().padLeft(2, "0")}";
  final totalCount = "total";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<NumCountModel>(
        create: (_) => NumCountModel()..getGraphData(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text("おこづかい"),
          ),
          body: Consumer<NumCountModel>(
            builder: (context, model, child) {
              return GestureDetector(
                onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
                behavior: HitTestBehavior.opaque,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      //グラフ部分
                      //グラフ2：赤
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 150,
                          animation: true,
                          animationDuration: 1000,
                          lineHeight: 20.0,
                          leading: Text(model.graphStartDay),
                          center: Text((model.remainPeriodPercent >= 1)
                              ? "終了！"
                              : "あと${model.remainDay.toString()}日"),
                          trailing: Text(model.graphGoalDay),
                          percent: (model.remainPeriodPercent > 1)
                              ? 1
                              : model.remainPeriodPercent,
                          barRadius: const Radius.circular(16),
                          progressColor: Colors.red,
                        ),
                      ),

                      //冊数progress
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: LinearPercentIndicator(
                          width: MediaQuery.of(context).size.width - 100,
                          animation: true,
                          lineHeight: 20.0,
                          animationDuration: 2000,
                          leading: Text(model.sumDouble.toString()),
                          center: Text((model.remainPeriodPercent >= 100)
                              ? "おめでとう！"
                              : "あと${model.remainSassuToRead.toString()}冊"),
                          trailing: Text(model.goalSassu.toString()),
                          percent: (model.remainPercentToRead > 1)
                              ? 1
                              : model.remainPercentToRead,
                          barRadius: const Radius.circular(16),
                          progressColor: Colors.greenAccent,
                        ),
                      ),

                      //かけい部分
                      HomeCardWidgetKakei(
                        title: "おこづかい",
                        color: Colors.green[100]!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            kakeiCountArea("kakei"),
                            const SizedBox(
                              width: 10,
                              height: 10,
                            ),
                          ],
                        ),
                      ),

//はる
                      HistorySumCard(
                        title: "はる",
                        musume: "haru",
                        color: Colors.red[100]!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            bookCountArea("haru"),
                            const Center(
                              child: SizedBox(
                                width: 10,
                                height: 20,
                              ),
                              //children
                            ),
                          ],
                        ),
                      ),

                      //ゆめ
                      HistorySumCard(
                        title: "ゆめ",
                        musume: "yume",
                        color: Colors.red[100]!,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            bookCountArea("yume"),
                            const Center(
                              child: SizedBox(
                                width: 10,
                                height: 20,
                              ),
                              //children
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: const BottomBar(currentIndex: 2),
        ),
      ),
    );
  } //widget build
} //class
