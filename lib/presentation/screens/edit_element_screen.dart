import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:authenticator_app/logic/blocs/tokens/tokens_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'dart:io';
import '../../data/models/service.dart';
import '../../data/repositories/remote/synchronize_repository.dart';
import '../../data/repositories/remote/token_repository.dart';
import '../../logic/blocs/tokens/tokens_bloc.dart';
import '../../logic/blocs/tokens/tokens_state.dart';
import '../constants/service_categories.dart';
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
        serviceCategories: serviceCategories,
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

      final key = _key.text.trim().replaceAll(' ', '').toUpperCase();
      final account = _account.text.trim();
      final service = _selectedServiceName.trim();
      final otpType = _selectedOtpType;

      final isValidBase32 = RegExp(r'^[A-Z2-7]+={0,6}$').hasMatch(key);

      if (service.isEmpty || account.isEmpty || key.isEmpty) {
        ErrorDialog().showErrorDialog(
          context,
          AppLocalizations.of(context)!.add_error,
          AppLocalizations.of(context)!.fill_all_fields,
        );
        return;
      }

      if (!isValidBase32) {
        ErrorDialog().showErrorDialog(
          context,
          AppLocalizations.of(context)!.invalid_key,
          AppLocalizations.of(context)!.invalid_key_description,
        );
        return;
      }

      final tokenToUpdate = AuthToken(
        service: service,
        account: account,
        secret: key,
        type: otpType == "Time-based" ? AuthTokenType.totp : AuthTokenType.hotp,
        counter: otpType == "Time-based" ? null : 1,
      );

      BlocProvider.of<TokensBloc>(context).add(UpdateToken(tokenToUpdate));
      final currentState = BlocProvider.of<TokensBloc>(context).state;

      if (currentState is TokensLoaded) {
        final allTokens = currentState.allTokens;

        User? user = FirebaseAuth.instance.currentUser;
        final storage = FlutterSecureStorage();
        String? idToken = await storage.read(key: SecureStorageKeys.idToken);

        if (user != null && idToken != null) {
          if (await SynchronizeRepository().isSynchronizing(user.uid)) {
            await TokenService().saveTokensForUser(user.uid, allTokens);
          }
        }
        Navigator.pop(context);
      }

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
