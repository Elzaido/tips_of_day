import 'package:flutter/material.dart';
import 'package:tips_of_day/shared/component.dart';
import '../Model/photo_list.dart';

class Photo extends StatelessWidget {
  const Photo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 226, 238, 255),
      appBar: defaultAppBar(context: context, title: 'Photo Quotes'),
      body: Stack(children: [
        SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              welcomeMessege(),
              GridView.count(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisCount: 1,
                mainAxisSpacing: 1,
                crossAxisSpacing: 2,
                // list.generation(Length, itemBuilder// anonemus function that return the item).
                children: photosList.map((Photo) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      elevation: 10,
                      child: Container(
                        color: Color.fromARGB(255, 244, 248, 255),
                        child: Column(
                          children: [
                            Expanded(
                              child: Image.network(
                                '${Photo.photo}',
                                fit: BoxFit.contain,
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(
                                    right: 15, left: 15, bottom: 15, top: 10),
                                child: defualtDownloadButton(
                                    context, '${Photo.link}'))
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 65,
              )
            ],
          ),
        ),
      ]),
    );
  }
}
