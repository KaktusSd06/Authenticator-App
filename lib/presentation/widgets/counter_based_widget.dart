import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hotp/hotp.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base32/base32.dart';
import '../../data/sources/constants/service_categories.dart';
import '../screens/edit_element_screen.dart';

class HotpWidget extends StatefulWidget {
  final AuthToken hotpEl;
  final Function(AuthToken) onDelete;
  final Future<void>? onUpdated;

  const HotpWidget({
    Key? key,
    required this.hotpEl,
    required this.onDelete,
    this.onUpdated,
  }) : super(key: key);

  @override
  _HotpWidgetState createState() => _HotpWidgetState();
}

class _HotpWidgetState extends State<HotpWidget> {
  late Hotp hotp;
  String hotpCode = "";
  late int counter;

  String? iconPath;

  @override
  void initState() {
    super.initState();
    counter = widget.hotpEl.counter ?? 0;
    _initializeHotp();

    final newCode = hotp.generate(counter++);
    setState(() {
      hotpCode = newCode;
    });
    //_updateCode();
  }

  void _initializeHotp() {
    final cleanedSecret = widget.hotpEl.secret.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    hotp = Hotp(
      secret: base32.decode(cleanedSecret),
      digits: 6,
      algorithm: Algorithm.sha1,
    );
  }

  void _updateCode() {
    _updateTokenInFile(widget.hotpEl);
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }

  Future<void> _updateTokenInFile(AuthToken token) async {
    try {
      counter = counter +1;
      widget.hotpEl.counter = counter;

      final newCode = hotp.generate(counter);
      setState(() {
        hotpCode = newCode;
      });

      final file = await _getUserInfoFile();
      final allTokens = await _loadTokensFromFile();

      final index = allTokens.indexWhere((t) => t.service == token.service && t.account == token.account);
      if (index != -1) {
        allTokens[index].counter = counter;
        //counter++;
        final jsonString = jsonEncode(allTokens.map((token) => token.toJson()).toList());
        await file.writeAsString(jsonString);
      }
    } catch (e) {
      debugPrint('Error updating token: ${e.toString()}');
    }
  }

  Future<List<AuthToken>> _loadTokensFromFile() async {
    try {
      final file = await _getUserInfoFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          return AuthToken.listFromJson(content);
        }
      }
    } catch (e) {
      debugPrint('Error loading tokens: ${e.toString()}');
    }
    return [];
  }

  void _editService() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTokenScreen(token: widget.hotpEl)),
    );

    // if (updated == true && mounted) {
    //   _initializeHotp();
    //   if (widget.onUpdated != null) {
    //     widget.onUpdated!();
    //   }
    // }
  }

  Future<bool> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            localizations.confirming,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          content: Text(localizations.delete_conf),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                  localizations.cancel,
                  style: TextStyle(color: AppColors.blue)
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                  localizations.delete,
                  style: TextStyle(color: Colors.red)
              ),
            ),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Widget _buildOptionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool? isCenter,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.gray4),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            //mainAxisAlignment: isCenter == true ? MainAxisAlignment.center : MainAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.gray4, BlendMode.srcIn),
              ),
              SizedBox(width: 12),
              Text(
                label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.gray4)
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _showBottomSheetUpdate() {
    showModalBottomSheet(
      context: context,
      //backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? AppColors.white : Color(0xFF171717),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24),
              Text(
                AppLocalizations.of(context)!.sure_update,
                style: Theme.of(context).textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildOptionButton(
                  icon: "assets/icons/update.svg",
                  label: localizations.update_code,
                  onTap: () {
                    Navigator.pop(context);
                    _updateCode();
                  },
                    isCenter: true,
                ),
              ),
              SizedBox(height: 66),
            ],
          ),
        );
      },
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      //backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        final localizations = AppLocalizations.of(context)!;
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? AppColors.white : Color(0xFF171717),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12),
              Container(
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildOptionButton(
                  icon: "assets/icons/edit.svg",
                  label: localizations.edit,
                  onTap: () {
                    Navigator.pop(context);
                    _editService();
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildOptionButton(
                  icon: "assets/icons/delete.svg",
                  label: localizations.delete,
                  onTap: () async {
                    Navigator.pop(context);
                    final delete = await _showDeleteConfirmationDialog();
                    if (delete) {
                      widget.onDelete(widget.hotpEl);
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Токен видалено')),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 66),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Find icon for the service
    iconPath = null;
    for (var category in serviceCategories.values) {
      for (var service in category) {
        if (service.name.toLowerCase() == widget.hotpEl.service.toLowerCase()) {
          iconPath = service.iconPath;
          break;
        }
      }
      if (iconPath != null) break;
    }
    iconPath ??= 'assets/icons/website.svg';

    final localizations = AppLocalizations.of(context)!;

    return GestureDetector(
      onLongPress: _showBottomSheet,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.all(Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 7,
              spreadRadius: 2,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SvgPicture.asset(
                iconPath!,
                width: 64,
                height: 64,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Text(
                            widget.hotpEl.service,
                            style: Theme.of(context).textTheme.headlineLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: hotpCode)).then((_) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   SnackBar(content: Text('copy')),
                              // );
                            });
                          },
                          child: SvgPicture.asset(
                            "assets/icons/copy.svg",
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? AppColors.blue : AppColors.lightBlue, BlendMode.srcIn),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      widget.hotpEl.account,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF898989)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${hotpCode.substring(0, 3)} ${hotpCode.substring(3)}',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: _showBottomSheetUpdate,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                "assets/icons/update.svg",
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(AppColors.blue, BlendMode.srcIn),
                              ),
                              SizedBox(width: 4),
                              Text(
                                localizations.update,
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.blue),
                              )
                            ],
                          ),
                        )
                      ],
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
}