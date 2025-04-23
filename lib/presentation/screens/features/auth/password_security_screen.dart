import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../../core/config/theme.dart' as app_colors;
import '../../../widgets/settings_tile.dart';
import 'change_pin_screen.dart';
import 'create_pin_screen.dart';
import 'bloc/auth_bloc.dart';
import 'bloc/auth_event.dart';
import 'bloc/auth_state.dart';

class PasswordSecurityScreen extends StatefulWidget {
  const PasswordSecurityScreen({super.key});

  @override
  State<PasswordSecurityScreen> createState() => _PasswordSecurityScreenState();
}

class _PasswordSecurityScreenState extends State<PasswordSecurityScreen> {
  bool _isPassword = false;
  bool _isLoading = false;
  bool _isBiometrics = false;
  bool _isAvailableBiometrics = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    context.read<AuthBloc>().add(CheckBiometricAvailabilityEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(
          color: app_colors.mainBlue,
        ),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 6,
            height: 12,
            colorFilter: ColorFilter.mode(app_colors.mainBlue, BlendMode.srcIn),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.password_security,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is BiometricState) {
            setState(() {
              _isAvailableBiometrics = state.isAvailable;
              _isBiometrics = state.isEnabled;
              _isLoading = false;
            });

            // Check if PIN exists
            context.read<AuthBloc>().add(CheckPinExistsEvent());
          } else if (state is PinExistsState) {
            setState(() {
              _isPassword = state.exists;
              _isLoading = false;
            });
          } else if (state is NewPinCreated) {
            setState(() {
              _isPassword = true;
            });
          } else if (state is PinRemoved) {
            setState(() {
              _isPassword = false;
            });
          }
        },
        builder: (context, state) {
          if (_isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          return _isPassword
              ? _buildBodyWithPassword()
              : _buildBodyWithOutPassword();
        },
      ),
    );
  }

  Widget _buildBodyWithPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/key.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue, BlendMode.srcIn),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  AppLocalizations.of(context)!.password,
                                  style: Theme.of(context).textTheme.headlineLarge,
                                ),
                              ],
                            ),
                            Switch(
                              value: _isPassword,
                              onChanged: (value) {
                                if (value) {
                                  setPassword();
                                } else {
                                  deletePassword();
                                }
                              },
                              activeColor: Colors.white,
                              activeTrackColor: app_colors.blue,
                              inactiveThumbColor: Colors.white,
                              inactiveTrackColor: Color(0xFFD9D9D9),
                              trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                                    (Set<WidgetState> states) {
                                  return states.contains(WidgetState.selected)
                                      ? app_colors.mainBlue
                                      : app_colors.gray4;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, thickness: 1, color: Theme.of(context).brightness == Brightness.light ? app_colors.gray2 : app_colors.gray6),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: SettingsTile(
                      iconPath: "assets/icons/sync.svg",
                      title: AppLocalizations.of(context)!.change_password,
                      trailingIconPath: "assets/icons/ic_24.svg",
                      onTap: _changePassword,
                      isLast: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          _isAvailableBiometrics
              ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Theme.of(context).cardColor,
              boxShadow: [
                BoxShadow(
                  color: app_colors.black.withAlpha((0.05 * 255).round()),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: Offset(0, 0),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SvgPicture.asset(
                              "assets/icons/fingerprint.svg",
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue, BlendMode.srcIn),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              AppLocalizations.of(context)!.biometrics,
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                          ],
                        ),
                        Switch(
                          value: _isBiometrics,
                          onChanged: (value) {
                            context.read<AuthBloc>().add(ToggleBiometricEvent(value));
                            setState(() {
                              _isBiometrics = value;
                            });
                          },
                          activeColor: app_colors.white,
                          activeTrackColor: app_colors.blue,
                          inactiveThumbColor: app_colors.white,
                          inactiveTrackColor: Color(0xFFD9D9D9),
                          trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                                (Set<WidgetState> states) {
                              return states.contains(WidgetState.selected)
                                  ? app_colors.mainBlue
                                  : app_colors.gray4;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
              : SizedBox(height: 0),
        ],
      ),
    );
  }

  Widget _buildBodyWithOutPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).cardColor,
          boxShadow: [
            BoxShadow(
              color: app_colors.black.withAlpha((0.05 * 255).round()),
              blurRadius: 20,
              spreadRadius: 2,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    "assets/icons/key.svg",
                    width: 24,
                    height: 24,
                    colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : app_colors.blue, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context)!.password,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              Switch(
                value: _isPassword,
                onChanged: (value) {
                  if (value) {
                    setPassword();
                  }
                },
                activeColor: Colors.white,
                activeTrackColor: app_colors.blue,
                inactiveThumbColor: Colors.white,
                inactiveTrackColor: Color(0xFFD9D9D9),
                trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                      (Set<WidgetState> states) {
                    return states.contains(WidgetState.selected)
                        ? app_colors.mainBlue
                        : app_colors.gray4;
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void setPassword() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CreatePinScreen()),
    );

    context.read<AuthBloc>().add(CheckPinExistsEvent());
  }

  void _changePassword() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePinScreen()));
  }

  void deletePassword() {
    context.read<AuthBloc>().add(DeletePinEvent());
  }
}
