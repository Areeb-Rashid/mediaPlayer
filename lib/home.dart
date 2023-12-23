import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:mediaplayer/player.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'Controller/controller.dart';


class Home extends StatelessWidget {
  const Home({super.key});


  @override
  Widget build(BuildContext context) {

    var controller = Get.put(Controller());


    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Home',style: TextStyle(color: Colors.white)),
        centerTitle: true,
        leading: const Icon(Icons.sort_rounded,color: Colors.white),
        actions: [
          IconButton(onPressed: (){

          }, icon: const Icon(Icons.search,color: Colors.white,))
        ],
      ),
      body: FutureBuilder<List<SongModel>>(
        future: controller.audioQuery.querySongs(
            ignoreCase: true,
            orderType: OrderType.ASC_OR_SMALLER,
            sortType: null,
             uriType: UriType.EXTERNAL
        ),
          builder: (BuildContext context , AsyncSnapshot snapshot){
          if (snapshot.data == null){

            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.data!.isEmpty){

            return const Center(child: Text('No songs found',style: TextStyle(color: Colors.white),));
          }
          else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, index){
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),

                      ),
                      child:  ListTile(
                          title: Text(snapshot.data![index].displayNameWOExt ,
                              style: const TextStyle(color: Colors.white)) ,

                          subtitle:
                          Text('${snapshot.data![index].artist}',
                              style: const TextStyle(color: Colors.white)) ,

                          leading: QueryArtworkWidget(id: snapshot.data![index].id, type: ArtworkType.AUDIO,
                          nullArtworkWidget: const Icon(Icons.music_note , color: Colors.white,)) ,

                          trailing: controller.playIndex.value == index && controller.isPlaying.value
                              ? const Icon(Icons.play_arrow,color: Colors.white) : null,
                          onTap: () async{
                            await Get.to(Player(data: snapshot.data));
                          controller.playSong(snapshot.data![index].uri, index);
                          },
                        ),

                    );
                  }),
            );
          }
          })
    );
  }
}
