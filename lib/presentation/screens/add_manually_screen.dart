import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:convert';
import 'dart:io';
import '../../data/models/service.dart';
import '../dialogs/error_dialog.dart';
import 'package:path_provider/path_provider.dart';


class AddManuallyScreen extends StatefulWidget {
  @override
  _AddManuallyScreenSate createState() => _AddManuallyScreenSate();
}

class _AddManuallyScreenSate extends State<AddManuallyScreen> {
  TextEditingController _account = TextEditingController();
  TextEditingController _key = TextEditingController();
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
            colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
          ),
        ),
        backgroundColor: AppColors.gray1,
        title: Text(
          AppLocalizations.of(context)!.add_account,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
            color: Color(0xFF171818),
          ),
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
                color: AppColors.white,
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
                            color: _selectedServiceName.isEmpty ? AppColors.gray5 : Colors.black,
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
                color: AppColors.white,
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
                          color: Colors.black,
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
              onPressed: () {
                addServiceBtn();
              },
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
                  SvgPicture.asset(
                    "assets/icons/add.svg",
                    width: 24,
                    height: 24,
                    fit: BoxFit.scaleDown,
                    colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
                  ),
                  SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.add,
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

  Future<void> addServiceBtn() async {
    try {
      final newToken = AuthToken(
          service: _selectedServiceName,
          account: _account.text,
          secret: _key.text,
          type: _selectedOtpType == "Time-based"
              ? AuthTokenType.totp
              : AuthTokenType.hotp,
          counter: _selectedOtpType == "Time-based" ? null : 1
      );

      final file = await _getUserInfoFile();

      List<AuthToken> tokens = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          tokens = AuthToken.listFromJson(content);
        }
      }

      tokens.add(newToken);

      final jsonString = AuthToken.listToJson(tokens);
      await file.writeAsString(jsonString);

      Navigator.pop(context);
    }
    catch(Ex){
      ErrorDialog().showErrorDialog(
        context,
        AppLocalizations.of(context)!.add_error,
        AppLocalizations.of(context)!.add_error_message,
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: const Color(0xFF707877),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 24),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
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
          fillColor: AppColors.white,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}

class OtpTypeSelectionModal extends StatelessWidget {
  final Function(String) onOtpTypeSelected;

  const OtpTypeSelectionModal({
    Key? key,
    required this.onOtpTypeSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text("Time-based"),
                  onTap: () => onOtpTypeSelected("Time-based"),
                ),
                ListTile(
                  title: Text("Counter-based"),
                  onTap: () => onOtpTypeSelected("Counter-based"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceSelectionModal extends StatelessWidget {
  final Map<String, List<Service>> serviceCategories;
  final Function(String) onServiceSelected;

  const ServiceSelectionModal({
    Key? key,
    required this.serviceCategories,
    required this.onServiceSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 16),
              itemCount: serviceCategories.length,
              itemBuilder: (context, categoryIndex) {
                String category = serviceCategories.keys.elementAt(
                    categoryIndex);
                List<Service> services = serviceCategories[category]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 8),
                      child: Text(
                        category,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ...services.map((service) =>
                        ListTile(
                          leading: Container(
                            width: 32,
                            height: 32,
                            alignment: Alignment.center,
                            child: service.iconPath.isNotEmpty
                                ? SvgPicture.asset(
                              service.iconPath,
                              width: 32,
                              height: 32,
                            )
                                : Icon(Icons.apps, color: AppColors.mainBlue),
                          ),
                          title: Text(service.name),
                          onTap: () => onServiceSelected(service.name),
                        )).toList(),
                    if (categoryIndex < serviceCategories.length - 1)
                      SizedBox(height: 8),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}