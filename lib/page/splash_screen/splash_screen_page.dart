import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/auth/auth_cubit.dart';
import '../../constant/assets.gen.dart';
import '../home/home_page.dart';
import '../intro/intro_page.dart';

class SplashScreenPage extends StatelessWidget {
  static const routeName = '/splash_screen';

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: Key(SplashScreenPage.routeName),
        body: BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            state.when(
              initial: () {},
              authenticated: () => Navigator.of(context)
                  .pushReplacementNamed(HomePage.routeName),
              unauthenticated: () => Navigator.of(context)
                  .pushReplacementNamed(IntroPage.routeName),
            );
          },
          child: Assets.images.splash.image(
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
