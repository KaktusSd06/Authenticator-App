import 'package:authenticator_app/generated/l10n.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as Colors;


class SignInScreen extends StatefulWidget{
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.mainBlue,
        ),
        backgroundColor: Colors.gray1,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: SvgPicture.asset(
            'assets/icons/arow_back.svg',
            width: 6,
            height: 12,
            fit: BoxFit.contain,
          ),
        ),
        title: Text(
            AppLocalizations.of(context)!.signin,
            style: Theme.of(context).textTheme.displaySmall!.copyWith(
              color: Color(0xFF171818)
            )
          ),
        centerTitle: true,
      ),
    );
  }
  
}