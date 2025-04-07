// bottom_sheet_utils.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:authenticator_app/core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<bool> showDeleteConfirmationDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.white,
        title: Text(
          AppLocalizations.of(context)!.confirming,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        content: Text(AppLocalizations.of(context)!.delete_conf),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: AppColors.mainBlue),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text(
              AppLocalizations.of(context)!.delete,
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}

Widget buildOptionButton({
  required String icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF1B539A)),
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
              colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
            ),
            SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.mainBlue),
            ),
          ],
        ),
      ),
    ),
  );
}

void showCustomBottomSheet(BuildContext context, VoidCallback editService, VoidCallback deleteService) {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
    ),
    builder: (BuildContext context) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
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
              child: buildOptionButton(
                icon: "assets/icons/edit.svg",
                label: AppLocalizations.of(context)!.edit,
                onTap: () {
                  Navigator.pop(context);
                  editService();
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: buildOptionButton(
                icon: "assets/icons/delete.svg",
                label: AppLocalizations.of(context)!.delete,
                onTap: () async {
                  Navigator.pop(context);
                  final delete = await showDeleteConfirmationDialog(context);
                  if (delete) {
                    deleteService();
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
