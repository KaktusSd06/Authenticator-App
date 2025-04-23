import 'package:authenticator_app/presentation/screens/features/sign_in/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/config/theme.dart' as app_colors;
import '../../../widgets/btn_with_stoke.dart';
import '../../../widgets/settings_tile.dart';
import '../paywall/paywall_screen.dart';
import 'bloc/subscription_bloc.dart';
import 'bloc/subscription_event.dart';
import 'bloc/subscription_state.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SubscriptionBloc()..add(LoadSubscription()),
      child: _SubscriptionScreenContent(),
    );
  }
}

class _SubscriptionScreenContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          AppLocalizations.of(context)!.subscription,
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<SubscriptionBloc, SubscriptionState>(
          builder: (context, state) {
            if (state is SubscriptionLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SubscriptionLoaded) {
              return _buildContent(context, state);
            } else if (state is SubscriptionError) {
              return Center(child: Text(state.errorMessage));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, SubscriptionLoaded state) {
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
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: app_colors.black.withAlpha((0.1 * 255).round()),
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: SettingsTile(
              iconPath: "assets/icons/sign_in.svg",
              title: AppLocalizations.of(context)!.signin,
              trailingIconPath: "assets/icons/ic_24.svg",
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInScreen()));
              },
              isLast: true,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNonPremiumContent(BuildContext context) {
    return Column(
      children: [
        Container(
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
            child: SettingsTile(
              iconPath: "assets/icons/choose_a_plan.svg",
              title: AppLocalizations.of(context)!.choose_a_plan,
              trailingIconPath: "assets/icons/ic_24.svg",
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PaywallScreen())
                ).then((_) => context.read<SubscriptionBloc>().add(LoadSubscription()));
              },
              isLast: true,
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: BtnWithStoke(
            onPressed: () {
              context.read<SubscriptionBloc>().add(RestorePurchases());
            },
            text: AppLocalizations.of(context)!.restore_purchases,
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumContent(BuildContext context, SubscriptionLoaded state) {
    String subscriptionText;
    switch (state.subscriptionType) {
      case 'trial':
        subscriptionText = AppLocalizations.of(context)!.free_trial;
        break;
      case 'year':
        subscriptionText = AppLocalizations.of(context)!.year_subscription;
        break;
      case 'week':
        subscriptionText = AppLocalizations.of(context)!.weekly_subscription;
        break;
      default:
        subscriptionText = state.subscriptionType;
    }

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).cardColor,
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 20,
                spreadRadius: 2,
                offset: Offset(0, 0),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.current_plan,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF272E3B) : app_colors.white),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: subscriptionText,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Theme.of(context).brightness == Brightness.light ? const Color(0xFF272E3B) : app_colors.white),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
                const SizedBox(height: 8),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: AppLocalizations.of(context)!.billing_date,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Theme.of(context).brightness == Brightness.light ? app_colors.gray6 : app_colors.gray4,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                      const TextSpan(text: ' '),
                      TextSpan(
                        text: state.billingDate,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            color: Theme.of(context).brightness == Brightness.light ? app_colors.gray6 : app_colors.gray4,
                            fontWeight: FontWeight.w400
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: BtnWithStoke(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PaywallScreen())
              ).then((_) => context.read<SubscriptionBloc>().add(LoadSubscription()));
            },
            text: AppLocalizations.of(context)!.change_plan,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              context.read<SubscriptionBloc>().add(ClearSubscriptionData());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  side: const BorderSide(color: Colors.red, width: 2)
              ),
            ),
            child: Text(
              AppLocalizations.of(context)!.cancel_plan,
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}