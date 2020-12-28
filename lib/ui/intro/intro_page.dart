import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:styled_widget/styled_widget.dart';

import '../../gen/assets.gen.dart';
import '../../shared/shared.dart';
import '../login/login_page.dart';

class IntroPage extends StatelessWidget {
  static const routeName = '/intro';

  Widget actionButton(BuildContext context, String title) => Text(title)
      .textColor(AppStyles.primaryColor)
      .fontSize(28.ssp)
      .fontFamily(AppStyles.fontFamilyTitle);

  Widget image(String asset) => SvgPicture.asset(asset, fit: BoxFit.fitWidth);

  @override
  Widget build(BuildContext context) {
    final pageDecoration = PageDecoration(
      titleTextStyle: TextStyle(
        fontSize: 38.ssp,
        fontFamily: AppStyles.fontFamilyTitle,
        fontWeight: FontWeight.bold,
      ),
      bodyTextStyle: TextStyle(
        fontSize: 32.ssp,
        fontFamily: AppStyles.fontFamilyBody,
      ),
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: Key(IntroPage.routeName),
        body: IntroductionScreen(
          curve: Curves.easeInOut,
          showNextButton: true,
          showSkipButton: true,
          skip: actionButton(context, kSkipButtonText),
          done: actionButton(context, kDoneButtonText),
          next: actionButton(context, kNextButtonText),
          dotsDecorator: DotsDecorator(
            activeColor: AppStyles.primaryColor,
            activeSize: const Size(20.0, 10.0),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(2),
                right: Radius.circular(2),
              ),
            ),
          ),
          onDone: () =>
              Navigator.of(context).pushReplacementNamed(LoginPage.routeName),
          pages: kIntroContents
              .map(
                (content) => PageViewModel(
                  title: content.title,
                  body: content.body,
                  decoration: pageDecoration,
                  image: image(content.image),
                ),
              )
              .toList(),
        ).padding(
          top: 0.15.sh,
        ),
      ),
    );
  }
}

class IntroContent {
  const IntroContent({
    @required this.title,
    @required this.body,
    @required this.image,
  });

  final String title;
  final String body;
  final String image;
}

const kNextButtonText = 'Next';
const kSkipButtonText = 'Skip';
const kDoneButtonText = 'Let\'s Go!';
final kIntroContents = <IntroContent>[
  IntroContent(
    title: 'Welcome to Geldstroom',
    body: 'Start managing your money with us!',
    image: Assets.images.welcoming.path,
  ),
  IntroContent(
    title: 'Data Visualization',
    body: 'To help you make better decision',
    image: Assets.images.visualData.path,
  ),
  IntroContent(
    title: 'Cloud Base',
    body: 'Sync on any devices',
    image: Assets.images.serverStatus.path,
  ),
  IntroContent(
    title: 'Forever Free',
    body: 'No ads & limited features',
    image: Assets.images.beer.path,
  ),
];
