import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info/package_info.dart';

import '../../core/bloc/bloc.dart';
import '../ui.dart';
import 'widgets/profile_item.dart';
import 'widgets/setting_item.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({
    Key key,
  }) : super(key: key);

  static const routeName = '/setting';

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  PackageInfo packageInfo;

  String get appVersion {
    if (packageInfo != null) {
      return '${packageInfo.version}.${packageInfo.buildNumber}';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: fetchProfile,
        child: CustomScrollView(
          physics:
              AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                ProfileItem(),
                SizedBox(height: 20.h),
                SettingItem(
                  icon: Icons.category_outlined,
                  title: 'Request Category',
                  onTap: () {},
                ),
                SettingItem(
                  icon: Icons.chrome_reader_mode_outlined,
                  title: 'Credit',
                  onTap: () {},
                ),
                SettingItem(
                  icon: Icons.lock_outline,
                  title: 'Change Password',
                  onTap: () {},
                ),
                SettingItem(
                  icon: Icons.code_outlined,
                  title: appVersion,
                  onTap: null,
                ),
                SettingItem(
                  icon: Icons.logout,
                  title: 'Sign out',
                  onTap: () {
                    context.read<AuthCubit>().loggedOut();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginPage.routeName,
                      (_) => false,
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
    getAppVersion();
  }

  Future<void> getAppVersion() async {
    packageInfo = await PackageInfo.fromPlatform();
    setState(() {});
  }

  Future<void> fetchProfile() async {
    await context.read<ProfileCubit>().fetch();
  }
}
