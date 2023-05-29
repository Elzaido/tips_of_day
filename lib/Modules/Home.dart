// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, deprecated_member_use, avoid_print, await_only_futures

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tips_of_day/Modules/photo.dart';
import '../shared/HomeCubit/cubit.dart';
import '../shared/HomeCubit/state.dart';
import '../shared/component.dart';
import 'video.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {
        if (state is CoppySuccessState) {
          defaultToast(
              massage: 'Quote copied to clipboard', state: ToastStates.SUCCESS);
        } else if (state is CoppyErrorState) {
          defaultToast(massage: 'There is an error', state: ToastStates.ERROR);
        }
      },
      builder: (context, state) {
        var naseha = HomeCubit.get(context).advice['advice'];
        return Scaffold(
          backgroundColor: Color.fromARGB(255, 226, 238, 255),
          appBar: defaultAppBar(
            context: context,
            title: 'Quote Of The Day',
            isHome: true,
          ),
          body: Stack(children: [
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  welcomeMessege(),
                  Stack(alignment: Alignment.center, children: [
                    Padding(
                        padding: const EdgeInsets.all(17.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: SvgPicture.asset(
                            'assets/citation.svg',
                            fit: BoxFit.cover,
                            height: 250,
                          ),
                        )),
                    Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 70),
                        child: state is LoadingNsehaState
                            ? Text(
                                'Loading ...',
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(221, 30, 30, 30)),
                                textAlign: TextAlign.center,
                              )
                            : SelectableText(
                                '${naseha}',
                                toolbarOptions: ToolbarOptions(
                                  copy: true,
                                  selectAll: true,
                                ),
                                style: TextStyle(
                                    fontSize: 17,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(221, 30, 30, 30)),
                                textAlign: TextAlign.center,
                              )),
                  ]),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(150, 50),
                              backgroundColor: Color.fromARGB(198, 60, 60, 60),
                              foregroundColor: Colors.white),
                          onPressed: () {
                            HomeCubit.get(context).copyText(text: '${naseha}');
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.copy),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'Copy',
                                style: TextStyle(
                                    fontFamily: 'Cairo',
                                    color: Colors.white,
                                    fontSize: 17),
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            fixedSize: Size(150, 50),
                            backgroundColor: Colors.amber,
                          ),
                          onPressed: () {
                            HomeCubit.get(context).increaseCounter();
                            if (HomeCubit.get(context).counter == 3) {
                              HomeCubit.get(context).showInterStatialAd();
                            }
                            HomeCubit.get(context).getNaseha();
                          },
                          child: Text(
                            'Another Quote!',
                            style: TextStyle(
                                fontFamily: 'Cairo',
                                color: Colors.white,
                                fontSize: 17),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      height: 1,
                      color: Colors.grey,
                    ),
                  ),
                  defualButton(
                      text: 'Video Quotes',
                      context: context,
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => video()));
                      }),
                  defualButton(
                    text: 'Photo Quotes',
                    context: context,
                    isAd: true,
                    onTap: () {
                      HomeCubit.get(context).isAdShowen == false &&
                              !HomeCubit.get(context).failRewardLoad
                          ? showDialog(
                              context: context,
                              builder: (context1) {
                                return AlertDialog(
                                  title: Text('Show Ad'),
                                  content: Text(
                                      'You need to show an Ad to view the content'),
                                  actions: <Widget>[
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context1, true);
                                        },
                                        child: Text('Close')),
                                    TextButton(
                                      onPressed: () async {
                                        HomeCubit.get(context)
                                            .showRewardAd(context: context);
                                        Navigator.pop(context1, true);
                                      },
                                      child: Text('Show Ad'),
                                    ),
                                  ],
                                );
                              })
                          : Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Photo()));
                    },
                  ),
                  SizedBox(
                    height: 80,
                  )
                ],
              ),
            ),
          ]),
        );
      },
    );
  }
}
