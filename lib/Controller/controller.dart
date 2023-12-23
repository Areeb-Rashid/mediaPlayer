import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';


class Controller extends GetxController{
   final audioQuery = OnAudioQuery();
   final audioPlayer = AudioPlayer();

   var playIndex = 0.obs;
   var isPlaying = false.obs;

   var duration = ''.obs;
   var position = ''.obs;

   var max = 0.0.obs;
   var value = 0.0.obs;

   changeDurationtoSec (seconds){
     var duration = Duration(seconds: seconds);
     audioPlayer.seek(duration);
   }

   updatePosition(){
     audioPlayer.durationStream.listen((d) {
       duration.value = d.toString().split('.')[0];
       max.value = d!.inSeconds.toDouble();
     });

     audioPlayer.positionStream.listen((p) {
       position.value = p.toString().split('.')[0];
       value.value = p.inSeconds.toDouble();
     });
   }



   @override
  void onInit() {
    super.onInit();
    checkPermission();
  }

   playSong(String? uri, index) {
     playIndex.value = index;
     try {
       audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(uri!)));
       audioPlayer.play();
       isPlaying(true);
       updatePosition();
     } catch (e) {
       print('Error playing song: $e');
     }
   }

   checkPermission() async {
      var per = await Permission.storage.request();
      if (per.isGranted){

      }
      else {
        checkPermission();
       print('This is the error');

      }
  }

   @override
   void onClose() {
     audioPlayer.dispose();
     super.onClose();
   }


}

