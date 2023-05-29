// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../ads/banner_ad.dart';
import 'HomeCubit/cubit.dart';

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  required String title,
  bool isHome = false,
}) {
  return AppBar(
    backgroundColor: Color.fromARGB(180, 0, 0, 0),
    title: isHome
        ? Center(
            child: Text(
              title,
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold),
            ),
          )
        : Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.bold),
          ),
    leading: !isHome
        ? IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        : null,
  );
}

Widget defualButton({
  required String text,
  bool isAd = false,
  required context,
  required void Function()? onTap,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 45),
    child: InkWell(
      onTap: onTap,
      child: Stack(children: [
        Container(
          height: 60,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color.fromARGB(197, 37, 37, 37),
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 25,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.white, fontSize: 15),
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
              ),
              SizedBox(
                width: 25,
              )
            ],
          ),
        ),
        if (isAd &&
            !HomeCubit.get(context).isAdShowen &&
            !HomeCubit.get(context).failRewardLoad)
          Align(
            alignment: Alignment.topRight,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(5)),
              height: 20,
              width: 20,
              child: Center(
                child: Text(
                  'Ad',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          )
      ]),
    ),
  );
}

Widget modulesImage({
  required String Image,
}) {
  return Container(
    height: 220,
    width: double.infinity,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15),
          bottomRight: Radius.circular(15),
        ),
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(Image))),
  );
}

Widget defualtDownloadButton(context, String Photo) => ElevatedButton(
    style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, fixedSize: Size(250, 50)),
    onPressed: () {
      navigateToUrl(Photo);
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.download),
        SizedBox(
          width: 10,
        ),
        Text('Download'),
      ],
    ));

void defaultToast({
  required String massage,
  required ToastStates state,
}) =>
    Fluttertoast.showToast(
        msg: massage,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 5,
        backgroundColor: choseToastColor(state),
        textColor: Colors.white,
        fontSize: 16.0);

// states of the Toast
enum ToastStates { SUCCESS, ERROR, WARNING }

Color choseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Color.fromARGB(255, 117, 189, 171);
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }

  return color;
}

Widget defualtElevatedButton(
    String text, Icon icon, void Function()? onPressed, Color color) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              text,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
          ],
        ),
        onPressed: onPressed,
      ),
    ),
  );
}

Widget welcomeMessege() => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Always, You will find us here to help',
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          width: 5,
        ),
        Icon(
          Icons.favorite_outline,
          size: 25,
        )
      ],
    ));

Widget bannerAdUnit() => Align(
    alignment: Alignment.bottomCenter,
    child: Container(
      height: 65,
      width: double.infinity,
      color: Colors.white,
      child: AdBanner(),
    ));

void navigateToUrl(String url) async {
  var urllaunchable = await canLaunch(url);
  if (urllaunchable) {
    await launch(url);
  } else {
    print("URL can't be launched.");
  }
}
