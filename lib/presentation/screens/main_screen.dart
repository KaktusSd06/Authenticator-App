import 'dart:io';
import 'dart:ui';
import 'dart:convert';

import 'package:authenticator_app/presentation/screens/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:authenticator_app/presentation/screens/info_screen.dart';
import 'package:authenticator_app/presentation/screens/main_screen.dart';
import 'package:flutter_svg/svg.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/config/theme.dart' as AppColors;
import '../../data/models/auth_token.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/counter_based_widget.dart';
import '../widgets/time_based_widget.dart';


class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}


class _MainScreenState extends State<MainScreen> {
  final TextEditingController _searchController = TextEditingController();
  late List<AuthToken> allTokens  = [];
  late List<AuthToken> filteredTokens = [];
  late List<AuthToken> time_based_tokens = [];
  late List<AuthToken> counter_tokens = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTokens();
    _searchController.addListener(_filterTokens);
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  void _loadTokens() async {
    final file = await _getUserInfoFile();

    if (await file.exists()) {
      final content = await file.readAsString();
      if (content.isNotEmpty) {
        allTokens = AuthToken.listFromJson(content);
        _filterTokens();

      }
    }

    if (mounted) {
      setState(() {
        isLoading = false;
        time_based_tokens = filteredTokens.where((token) => token.type == AuthTokenType.totp).toList();
        counter_tokens = filteredTokens.where((token) => token.type == AuthTokenType.hotp).toList();
      });
    }
  }

  void _filterTokens() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredTokens = allTokens.where((token) {
        return token.service.toLowerCase().contains(query) ||
            token.account.toLowerCase().contains(query);
      }).toList();
      time_based_tokens = filteredTokens.where((token) => token.type == AuthTokenType.totp).toList();
      counter_tokens = filteredTokens.where((token) => token.type == AuthTokenType.hotp).toList();
    });
  }

  Future<void> _deleteToken(AuthToken token) async {
    setState(() {
      allTokens.removeWhere((t) =>
      t.service == token.service && t.account == token.account && t.secret == token.secret);
    });

    _filterTokens();

    final file = await _getUserInfoFile();
    final jsonString = jsonEncode(allTokens.map((token) => token.toJson()).toList());
    await file.writeAsString(jsonString);
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
            color: const Color(0xFF707877),
          ),
          prefixIcon: Icon(Icons.search, color: AppColors.mainBlue),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        ),
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildCountBasedPage() {
    if (counter_tokens.isEmpty) {
      return Center(child: Text(':('));
    }

    return ListView.builder(
      itemCount: counter_tokens.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
          child: HotpWidget(
            hotpEl: counter_tokens[index],
            onDelete: _deleteToken,
            onUpdated: _loadTokens,
          ),
        );
      },
    );
  }

  Widget _buildTimeBasedPage() {
    if (time_based_tokens.isEmpty) {
      return Center(child: Text(':('));
    }

    return ListView.builder(
      itemCount: time_based_tokens.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 16),
          child: TimeBasedWidget(
            timeBasedEl: time_based_tokens[index],
            onDelete: _deleteToken,
            onUpdated: _loadTokens,
          ),
        );
      },
    );
  }

  Widget _buildAdd2FACodes() {
    return Padding(
      padding: const EdgeInsets.only(top: 24, right: 16, left: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF0F4FA), Color(0xFFE6EEF8)],
          ),
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
                        color: Color(0xFF1B539A).withOpacity(0.2),
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
                        color: Color(0xFF1B539A).withOpacity(0.2),
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
    if (isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return allTokens.isEmpty
        ? _buildAdd2FACodes()
        : DefaultTabController(
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
                    color: AppColors.mainBlue,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.gray6,
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
}