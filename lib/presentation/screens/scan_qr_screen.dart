import 'package:authenticator_app/presentation/screens/about_app.dart';
import 'package:authenticator_app/presentation/screens/premium_features.dart';
import 'package:authenticator_app/presentation/screens/sign_in_screen.dart';
import 'package:authenticator_app/presentation/screens/subscription.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/settings_tile.dart';


class ScanQrScreen extends StatefulWidget{
  @override
  _ScanQrScreenSate createState() => _ScanQrScreenSate();
}

class _ScanQrScreenSate extends State<ScanQrScreen>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: AppColors.mainBlue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 6,
            height: 12,
            colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
          ),
        ),
        backgroundColor: AppColors.gray1,
        title: Text(
          AppLocalizations.of(context)!.scan_qr,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Color(0xFF171818),
          ),
        ),
        centerTitle: true,
      ),
    );
  }

}