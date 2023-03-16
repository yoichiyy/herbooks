import 'package:audioplayers/audioplayers.dart';
import 'package:counter/task_list/thank_list.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../task_edit/create_task.dart';
import 'task_model.dart';

class TaskMonster extends StatefulWidget {
  const TaskMonster({super.key});

  @override
  State<TaskMonster> createState() => _TaskMonsterState();
}

class _TaskMonsterState extends State<TaskMonster> {
  double _monsterSize = 150;
  final double _fontSize = 13;
  int _tapCount = 0;
  // final double _initialMonsterSize = 150;
  // bool isTapped = false;

  void _updateImageSize() {
    setState(() {
      _tapCount++;
      // isTapped = true;
      if (_tapCount == 3) {
        _monsterSize = 0.0;
      } else {
        _monsterSize /= 1.5;
      }
    });
  }

  Future<void> _playSound() async {
    AudioPlayer _audioPlayer = AudioPlayer();
    await _audioPlayer.setSource(AssetSource('sword.mp3'));
  }

  void _handleTap() async {
    await _playSound();
    _updateImageSize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomBar(currentIndex: 0),
      appBar: AppBar(
        title: const Text('やること'),
        actions: [
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: OutlinedButton(
              child:
                  const Text('THANKS', style: TextStyle(color: Colors.white)),
              onPressed: () async {
                await Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ThankList(),
                  ),
                );
              },
            ),
          )
        ],
      ),
      body: Consumer<TaskModel>(
        builder: (context, model, child) {
          model.getTodoListRealtime();
          // model.getUserGraph();
          // final double scaleFactor = isTapped ? 0.1 : 1.0;
          // final todoList = model.todoList;
          final todoList = model.todoListFromModelOverDue;

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: _handleTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  alignment: Alignment.center, //TODO:これじゃないみたい。どうすれば？
                  // transform: Matrix4.identity()
                  //   ..scale(scaleFactor, scaleFactor),
                  width: _monsterSize,
                  height: _monsterSize,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('images/shoggoth.png'),
                      Text(
                        todoList[1].taskNameOfTodoClass,
                        // style: TextStyle(
                        //     fontSize:
                        //         _fontSize
                        //         ), //TODO:テキストサイズを、monsterSizeと対応させたいフォントサイズをDOUBLEとかにする方法？
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "hero2",
        child: const Icon(Icons.egg_alt),
        onPressed: () {
          Navigator.push<void>(context,
              MaterialPageRoute(builder: (context) => const TaskCard()));
        },
      ),
    );
  }
}
