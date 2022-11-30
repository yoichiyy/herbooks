// import 'package:sound_mode/sound_mode.dart';
// import 'package:vibration/vibration.dart';

// class UtilPlaySound {
//   void playSound(int toneTune, audioCache) async {
//     String ringerStatus = await SoundMode.ringerModeStatus;
//     print(ringerStatus);

//     if (ringerStatus.contains("Vibrate Mode") ||
//         ringerStatus.contains("Normal Mode")) {
//       Vibration.vibrate(
//         amplitude: 120,
//         duration: 200,
//       );
//     }
//     if (ringerStatus.contains("Normal Mode")) {
//       String tone = "";
//       switch (toneTune) {
//         case 1:
//           tone = 'tone1.mp3';
//           break;
//         case 2:
//           tone = 'tone2.mp3';
//           break;
//         case 3:
//           tone = 'tone3.mp3';
//           break;
//       }
//       audioCache.play(tone);
//     }
//   }
// }
