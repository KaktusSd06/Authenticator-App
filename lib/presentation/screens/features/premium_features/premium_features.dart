import 'package:authenticator_app/presentation/screens/features/premium_features/bloc/premium_bloc.dart';
import 'package:authenticator_app/presentation/screens/features/premium_features/bloc/premium_event.dart';
import 'package:authenticator_app/presentation/screens/features/premium_features/bloc/premium_state.dart';
import 'package:authenticator_app/presentation/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../../core/config/theme.dart' as app_colors;
import '../../../widgets/settings_tile.dart';
import '../paywall/paywall_screen.dart';

class PremiumFeaturesScreen extends StatelessWidget {
  const PremiumFeaturesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PremiumFeaturesBloc()..add(LoadPremiumFeatures()),
      child: _PremiumFeaturesScreenContent(),
    );
  }
}

class _PremiumFeaturesScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.premium_features,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: SvgPicture.asset(
            "assets/icons/arrow_back.svg",
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light ? app_colors.mainBlue : Colors.blue,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      body: BlocBuilder<PremiumFeaturesBloc, PremiumFeaturesState>(
        builder: (context, state) {
          if (state is PremiumFeaturesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PremiumFeaturesLoaded) {
            return Padding(
              padding: const EdgeInsets.only(top: 16, right: 16, left: 16),
              child: _buildContent(context, state),
            );
          } else if (state is PremiumFeaturesError) {
            return Center(child: Text('${state.errorMessage}'));
          } else {
            return SizedBox.shrink();
          }
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, PremiumFeaturesLoaded state) {
    if (!state.isAuthenticated) {
      return _buildUnauthenticatedContent(context);
    } else if (state.isAuthenticated && !state.isPremium) {
      return _buildNonPremiumContent(context);
    } else {
      return _buildPremiumContent(context, state);
    }
  }

  Widget _buildUnauthenticatedContent(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          context,
          SettingsTile(
            iconPath: "assets/icons/sign_in.svg",
            title: AppLocalizations.of(context)!.signin,
            trailingIconPath: "assets/icons/ic_24.svg",
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
            },
            isLast: true,
          ),
        ),
      ],
    );
  }

  Widget _buildNonPremiumContent(BuildContext context) {
    return Column(
      children: [
        _buildCard(
          context,
          SettingsTile(
            iconPath: "assets/icons/choose_a_plan.svg",
            title: AppLocalizations.of(context)!.choose_a_plan,
            trailingIconPath: "assets/icons/ic_24.svg",
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PaywallScreen()))
                  .then((_) => context.read<PremiumFeaturesBloc>().add(LoadPremiumFeatures()));
            },
            isLast: true,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumContent(BuildContext context, PremiumFeaturesLoaded state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCard(
          context,
          Column(
            children: [
              SettingsTile(
                iconPath: "assets/icons/sign_in.svg",
                title: AppLocalizations.of(context)!.sign_out,
                trailingIconPath: "assets/icons/ic_24.svg",
                onTap: () => context.read<PremiumFeaturesBloc>().add(SignOut(context: context)),
                isLast: false,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          "assets/icons/sync.svg",
                          width: 24,
                          height: 24,
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).brightness == Brightness.light ? Colors.blue : Colors.lightBlue,
                              BlendMode.srcIn),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppLocalizations.of(context)!.synchronize,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ],
                    ),
                    Switch(
                      value: state.isSyncEnabled,
                      onChanged: (value) => context.read<PremiumFeaturesBloc>().add(ToggleSync(value: value)),
                      activeColor: Colors.white,
                      activeTrackColor: app_colors.blue,
                      inactiveThumbColor: Colors.white,
                      inactiveTrackColor: Color(0xFFD9D9D9),
                      trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                            (Set<WidgetState> states) {
                          return states.contains(WidgetState.selected) ? app_colors.mainBlue : app_colors.gray4;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Divider(height: 1, thickness: 1, color: Theme.of(context).brightness == Brightness.light ? app_colors.gray2 : app_colors.gray6),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (dialogContext) => AlertDialog(
                        title: Text(
                          AppLocalizations.of(dialogContext)!.delete_account,
                          style: Theme.of(dialogContext).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        content: Text(AppLocalizations.of(dialogContext)!.delete_account_confirm),
                        backgroundColor: Theme.of(dialogContext).cardColor,
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(dialogContext).pop(),
                            child: Text(
                              AppLocalizations.of(dialogContext)!.cancel,
                              style: TextStyle(color: app_colors.blue),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(dialogContext).pop();
                              context.read<PremiumFeaturesBloc>().add(DeleteAccount(context: context));
                            },
                            child: Text(
                              AppLocalizations.of(dialogContext)!.delete,
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        "assets/icons/delete.svg",
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(Color(0xFFE33C3C), BlendMode.srcIn),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.delete_account,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Color(0xFFE33C3C)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!state.isPremium)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildCard(
              context,
              SettingsTile(
                iconPath: "assets/icons/choose_a_plan.svg",
                title: AppLocalizations.of(context)!.choose_a_plan,
                trailingIconPath: "assets/icons/ic_24.svg",
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PaywallScreen()))
                      .then((_) => context.read<PremiumFeaturesBloc>().add(LoadPremiumFeatures()));
                },
                isLast: true,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, Widget child) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha((0.1 * 255).round()),
            blurRadius: 20,
            spreadRadius: 2,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: child,
      ),
    );
  }
}