import 'dart:async';
import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:authenticator_app/data/models/service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:totp/totp.dart';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base32/base32.dart';
import '../../data/sources/constants/service_categories.dart';
import '../screens/edit_element_screen.dart';


class TimeBasedWidget extends StatefulWidget {
  final AuthToken timeBasedEl;
  final Function(AuthToken) onDelete;
  final Function()? onUpdated;

  const TimeBasedWidget({
    Key? key,
    required this.timeBasedEl,
    required this.onDelete,
    this.onUpdated,
  }) : super(key: key);

  @override
  _TimeBasedWidgetState createState() => _TimeBasedWidgetState();
}

class _TimeBasedWidgetState extends State<TimeBasedWidget> {
  late Totp totp;
  String totpCode = "";
  int countdown = 0;
  Timer? timer;

  String? iconPath;

  @override
  void initState() {
    super.initState();
    final cleanedSecret = widget.timeBasedEl.secret.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    totp = Totp(
      secret: base32.decode(cleanedSecret),
      digits: 6,
      algorithm: Algorithm.sha1,
    );

    _updateCode();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCode());
  }

  void _updateCode() {
    final now = DateTime.now();
    final secondsElapsed = now.second % 30;
    final remaining = 30 - secondsElapsed;
    final newCode = totp.generate(now);
    setState(() {
      totpCode = newCode;
      countdown = remaining;
    });
  }


  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _editService() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTokenScreen(token: widget.timeBasedEl)),
    );

    widget.onUpdated!();

    if (updated == true && context.mounted) {
      if (widget.onUpdated != null) {
        widget.onUpdated!();
      }
    }
  }


  Future<bool> _showDeleteConfirmationDialog() {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(AppLocalizations.of(context)!.confirming, style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),),
          content: Text(AppLocalizations.of(context)!.delete_conf),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: AppColors.mainBlue)),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child:Text(AppLocalizations.of(context)!.delete, style: TextStyle(color: Colors.red)),
            ),
            SizedBox(height: 40,),
          ],
        );
      },
    ).then((value) => value ?? false);
  }

  Widget _buildOptionButton({
    required String icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.blue),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                width: 18,
                height: 18,
                colorFilter: ColorFilter.mode(Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.blue, BlendMode.srcIn),
              ),
              SizedBox(width: 12),
              Text(
                  label,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).brightness == Brightness.light ? Color(0xFF1B539A) : AppColors.blue)
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      //backgroundColor: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? AppColors.white : AppColors.black,
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
                  label: AppLocalizations.of(context)!.edit,
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
                  label: AppLocalizations.of(context)!.delete,
                  onTap: () async {
                    Navigator.pop(context);
                    final delete = await _showDeleteConfirmationDialog();
                    if (delete) {
                      widget.onDelete(widget.timeBasedEl);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Токен видалено')),
                        );
                      }
                    }
                  },
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    iconPath = null;
    for (var category in serviceCategories.values) {
      for (var service in category) {
        if (service.name.toLowerCase() == widget.timeBasedEl.service.toLowerCase()) {
          iconPath = service.iconPath;
          break;
        }
      }
      if (iconPath != null) break;
    }
    iconPath ??= 'assets/icons/website.svg';

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
                            widget.timeBasedEl.service,
                            style: Theme.of(context).textTheme.headlineLarge,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: totpCode)).then((_) {
                              // ScaffoldMessenger.of(context).showSnackBar(
                              //   const SnackBar(content: Text('Код скопійовано в буфер обміну')),
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
                      widget.timeBasedEl.account,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xFF898989)),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '${totpCode.substring(0, 3)} ${totpCode.substring(3)}',
                          style: Theme.of(context).textTheme.displayMedium,
                        ),
                        const SizedBox(width: 16),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: CircularProgressIndicator(
                                value: countdown / 30,
                                strokeWidth: 2.5,
                                valueColor: AlwaysStoppedAnimation(Theme.of(context).brightness == Brightness.light ? AppColors.mainBlue : AppColors.blue),
                                backgroundColor: AppColors.lightBlue,
                              ),
                            ),
                            Text(
                              '$countdown',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
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