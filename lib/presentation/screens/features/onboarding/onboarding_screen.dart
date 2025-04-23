import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/continue_button.dart';
import '../paywall/paywall_screen.dart';
import 'bloc/onboarding_bloc.dart';
import 'bloc/onboarding_event.dart';
import 'bloc/onboarding_state.dart';
import 'onboarding_screen_last.dart';
import 'onboarding_screen_template.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

//FIXME що таке 3? Чому саме три? Давай винесемо це в константу. Це дасть нам більше контексту
//DONE Виніс у змінну в bloc число сторінок та взаємодію між станами онбординку
//DONE Створив template для однотипної частини онбордину, виділив окрему сторінку з Політикою користування

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _controller = PageController();

  @override
  void initState() {
    super.initState();

    context.read<OnboardingBloc>().add(OnboardingStarted());

    _controller.addListener(() {
      final page = _controller.page?.round() ?? 0;
      context.read<OnboardingBloc>().add(OnboardingPageChanged(page));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen: (prev, curr) => curr.navigateToPaywall,
      listener: (context, state) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PaywallScreen(isFirstAppLaunch: true,)),
        );

        context.read<OnboardingBloc>().add(OnboardingPageChanged(state.currentPage));
      },
      child: BlocBuilder<OnboardingBloc, OnboardingState>(
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                PageView(
                  controller: _controller,
                  children: [
                    OnboardingScreenTemplate(
                      imagePath: "assets/images/onboarding_bg_1.png",
                      mainText: AppLocalizations.of(context)!.onBoarding_H1,
                      smallText: AppLocalizations.of(context)!.onBoarding_T1,
                    ),
                    OnboardingScreenTemplate(
                      imagePath: "assets/images/onboarding_bg_2.png",
                      mainText: AppLocalizations.of(context)!.onBoarding_H2,
                      smallText: AppLocalizations.of(context)!.onBoarding_T2,
                    ),
                    OnboardingScreenTemplate(
                      imagePath: "assets/images/onboarding_bg_3.png",
                      mainText: AppLocalizations.of(context)!.onBoarding_H3,
                      smallText: AppLocalizations.of(context)!.onBoarding_T3,
                    ),
                    OnBoardingScreenLast(
                      onClosePressed: () {
                        _controller.animateToPage(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                        context.read<OnboardingBloc>().add(OnboardingPageChanged(0));
                      },
                      onRestorePressed: () {
                        _controller.animateToPage(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );

                        context.read<OnboardingBloc>().add(OnboardingPageChanged(0));
                      },
                    )

                  ],
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(43.56),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: state.progress,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.lightBlue,
                                  borderRadius: BorderRadius.circular(43.56),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 65, right: 16, left: 16),
                          child: SizedBox(
                            width: double.infinity,
                            child: ContinueButton(
                              onPressed: () {
                                final nextPage = context.read<OnboardingBloc>().state.currentPage + 1;
                                if (nextPage < OnboardingBloc.totalPages) {
                                  _controller.animateToPage(
                                    nextPage,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                  );
                                }

                                context.read<OnboardingBloc>().add(OnboardingNextPressed());
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
