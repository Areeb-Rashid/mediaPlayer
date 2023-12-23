import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Controller/controller.dart';

class Player extends StatelessWidget {

  final List<SongModel> data;
  const Player(
  {super.key,
    required this.data
}
      );

  @override
  Widget build(BuildContext context) {

    var controller = Get.find<Controller>();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Obx(
            ()=> Expanded(
                  child: Container(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle
                    ),
                alignment: Alignment.center,
                child: QueryArtworkWidget(id: data[controller.playIndex.value].id, type: ArtworkType.AUDIO,
                  artworkHeight: double.infinity,
                  artworkWidth: double.infinity,
                  nullArtworkWidget: const Icon(Icons.music_note),
                ),
              )),
            ),
            const SizedBox(height: 15),

            Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16)
                )
              ),
              child:  Obx(
                  ()=> Column(
                  children: [
                     Text(data[controller.playIndex.value].displayNameWOExt,
                         textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                         maxLines: 2,
                         style: const TextStyle(color: Colors.black)),
                    const SizedBox(height: 12),
                     Text(data[controller.playIndex.value].artist.toString(),
                         textAlign: TextAlign.center,
                         overflow: TextOverflow.ellipsis,
                         maxLines: 2,
                         style: const TextStyle(color: Colors.black)),
                    const SizedBox(height: 12),
                    Obx(
                      ()=> Row(
                        children: [
                           Text(controller.position.value,style: const TextStyle(color: Colors.black)),
                          Expanded(
                            child: Slider(
                                thumbColor: Colors.black,
                                activeColor: Colors.black,
                                inactiveColor: Colors.red,
                                min: const Duration(seconds: 0).inSeconds.toDouble(),
                                max: controller.max.value,
                                value: controller.value.value,
                                onChanged: (newValue){
                                  controller.changeDurationtoSec(newValue.toInt());
                                  newValue = newValue;
                            }),
                          ),
                           Text(controller.duration.value)
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(onPressed: (){
                            controller.playSong(data[controller.playIndex.value -1].uri, controller.playIndex.value-1);
                          }, icon: const Icon(Icons.skip_previous_rounded)),
                          const SizedBox(width: 20),
                          Obx(
                              ()=> CircleAvatar(
                                child: IconButton(onPressed: (){
                                  if (controller.isPlaying.value){
                                    controller.audioPlayer.pause();
                                    controller.isPlaying(false);
                                  }
                                  else{
                                    controller.audioPlayer.play();
                                    controller.isPlaying(true);
                                  }
                                }, icon:controller.isPlaying.value ?const Icon(Icons.pause) : const Icon(Icons.play_arrow_rounded))),
                          ),
                          const SizedBox(width: 20),
                          IconButton(onPressed: (){
                            controller.playSong(data[controller.playIndex.value+1].uri, controller.playIndex.value+1);
                          }, icon: const Icon(Icons.skip_next_rounded)),
                        ],
                    ),

                  ],
                ),

            )
            )
            ),
          ],
        ),
      ),
    );
  }
}
