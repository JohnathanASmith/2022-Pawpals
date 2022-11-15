import 'package:flutter/material.dart';
import '../../models/post_model.dart';

class DetailedPost extends StatelessWidget{
  final PostModel? post;

  const DetailedPost({super.key, required this.post});


  @override
  Widget build(BuildContext context) {

    if(post?.isPetFriendly == null){


    }


    return Scaffold(

        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.white
          ),
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.width,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(post!.petPhotoUrl!)
                        )
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      Container(
                        margin: const EdgeInsets.only(left:15),
                        child: Text('${post?.petName}',
                          style: const TextStyle(fontFamily: "Proxima-Nova-Bold",
                            fontSize: 30, color: Colors.black, fontWeight: FontWeight.w400
                          ),),

                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: Text('${post?.petAge}, ${post?.petGender?.name}, Wilmington',
                      style: const TextStyle(fontFamily: "Proxima-Nova-Bold",
                        fontSize: 25, color: Colors.black, fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                  const SizedBox( // About me
                    height: 15,
                  ),

                  Container(
                    margin: const EdgeInsets.only(left:15),
                    child: const Text("About Me", style: TextStyle(fontFamily: "Proxima-Nova-Bold",
                        fontSize: 20, color: Colors.black, fontWeight: FontWeight.w400
                    ),),

                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  Container(
                    margin: const EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width*0.85,
                    child: Text('${post?.postDescription}', style: const TextStyle(fontFamily: "ProximaNova-Regular",
                        fontSize: 15, color: Colors.black, fontWeight: FontWeight.w300
                    ),),
                  ),

                  const SizedBox( // labels
                    height: 30,
                  ),

                  Container(
                    width: MediaQuery.of(context).size.width*0.9,
                    margin: const EdgeInsets.only(left:10),
                    child: Wrap(

                      children: [

                        Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xFF00C853).withOpacity(0.25)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6 ),
                              child:LayoutBuilder(builder: (context, constraints) {
                                if(post?.isPetFriendly == true){
                                  return const Text('Pet Friendly',
                                    style: TextStyle(fontFamily: "ProximaNova-Regular",
                                        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400
                                    ),);
                                }else{
                                  return Container(
                                      height: 30,
                                      decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      color: const Color(0xFFFF3D00).withOpacity(0.25)),
                                      child: const Text('Not Pet Friendly',
                                    style: TextStyle(fontFamily: "ProximaNova-Regular",
                                        fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400
                                    ),));
                                }
                              })
                            )
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                            height: 30,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0),
                                color: const Color(0xFFFF9933).withOpacity(0.25)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8, right: 8, top: 6, bottom: 6),
                                child:LayoutBuilder(builder: (context, constraints) {
                                  if(post?.isKidFriendly == true){
                                    return const Text('Kid Friendly',
                                      style: TextStyle(fontFamily: "ProximaNova-Regular",
                                          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400
                                      ),);
                                  }else{
                                    return Container(
                                        height: 30,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15.0),
                                            color: const Color(0xFF00C853).withOpacity(0.25)
                                        ),child: const Text('Not Kid Friendly',
                                      style: TextStyle(fontFamily: "ProximaNova-Regular",
                                          fontSize: 14, color: Colors.black, fontWeight: FontWeight.w400
                                      ),));
                                  }
                                })
                            )
                        ),
                      ],

                    ),
                  ),

                ],

              ),


            ],

          ),
        )

    );

  }



}