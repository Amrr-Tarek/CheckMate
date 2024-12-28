import 'package:flutter/material.dart';
import 'package:checkmate/models/navigator.dart';

AppBar appBar(BuildContext context, final String title,
    {bool showIcon = false}) {
  return AppBar(
    shadowColor: Theme.of(context).primaryColor,
    elevation: 6,
    backgroundColor: Theme.of(context).secondaryHeaderColor,
    title: Text(title,
        style: const TextStyle(
          color: Color(0xFF1D1B20),
          fontSize: 22,
          fontWeight: FontWeight.bold,
        )),
    centerTitle: true,
    actions: [
      // Profile Icon
      showIcon
          ? InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () {
                navigate(context, '/myprofile');
              },
              child: Container(
                margin: EdgeInsets.all(5),
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(1.5),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 77, 48, 243),
                        width: 2),
                    shape: BoxShape.circle,
                  ),
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage('assets/app_icon.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Container(),
    ],
  );
}
