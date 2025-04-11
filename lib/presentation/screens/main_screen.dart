import 'dart:io';
import 'dart:ui';
import 'dart:convert';

import 'package:authenticator_app/presentation/screens/scan_qr_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/config/theme.dart' as AppColors;
import '../../data/models/auth_token.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../data/repositories/remote/synchronize_repository.dart';
import '../../data/repositories/remote/token_repository.dart';
import '../../logic/blocs/tokens/tokens_bloc.dart';
import '../../logic/blocs/tokens/tokens_event.dart';
import '../../logic/blocs/tokens/tokens_state.dart';
import '../widgets/counter_based_widget.dart';
import '../widgets/time_based_widget.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterTokens);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<TokensBloc>(context).add(LoadTokens());
    });
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  void _filterTokens() {
    final query = _searchController.text.toLowerCase();
    context.read<TokensBloc>().add(FilterTokens(query));
  }

  Widget _searchBox() {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.search,
          hintStyle: Theme.of(context).textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w400,
            color: AppColors.gray4
          ),
          prefixIcon: Icon(Icons.search, color: Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.blue),
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
          fillColor: Theme.of(context).cardColor,
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildCountBasedPage() {
    return BlocBuilder<TokensBloc, TokensState>(
      builder: (context, state) {
        if (state is TokensLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is TokensError) {
          return Center(child: Text(state.message));
        }

        if (state is TokensLoaded) {
          final counterTokens = state.counterTokens;

          if (counterTokens.isEmpty) {
            return Center(child: Text(':('));
          }

          return ListView.builder(
            itemCount: counterTokens.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                child: HotpWidget(
                  hotpEl: counterTokens[index],
                  onDelete: (token) {
                    BlocProvider.of<TokensBloc>(context).add(DeleteToken(token));
                  },
                ),
              );
            },
          );
        }

        return Center(child: Text('...'));
      },
    );
  }

  Widget _buildTimeBasedPage() {
    return BlocBuilder<TokensBloc, TokensState>(
      builder: (context, state) {
        if (state is TokensLoading) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is TokensError) {
          return Center(child: Text(state.message));
        }

        if (state is TokensLoaded) {
          final timeBasedTokens = state.timeBasedTokens;

          if (timeBasedTokens.isEmpty) {
            return Center(child: Text(':('));
          }

          return ListView.builder(
            itemCount: timeBasedTokens.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
                child: TimeBasedWidget(
                  timeBasedEl: timeBasedTokens[index],
                  onDelete: (token) {
                    BlocProvider.of<TokensBloc>(context).add(DeleteToken(token));
                  },
                ),
              );
            },
          );
        }

        return Center(child: Text('...'));
      },
    );
  }

  Widget _buildAdd2FACodes() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.light ? AppColors.white : Color(
              0xFF101010),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: -110,
                child: Container(
                  width: 185,
                  height: 185,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue.withOpacity(0.2) : AppColors.mainBlue.withOpacity(0.2),
                        blurRadius: 80,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                top: 100,
                right: 240,
                child: Container(
                  width: 185,
                  height: 185,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue.withOpacity(0.2) : AppColors.mainBlue.withOpacity(0.2),
                        blurRadius: 80,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 120,
                      height: 120,
                      child: Center(
                        child: SvgPicture.asset(
                          "assets/icons/2fa.svg",
                          width: 120,
                          height: 120,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                        AppLocalizations.of(context)!.add_2fa,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700)
                    ),
                    const SizedBox(height: 8),
                    Text(
                        AppLocalizations.of(context)!.keep_account,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w400)
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQrScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.mainBlue,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/qr.svg",
                            width: 18,
                            height: 18,
                          ),
                          SizedBox(width: 68),
                          Text(
                            AppLocalizations.of(context)!.scan_qr,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: AppColors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // Using BlocBuilder to listen to the state of TokensBloc
    return BlocBuilder<TokensBloc, TokensState>(
      builder: (context, state) {
        // Check if the state is loading
        if (state is TokensLoading) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Check if the tokens are loaded
        if (state is TokensLoaded) {
          // If tokens are empty, show a different UI
          if (state.allTokens.isEmpty) {
            return _buildAdd2FACodes();
          }

          // If tokens are available, show them in a tab-based view
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: _searchBox(),
                    ),
                    SizedBox(height: 6),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TabBar(
                        indicatorColor: AppColors.mainBlue,
                        labelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color:  Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : AppColors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                        unselectedLabelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Theme.of(context).brightness == Brightness.light ? AppColors.gray6 : AppColors.gray2,
                          fontWeight: FontWeight.w500,
                        ),
                        tabs: [
                          Tab(child: Text(AppLocalizations.of(context)!.time_based)),
                          Tab(child: Text(AppLocalizations.of(context)!.counter_based)),
                        ],
                      ),
                    ),

                    Expanded(
                      child: TabBarView(
                        children: [
                          _buildTimeBasedPage(),
                          _buildCountBasedPage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (state is TokensError) {
          return Scaffold(
            body: Center(
              child: Text(state.message),
            ),
          );
        }
        return Scaffold(
          body: Center(
            child: Text('Unknown state'),
          ),
        );
      },
    );
  }

}