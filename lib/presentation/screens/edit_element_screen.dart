import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../data/models/service.dart';
import '../dialogs/error_dialog.dart';
import 'package:path_provider/path_provider.dart';

import 'add_manually_screen.dart';

class EditTokenScreen extends StatefulWidget {
  final AuthToken token;

  EditTokenScreen({Key? key, required this.token}) : super(key: key);

  @override
  _EditTokenScreenState createState() => _EditTokenScreenState();
}

class _EditTokenScreenState extends State<EditTokenScreen> {
  late TextEditingController _account;
  late TextEditingController _key;
  String _selectedServiceName = "";
  String _selectedOtpType = "Time-based";

  final Map<String, List<Service>> _serviceCategories = {
    "General": [
      Service(name: "Banking and finance", iconPath: "assets/icons/banking.svg"),
      Service(name: "Website", iconPath: "assets/icons/website.svg"),
      Service(name: "Mail", iconPath: "assets/icons/mail.svg"),
      Service(name: "Social", iconPath: "assets/icons/social.svg"),
    ],
    "Services": [
      Service(name: "Google", iconPath: "assets/icons/google.svg"),
      Service(name: "Instagram", iconPath: "assets/icons/instagram.svg"),
      Service(name: "Facebook", iconPath: "assets/icons/facebook.svg"),
      Service(name: "LinkedIn", iconPath: "assets/icons/linkedin.svg"),
      Service(name: "Microsoft", iconPath: "assets/icons/microsoft.svg"),
      Service(name: "Discord", iconPath: "assets/icons/discord.svg"),
      Service(name: "Netflix", iconPath: "assets/icons/netflix.svg"),
    ],
  };

  @override
  void initState() {
    super.initState();
    _account = TextEditingController(text: widget.token.account);
    _key = TextEditingController(text: widget.token.secret);
    _selectedServiceName = widget.token.service;
    _selectedOtpType = widget.token.type == AuthTokenType.totp ? "Time-based" : "Counter-based";
  }

  void _showServiceSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ServiceSelectionModal(
        serviceCategories: _serviceCategories,
        onServiceSelected: (serviceName) {
          setState(() {
            _selectedServiceName = serviceName;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showOtpTypeSelectionModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => OtpTypeSelectionModal(
        onOtpTypeSelected: (otpType) {
          setState(() {
            _selectedOtpType = otpType;
          });
          Navigator.pop(context);
        },
      ),
    );
  }

  Future<void> saveChanges() async {
    try {
      final updatedToken = AuthToken(
        service: _selectedServiceName,
        account: _account.text,
        secret: _key.text,
        type: _selectedOtpType == "Time-based"
            ? AuthTokenType.totp
            : AuthTokenType.hotp,
        counter: _selectedOtpType == "Time-based" ? null : 1,
      );

      final file = await _getUserInfoFile();

      List<AuthToken> tokens = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          tokens = AuthToken.listFromJson(content);
        }
      }

      int index = tokens.indexWhere((token) => token.account == widget.token.account);
      if (index != -1) {
        tokens[index] = updatedToken;
      }

      final jsonString = AuthToken.listToJson(tokens);
      await file.writeAsString(jsonString);

      Navigator.pop(context);
    } catch (e) {
      ErrorDialog().showErrorDialog(
        context,
        AppLocalizations.of(context)!.edit_error,
        AppLocalizations.of(context)!.edit_error_message,
      );
    }
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  Widget _textField({required TextEditingController controller, required String hintText, required String icon}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.gray6,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.light ? AppColors.gray4 : AppColors.gray2,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 24),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : AppColors.blue, BlendMode.srcIn),
            ),
          ),
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.gray6,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }

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
            width: 12,
            height: 12,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.edit_account,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20, right: 16, left: 16),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.gray6,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: _showServiceSelectionModal,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          _selectedServiceName.isEmpty
                              ? AppLocalizations.of(context)!.service
                              : _selectedServiceName,
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: _selectedServiceName.isEmpty ? AppColors.gray4 : Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white,
                          )
                      ),
                      SvgPicture.asset(
                        "assets/icons/arrow_bottom.svg",
                        width: 24,
                        height: 24,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            _textField(controller: _account, hintText: AppLocalizations.of(context)!.account, icon: "assets/icons/account.svg"),
            SizedBox(height: 16),
            _textField(controller: _key, hintText: AppLocalizations.of(context)!.key, icon: "assets/icons/key.svg"),
            SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.gray6,
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: _showOtpTypeSelectionModal,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedOtpType,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light ? AppColors.black : AppColors.white,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/icons/arrow_bottom.svg",
                        width: 24,
                        height: 24,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: saveChanges,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: AppColors.mainBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.of(context)!.save,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
