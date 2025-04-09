import 'package:authenticator_app/presentation/screens/add_manually_screen.dart';
import 'package:authenticator_app/presentation/screens/scan_qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:ui';
import '../../../core/config/theme.dart' as AppColors;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IslandNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const IslandNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 82,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 70,
              child: ClipPath(
                clipper: BottomNavClipper(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF88BDFF).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child:  Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => onItemTapped(0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  selectedIndex == 0 ?
                                  "assets/icons/main_page_icon_active.svg" :
                                  "assets/icons/main_page_icon_inactive.svg",
                                  width: 24,
                                  height: 24,
                                  colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(width: 80),

                        Expanded(
                          child: InkWell(
                            onTap: () => onItemTapped(1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  child: SvgPicture.asset(
                                    selectedIndex == 1 ?
                                    "assets/icons/info_page_icon_active.svg" :
                                    "assets/icons/info_page_icon_inactive.svg",
                                    width: 24,
                                    height: 24,
                                    colorFilter: ColorFilter.mode(AppColors.mainBlue, BlendMode.srcIn),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                _showAddOptionsModal(context);
              },
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Color(0xFF1B539A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddOptionsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      //backgroundColor: Colors.transparent,
      builder: (context) {
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
                  icon: "assets/icons/qr.svg",
                  label: AppLocalizations.of(context)!.scan_qr,
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ScanQrScreen()));
                  },
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildOptionButton(
                  icon: "assets/icons/edit.svg",
                  label: "Enter code manually",
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddManuallyScreen()));
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: AppColors.mainBlue)
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomNavClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final centerX = size.width / 2;
    final notchRadius = 35.0;
    final notchDepth = 20.0;
    final cornerRadius = 16.0;

    path.moveTo(0, 0);
    path.lineTo(centerX - notchRadius - cornerRadius, 0);

    path.quadraticBezierTo(
      centerX - notchRadius,
      0,
      centerX - notchRadius,
      notchDepth,
    );

    path.arcToPoint(
      Offset(centerX + notchRadius, notchDepth),
      radius: const Radius.circular(35),
      clockwise: false,
    );

    path.quadraticBezierTo(
      centerX + notchRadius,
      0,
      centerX + notchRadius + cornerRadius,
      0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}