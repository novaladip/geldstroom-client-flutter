import 'package:flutter/material.dart';
import 'package:geldstroom/widgets/setting_item.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          _buildSettingsTitle(height, width),
          _buildMenu(height, width)
        ],
      ),
    );
  }

  Positioned _buildMenu(double height, double width) {
    return Positioned(
      top: height * 0.15,
      left: 30.0,
      right: 30.0,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Container(
          height: height * 0.7,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: _buildMenuItem(),
        ),
      ),
    );
  }

  Padding _buildMenuItem() {
    return Padding(
      padding: const EdgeInsets.only(top: 50, right: 25, left: 25),
      child: Column(
        children: <Widget>[
          SettingItem(
            imageAssets: 'assets/images/settings/logout.png',
            title: 'Sign out',
            onTap: () {},
          ),
          SettingItem(
            imageAssets: 'assets/images/settings/rating.png',
            title: 'Give us rate!',
            onTap: () {},
          ),
          SettingItem(
            imageAssets: 'assets/images/settings/version.png',
            title: 'Version 0.0.1',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTitle(double height, double width) {
    return Positioned(
      top: 0,
      child: Container(
        padding: EdgeInsets.only(top: 40, left: 15),
        color: Colors.deepOrange,
        height: height * 0.3,
        width: width,
        child: Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
      ),
    );
  }
}
