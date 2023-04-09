import 'package:audioplayers/audioplayers.dart';
import 'package:counter/task_list/thank_list.dart';
import 'package:counter/ui/bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../task_edit/create_task.dart';
import 'task_model.dart';

class TaskMonster extends StatefulWidget {
  const TaskMonster({required Key key}) : super(key: key);

  @override
  State<TaskMonster> createState() => _TaskMonsterState();
}


class _TaskMonsterState extends State<TaskMonster> {
  double _monsterSize = 150;
  int _tapCount = 0;
  late AudioPlayer? _audioPlayer;
  bool taskComplete = false;

  void _updateImageSize() {
    setState(() {
      _tapCount++;
      if (_tapCount == 3) {
        _monsterSize = 0.0;
        taskComplete = true;
        debugPrint(taskComplete.toString());
      } else {
        _monsterSize /= 1.5;
      }
    });
  }

  Future<void> _playSound() async {
    _audioPlayer = AudioPlayer();
    await _audioPlayer!.setSource(AssetSource('sword.mp3'));
  }

  void _handleTap() async {
    await _playSound();
    _updateImageSize();
  }

  @override
  void initState() {
    super.initState();
    final model = Provider.of<TaskModel>(context, listen: false);
    model.getTodoListRealtime();
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer?.dispose();
    final model = Provider.of<TaskModel>(context, listen: false);
    model.disposeRealtimeListeners();
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
          ),
        ],
      ),
      body: Consumer<TaskModel>(
        builder: (context, model, child) {
          final todoListForTaskMonster = model.todoListFromModelOverDue;

          return model.isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GestureDetector(
                      onTap: _handleTap,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        alignment: Alignment.center,
                        // transform: Matrix4.identity()
                        //   ..scale(scaleFactor, scaleFactor),
                        width: _monsterSize,
                        height: _monsterSize * 2,
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(child: Image.asset('images/shoggoth.png')),
                            Expanded(
                              child: Text(
                                todoListForTaskMonster.isEmpty
                                    ? "task"
                                    : todoListForTaskMonster[0]
                                        .taskNameOfTodoClass,
                                style: TextStyle(fontSize: _monsterSize / 10),
                              ),
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
