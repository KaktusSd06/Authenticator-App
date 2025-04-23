import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:authenticator_app/presentation/screens/features/tokens/tokens/tokens_bloc.dart';
import 'package:authenticator_app/presentation/screens/features/tokens/tokens/tokens_event.dart';
import 'package:authenticator_app/presentation/screens/features/tokens/tokens/tokens_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/config/secure_storage_keys.dart';
import '../../../../core/config/theme.dart' as app_colors;
import '../../../../data/models/service.dart';
import '../../../../data/repositories/remote/synchronize_repository.dart';
import '../../../../data/repositories/remote/token_repository.dart';
import '../../../constants/service_categories.dart';
import '../../../dialogs/error_dialog.dart';

class AddManuallyScreen extends StatefulWidget {

  const AddManuallyScreen({super.key});

  @override
  AddManuallyScreenSate createState() => AddManuallyScreenSate();
}

class AddManuallyScreenSate extends State<AddManuallyScreen> {
  final TextEditingController _account = TextEditingController();
  final TextEditingController _key = TextEditingController();
  String _selectedServiceName = "";
  String _selectedOtpType = "Time-based";

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: app_colors.mainBlue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 12,
            height: 12,
            fit: BoxFit.contain,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.add_account,
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
                color: Theme.of(context).brightness == Brightness.light ? app_colors.white : app_colors.gray6,
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
                            color: _selectedServiceName.isEmpty ? app_colors.gray4 : Theme.of(context).brightness == Brightness.light ? app_colors.black : Colors.white,
                          )
                      ),
                      SvgPicture.asset(
                        "assets/icons/arrow_bottom.svg",
                        width: 24,
                        height: 24,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue, BlendMode.srcIn),
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
                color: Theme.of(context).brightness == Brightness.light ? app_colors.white : app_colors.gray6,
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
                          color: Theme.of(context).brightness == Brightness.light ? app_colors.black : app_colors.white,
                        ),
                      ),
                      SvgPicture.asset(
                        "assets/icons/arrow_bottom.svg",
                        width: 24,
                        height: 24,
                        fit: BoxFit.scaleDown,
                        colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue, BlendMode.srcIn),
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
                backgroundColor: app_colors.mainBlue,
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
                    colorFilter: ColorFilter.mode(app_colors.white, BlendMode.srcIn),
                  ),
                  SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.add,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: app_colors.white),
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

    try {
      final newToken = AuthToken(
        service: service,
        account: account,
        secret: key,
        type: otpType == "Time-based" ? AuthTokenType.totp : AuthTokenType.hotp,
        counter: otpType == "Time-based" ? null : 1,
      );

      BlocProvider.of<TokensBloc>(context).add(AddToken(newToken));

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
        AppLocalizations.of(context)!.add_error,
        AppLocalizations.of(context)!.add_error_message,
      );
    }
  }

  Widget _textField({required TextEditingController controller, required String hintText, required String icon}) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? app_colors.white : app_colors.gray6,
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: Theme.of(context).brightness == Brightness.light ? app_colors.gray4 : app_colors.gray2,
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 24),
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: SvgPicture.asset(
              icon,
              width: 24,
              height: 24,
              fit: BoxFit.scaleDown,
              colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue, BlendMode.srcIn),
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
          fillColor: Theme.of(context).brightness == Brightness.light ? app_colors.white : app_colors.gray6,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}

class OtpTypeSelectionModal extends StatelessWidget {
  final Function(String) onOtpTypeSelected;

  const OtpTypeSelectionModal({
    super.key,
    required this.onOtpTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light ? app_colors.white : Color(0xFF171717),
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
    super.key,
    required this.serviceCategories,
    required this.onServiceSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery
          .of(context)
          .size
          .height * 0.7,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
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
                //color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: 12),
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
                                : Icon(Icons.apps, color: app_colors.mainBlue),
                          ),
                          title: Text(service.name),
                          onTap: () => onServiceSelected(service.name),
                        )),
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