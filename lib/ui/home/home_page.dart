import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../../core/bloc_ui/ui_bloc.dart';
import '../../shared/common/config/config.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home';
  static const homeIconKey = Key('home_page_home');
  static const settingIconKey = Key('home_page_setting');

  const HomePage({
    Key key,
    @required this.children,
    @required this.oneSignal,
  }) : super(key: key);

  final List<Widget> children;
  final OneSignal oneSignal;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setupOneSignal();
  }

  void setupOneSignal() {
    widget.oneSignal.setSubscription(true);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<BottomNavigationCubit, int>(
      (cubit) => cubit.state.selectedIndex,
    );

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: widget.children,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppStyles.darkBackground,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        currentIndex:
            context.watch<BottomNavigationCubit>().state.selectedIndex,
        onTap: (value) {
          context.read<BottomNavigationCubit>().changeSelectedIndex(value);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, key: HomePage.homeIconKey),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, key: HomePage.settingIconKey),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
