import 'package:authenticator_app/generated/l10n.dart';
import 'package:authenticator_app/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sign_button/constants.dart';
import 'package:sign_button/create_button.dart';
import '../../../core/config/theme.dart' as Colors;


class SignInScreen extends StatefulWidget{
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{

  bool isAgree = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.mainBlue,
        ),
        backgroundColor: Colors.gray1,
        title: Text(
            AppLocalizations.of(context)!.signin,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Color(0xFF171818)
            )
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
                onPressed: () {
                  if(isAgree){
                    AuthService().signInWithGoogle();
                  }
                  else{

                  }
                }
              ),
            ),

            SizedBox(height: 24),

            SizedBox(
              height: 54,
              child: SignInButton(
                buttonType: ButtonType.appleDark,
                onPressed: () {
                  if(isAgree){
                    //AuthService().signInWithGoogle();
                  }
                  else{

                  }
                }
              ),
            ),

            SizedBox(height: 170),

            Row(
              children: [
                Checkbox(
                  value: isAgree,
                  onChanged: (value) => setState(() {
                    isAgree = !isAgree;
                  }),
                  activeColor: Colors.mainBlue,
                  checkColor: Colors.white,
                ),
                Expanded(
                  child: Text(
                    AppLocalizations.of(context)!.terms_of_app,
                    softWrap: true,
                  ),
                ),
              ],
            )
          ],
        ),
      )
    );
  }
  
}