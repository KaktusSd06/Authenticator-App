import 'package:authenticator_app/presentation/screens/features/paywall/paywall_plan.dart';
import 'package:authenticator_app/presentation/screens/features/paywall/plan_option.dart';
import 'package:authenticator_app/presentation/screens/features/paywall/trial_switch.dart';
import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/presentation/screens/privacy_policy_screen.dart';
import 'package:authenticator_app/presentation/screens/terms_of_use_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/config/theme.dart' as app_colors;
import '../../../widgets/continue_button.dart';
import '../onboarding/onboarding_screen.dart';
import 'bloc/paywall_bloc.dart';
import 'bloc/paywall_event.dart';
import 'bloc/paywall_state.dart';

//FIXME дуже багато всього в одній функції, дуже важко читається. Розділяй на кілька функцій окремо для кожного віджету.
//FIXME Наприклад, віджет Title де буде тайтл з описом. Далі віджет для обирання плану з світчом і двома радіобаттонами. Радіобаттон можна винести окремо і перевикористати для річного і тижневого плану
//DONE Розділив на окремі віджети

//FIXME колір тайтлу на радіобаттон змінюється для обраної опції https://www.figma.com/design/PKNsmhhhbS74HWZZFZTgvn/Authenticator-app?node-id=395-2377&t=wcRy3wRnN0oaANRR-4 https://www.figma.com/design/PKNsmhhhbS74HWZZFZTgvn/Authenticator-app?node-id=395-2545&t=wcRy3wRnN0oaANRR-4
//DONE Виправив стилізацію віджетів, а також заборонив вибірку лише пробного періоду

//FIXME давай робити кнопку неактивною, якщо ніякий план не вибраний
//DONE Неактивна кнопка до вибору одного з планів

//FIXME клік повинен відбуватися по всьому блоку і тоді повинен змінюватись стан свіча/радіобаттон
//DONE Клік по всіх віджетах
//DONE Виправив неймінг, а також виділив енам для взаємодії з планами
//DONE Відділив бізнес логіку від UI

class PaywallScreen extends StatelessWidget {
  final bool isFirstAppLaunch;

  const PaywallScreen({super.key, this.isFirstAppLaunch = false});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaywallBloc(),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/paywall_bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: _PaywallContent(isFirst: isFirstAppLaunch),
        ),
      ),
    );
  }
}

class _PaywallContent extends StatelessWidget {
  final bool isFirst;

  const _PaywallContent({required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header with X button and Restore
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 60, left: 23, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    if(isFirst){
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                    }
                    else {
                      Navigator.pop(context);
                    }
                  },
                  child: SvgPicture.asset(
                    "assets/icons/x.svg",
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(app_colors.mainBlue, BlendMode.srcIn),
                  ),
                ),
                if(isFirst)
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => OnBoardingScreen()));
                    },
                    child: Text(
                      AppLocalizations.of(context)!.restor_l,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: app_colors.mainBlue,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),

        const Spacer(),

        // Main Content
        Padding(
          padding: const EdgeInsets.only(bottom: 28, right: 16, left: 16),
          child: _PaywallMainContent(isFirst: isFirst),
        ),
      ],
    );
  }
}

class _PaywallMainContent extends StatelessWidget {
  final bool isFirst;

  const _PaywallMainContent({required this.isFirst});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Title and description
        Text(
          AppLocalizations.of(context)!.paywell_H1,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          AppLocalizations.of(context)!.paywell_T1,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: app_colors.gray2,
          ),
        ),
        const SizedBox(height: 24),

        // Plan options
        BlocBuilder<PaywallBloc, PaywallState>(
            builder: (context, state) {
              return Column(
                children: [
                  // Trial switch
                  TrialSwitchBlock(
                    isTrialEnabled: state.isTrialEnabled,
                    onChanged: (val) => context.read<PaywallBloc>().add(ToggleTrialEvent(val)),
                  ),

                  const SizedBox(height: 12),

                  // Yearly plan
                  PlanOption(
                    title: AppLocalizations.of(context)!.year,
                    subtitle: AppLocalizations.of(context)!.uSD_Only,
                    selected: state.selectedPlan == PaywallPlan.yearly,
                    onTap: () {
                      context.read<PaywallBloc>().add(SelectPlanEvent(PaywallPlan.yearly));
                    },
                    badgeText: AppLocalizations.of(context)!.save_88,
                  ),

                  const SizedBox(height: 12),

                  // Weekly plan
                  PlanOption(
                    title: AppLocalizations.of(context)!.free_day,
                    subtitle: AppLocalizations.of(context)!.than_6,
                    selected: state.selectedPlan == PaywallPlan.weekly,
                    onTap: () {
                      context.read<PaywallBloc>().add(SelectPlanEvent(PaywallPlan.weekly));
                    },
                  ),

                  const SizedBox(height: 24),

                  // Continue button
                  SizedBox(
                    width: double.infinity,
                    child: ContinueButton(
                      onPressed: state.isContinueButtonEnabled
                          ? () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => HomeScreen()),
                        );
                      } : null,
                    ),
                  ),
                ],
              );
            }
        ),

        const SizedBox(height: 16),

        // Payment info
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/icons/paywall.png",
              width: 19,
              height: 19,
              color: const Color(0xFF00CF00),
              colorBlendMode: BlendMode.srcIn,
            ),
            const SizedBox(width: 4),
            Text(
              AppLocalizations.of(context)!.paywell_info,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: app_colors.gray2,
                decoration: TextDecoration.underline,
                decorationColor: app_colors.gray2,
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Terms and Privacy
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TermsOfUseScreen())
                );
              },
              child: Text(
                "Terms of Use",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: app_colors.gray2,
                  decoration: TextDecoration.underline,
                  decorationColor: app_colors.gray2,
                ),
              ),
            ),
            const SizedBox(width: 6),
            SvgPicture.asset(
              "assets/icons/ellipse.svg",
              width: 4,
              height: 4,
              colorFilter: ColorFilter.mode(app_colors.gray2, BlendMode.srcIn),
            ),
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyScreen())
                );
              },
              child: Text(
                "Privacy Policy",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: app_colors.gray2,
                  decoration: TextDecoration.underline,
                  decorationColor: app_colors.gray2,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}