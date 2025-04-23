import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/presentation/screens/privacy_policy_screen.dart';
import 'package:authenticator_app/presentation/screens/terms_of_use_screen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../../../../core/config/theme.dart' as app_colors;
import '../../../dialogs/error_dialog.dart';
import 'bloc/sign_in_bloc.dart';
import 'bloc/sign_in_event.dart';
import 'bloc/sign_in_state.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignInBloc(),
      child: _SignInScreenContent(),
    );
  }
}

class _SignInScreenContent extends StatefulWidget {
  @override
  __SignInScreenContentState createState() => __SignInScreenContentState();
}

class __SignInScreenContentState extends State<_SignInScreenContent> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : Colors.blue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 6,
            height: 12,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
        backgroundColor:
        Theme.of(context).brightness == Brightness.light ? app_colors.gray1 : app_colors.black,
        title: Text(
          AppLocalizations.of(context)!.signin,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color:
            Theme.of(context).brightness == Brightness.light ? const Color(0xFF171818) : app_colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is SignInSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          } else if (state is SignInFailure) {
            ErrorDialog().showErrorDialog(
              context,
              AppLocalizations.of(context)!.error_with_signIn,
              state.errorMessage ?? AppLocalizations.of(context)!.error_signIn_message,
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 70),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  AppLocalizations.of(context)!.wellcome,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                    color:
                    Theme.of(context).brightness == Brightness.light
                        ? app_colors.mainBlue
                        : app_colors.blue,
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: 54,
                  child: SignInButton(
                    buttonType: ButtonType.google,
                    onPressed: isAgree
                        ? () {
                      context.read<SignInBloc>().add(SignInWithGoogle(context: context));
                    }
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 170),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: isAgree,
                      onChanged: (value) {
                        setState(() {
                          isAgree = value!;
                        });
                      },
                      activeColor: app_colors.mainBlue,
                      checkColor: app_colors.white,
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                          children: [
                            TextSpan(text: '${AppLocalizations.of(context)!.terms_of_app} '),
                            TextSpan(
                              text: AppLocalizations.of(context)!.terms_of_service,
                              style: const TextStyle(color: app_colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const TermsOfUseScreen()),
                                  );
                                },
                            ),
                            TextSpan(
                              text: AppLocalizations.of(context)!.privacy_policy,
                              style: const TextStyle(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                                  );
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}