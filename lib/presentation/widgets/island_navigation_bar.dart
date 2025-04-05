import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as AppColors;


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
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF88BDFF).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(35),
                  ),
                  child: Row(
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

          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: () {
                // Add button functionality here
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
