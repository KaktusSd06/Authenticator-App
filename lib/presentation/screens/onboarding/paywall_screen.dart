import 'package:authenticator_app/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import '../../../core/config/theme.dart' as Colors;
import '../../widgets/continue_btn.dart';
import '../sign_in_screen.dart';

class PaywallScreen extends StatefulWidget{
  const PaywallScreen ({Key? key}) : super(key: key);

  @override
  _PaywallScreenState createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {

  bool isTrialEnabled = false;
  bool yearPlan = false;
  bool threeDayPlan = false;

  void btnPress() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/paywall_bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 60, left: 23, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignInScreen()));
                      },
                      child: SvgPicture.asset(
                        "assets/icons/x.svg",
                        width: 10,
                        height: 10,
                        colorFilter: ColorFilter.mode(Colors.mainBlue, BlendMode.srcIn),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => OnBoardingScreen()),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.restor_l,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.mainBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Spacer(),

            Padding(
              padding: const EdgeInsets.only(bottom: 28, right: 16, left: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    AppLocalizations.of(context)!.paywell_H1,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.paywell_T1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w400,
                      color: Colors.gray2,
                    ),
                  ),
                  SizedBox(height: 24),

                  //Switch
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: isTrialEnabled ? Color(0xFF094086) : Colors.gray2,
                        width: 3,
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(right: 6, left: 24, top: 0, bottom: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)?.free_Trial_Enabled ?? '',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Color(0xFF2A313E),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Switch(
                          value: isTrialEnabled,
                          onChanged: (value) {
                            setState(() {
                              isTrialEnabled = value;
                              threeDayPlan = false;
                              yearPlan = false;
                            });
                          },
                          activeColor: Colors.white, // Thumb color when active
                          activeTrackColor: Color(0xFF00CF00), // Track color when active
                          inactiveThumbColor: Colors.white, // Thumb color when inactive
                          inactiveTrackColor: Color(0xFFD9D9D9), // Track color when inactive
                          trackOutlineColor: MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                              return states.contains(MaterialState.selected)
                                  ? Color(0xFF00CF00) // No border when active
                                  :  Colors.gray2;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),


                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: !yearPlan ? Color(0xFF094086) : Colors.gray2,
                        width: 3,
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(right: 10, left: 24, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.year ?? '',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Color(0xFF5B88C0),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)?.uSD_Only ?? '',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Color(0xFF2A313E),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: (){
                            setState(() {
                              yearPlan = !yearPlan;
                              isTrialEnabled = false;
                              threeDayPlan = false;
                            });
                          },
                          child: !yearPlan ?
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1.5,
                                    color: Color(0xFF094086)
                                  ),

                                  borderRadius: BorderRadius.all(Radius.circular(12))
                                ),
                              ) :
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Color(0xFF094086),
                              ),
                              borderRadius: BorderRadius.all(Radius.circular(12)),
                            ),
                            child: Center(
                              child: Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: Color(0xFF094086),
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          )
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 12),

                  //three days
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(
                        color: !threeDayPlan ? Color(0xFF094086) : Colors.gray2,
                        width: 3,
                      ),
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.only(right: 10, left: 24, top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)?.free_day ?? '',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Color(0xFF2A313E),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)?.than_6 ?? '',
                              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Color(0xFF2A313E),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),

                        GestureDetector(
                            onTap: (){
                              setState(() {
                                threeDayPlan = !threeDayPlan;
                                isTrialEnabled = true;
                                yearPlan = false;
                              });
                            },
                            child: !threeDayPlan ?
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 1.5,
                                      color: Color(0xFF094086)
                                  ),

                                  borderRadius: BorderRadius.all(Radius.circular(12))
                              ),
                            ) :
                            Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF094086),
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(12)),
                              ),
                              child: Center(
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF094086),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            )
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  //Continue btn
                  SizedBox(
                    width: double.infinity,
                    child: ContinueBtn(
                      onPressed: btnPress,
                    ),
                  ),
                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/paywell.png",
                        width: 19,
                        height: 19,
                        color: Color(0xFF00CF00),
                        colorBlendMode: BlendMode.srcIn,
                      ),
                      SizedBox(width: 4),
                      Text(
                        AppLocalizations.of(context)!.paywell_info,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.gray2,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.gray2,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Terms of Use",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.gray2,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.gray2,
                        ),
                      ),
                      SizedBox(width: 6),
                      SvgPicture.asset(
                        "assets/icons/ellipse.svg",
                        width: 10,
                        height: 10,
                        colorFilter: ColorFilter.mode(Colors.gray2, BlendMode.srcIn),
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Privacy Policy",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Colors.gray2,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.gray2,
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}