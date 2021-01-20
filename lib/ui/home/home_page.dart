import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/bloc_ui/ui_bloc.dart';
import '../../shared/common/config/config.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    Key key,
    @required this.children,
  }) : super(key: key);

  static const routeName = '/home';
  static const homeIconKey = Key('home_page_home');
  static const settingIconKey = Key('home_page_setting');
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final currentIndex = context.select<BottomNavigationCubit, int>(
      (cubit) => cubit.state.selectedIndex,
    );

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: children,
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
            icon: Icon(Icons.home_outlined, key: homeIconKey),
            label: 'Overview',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Report',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined, key: settingIconKey),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}
