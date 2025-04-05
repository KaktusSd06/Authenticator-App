import 'package:authenticator_app/generated/l10n.dart';
import 'package:authenticator_app/presentation/screens/home_screen.dart';
import 'package:authenticator_app/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../../core/config/theme.dart' as Colors;
import '../dialogs/error_dialog.dart';


class SignInScreen extends StatefulWidget{
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isAgree = false;
  bool showErrorMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: Colors.mainBlue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 6,
            height: 12,
            colorFilter: ColorFilter.mode(Colors.mainBlue, BlendMode.srcIn),
          ),
        ),
        backgroundColor: Colors.gray1,
        title: Text(
          AppLocalizations.of(context)!.signin,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Color(0xFF171818),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppLocalizations.of(context)!.wellcome,
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                color: Colors.mainBlue,
              ),
            ),
            SizedBox(height: 60),

            SizedBox(
              height: 54,
              child: SignInButton(
                buttonType: ButtonType.google,
                onPressed: () async {

                  if (isAgree) {
                    UserCredential? userCredential = await AuthService().signInWithGoogle();

                    if (userCredential != null) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    } else {
                      ErrorDialog().showErrorDialog(
                        context,
                        AppLocalizations.of(context)!.error_with_signIn,
                        AppLocalizations.of(context)!.error_signIn_message,
                      );
                    }
                  } else {
                    setState(() {
                      showErrorMessage = true;
                    });
                  }
                },
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: SignInButton(
                buttonType: ButtonType.appleDark,
                onPressed: () {
                  if (isAgree) {
                    //AuthService().signInWithGoogle();
                  } else {
                    setState(() {
                      showErrorMessage = true;
                    });
                  }
                },
              ),
            ),

            SizedBox(height: 20),

            if(!showErrorMessage) SizedBox(height: 170,)
            else SizedBox(height: 80,),
            Visibility(
              visible: showErrorMessage,
              child: Container(
                height: 50,
                padding: EdgeInsets.only(left: 16),
                decoration: BoxDecoration(
                  color: Colors.gray2.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        AppLocalizations.of(context)!.term_error,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.gray2),
                      onPressed: () {
                        setState(() {
                          showErrorMessage = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),

            if(showErrorMessage) SizedBox(height: 40,),

            SizedBox(height: 10),

            Row(
              children: [
                Checkbox(
                  value: isAgree,
                  onChanged: (value) {
                    setState(() {
                      isAgree = !isAgree;
                      if (isAgree) showErrorMessage = false;
                    });
                  },
                  activeColor: Colors.mainBlue,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: AppLocalizations.of(context)!.terms_of_app),
                        TextSpan(text: ' '),
                        TextSpan(
                          text: AppLocalizations.of(context)!.terms_of_service,
                          style: TextStyle(color: Colors.blue),
                        ),
                        TextSpan(text: ' ${AppLocalizations.of(context)!.and} '),
                        TextSpan(
                          text: AppLocalizations.of(context)!.privacy_policy,
                          style: TextStyle(color: Colors.blue),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
