import 'package:authenticator_app/core/config/secure_storage_keys.dart';
import 'package:authenticator_app/data/models/auth_token.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../data/repositories/remote/synchronize_repository.dart';
import '../../data/repositories/remote/token_repository.dart';
import '../../logic/blocs/tokens/tokens_bloc.dart';
import '../../logic/blocs/tokens/tokens_event.dart';
import '../dialogs/error_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ScanQrScreen extends StatefulWidget {
  @override
  _ScanQrScreenState createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> {
  bool _isPermissionGranted = false;
  bool _isProcessing = false;

  MobileScannerController cameraController = MobileScannerController();

  @override
  void initState() {
    super.initState();
    _setSystemUIOverlayStyle();
    _requestCameraPermission();
  }

  void _setSystemUIOverlayStyle() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.black.withOpacity(0.5),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black.withOpacity(0.5),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    setState(() {
      _isPermissionGranted = status == PermissionStatus.granted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _buildCameraView(),
          SafeArea(
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Scan QR-code',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: _buildQRScannerOverlay(),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 40, top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.bolt, color: Colors.white),
                            onPressed: () {
                              cameraController.toggleTorch();
                            },
                          ),
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade600,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.photo, color: Colors.white),
                            onPressed: _pickImageFromGallery,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView() {
    if (!_isPermissionGranted) {
      return Center(
        child: Text(
          'Camera permission is required.',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    return MobileScanner(
      controller: cameraController,
      onDetect: (BarcodeCapture barcodeCapture) async {
        if (_isProcessing) return;
        _isProcessing = true;

        await cameraController.stop();
        final Barcode barcode = barcodeCapture.barcodes.first;
        final String code = barcode.rawValue ?? '';

        try {
          if (code.isNotEmpty) {
            print('QR Code Detected: $code');

            final uri = Uri.parse(code);
            final type = uri.host;
            final secret = uri.queryParameters['secret'] ?? '';
            final issuer = uri.queryParameters['issuer'] ?? '';
            final label = uri.pathSegments.first;
            final nickname = label.contains(':') ? label.split(':')[1] : label;

            print('label = $label');
            print('nickname = $nickname');

            if (secret.isEmpty || issuer.isEmpty || nickname.isEmpty) {
              if (mounted) {
                ErrorDialog().showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.add_error,
                  AppLocalizations.of(context)!.add_error_message,
                );
              }
              _isProcessing = false;
              await cameraController.start();
              return;
            }

            if (type != 'totp' && type != 'hotp') {
              if (mounted) {
                ErrorDialog().showErrorDialog(
                  context,
                  AppLocalizations.of(context)!.add_error,
                  AppLocalizations.of(context)!.add_error_message,
                );
              }
              await cameraController.start();
              _isProcessing = false;
              return;
            }

            final newToken = AuthToken(
              service: issuer,
              account: nickname,
              secret: secret,
              type: type == "totp" ? AuthTokenType.totp : AuthTokenType.hotp,
              counter: type == "totp" ? null : 1,
            );

            BlocProvider.of<TokensBloc>(context).add(AddToken(newToken));

            final currentState = BlocProvider.of<TokensBloc>(context).state;
            final allTokens = currentState.allTokens;

            User? user = FirebaseAuth.instance.currentUser;
            final storage = FlutterSecureStorage();
            String? idToken = await storage.read(key: SecureStorageKeys.idToken);

            if (user != null && idToken != null) {
              if (await SynchronizeRepository().isSynchronizing(user.uid)) {
                await TokenService().saveTokensForUser(user.uid, allTokens);
              }

              if (mounted) {
                Navigator.pop(context);
              }
            }
          }
        } catch (ex) {
          if (mounted) {
            ErrorDialog().showErrorDialog(
              context,
              AppLocalizations.of(context)!.add_error,
              AppLocalizations.of(context)!.add_error_message,
            );
          }
          await cameraController.start();
        } finally {
          _isProcessing = false;
        }
      },
    );
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      final result = await cameraController.analyzeImage(image.path);
      if (result!.barcodes.isNotEmpty) {
        onDetectFromImage(result);
      } else {
        if (mounted) {
          ErrorDialog().showErrorDialog(
            context,
            AppLocalizations.of(context)!.add_error,
            AppLocalizations.of(context)!.add_error_message,
          );
        }
      }
    }
  }

  void onDetectFromImage(BarcodeCapture barcodeCapture) async {
    if (_isProcessing) return;
    _isProcessing = true;

    final Barcode barcode = barcodeCapture.barcodes.first;
    final String code = barcode.rawValue ?? '';

    try {
      if (code.isNotEmpty) {
        print('QR Code from Image: $code');

        final uri = Uri.parse(code);
        final type = uri.host;
        final secret = uri.queryParameters['secret'] ?? '';
        final issuer = uri.queryParameters['issuer'] ?? '';
        final label = uri.pathSegments.first;
        final nickname = label.contains(':') ? label.split(':')[1] : label;

        if (secret.isEmpty || issuer.isEmpty || nickname.isEmpty) {
          if (mounted) {
            ErrorDialog().showErrorDialog(
              context,
              AppLocalizations.of(context)!.add_error,
              AppLocalizations.of(context)!.add_error_message,
            );
          }
          _isProcessing = false;
          return;
        }

        if (type != 'totp' && type != 'hotp') {
          if (mounted) {
            ErrorDialog().showErrorDialog(
              context,
              AppLocalizations.of(context)!.add_error,
              AppLocalizations.of(context)!.add_error_message,
            );
          }
          _isProcessing = false;
          return;
        }

        final newToken = AuthToken(
          service: issuer,
          account: nickname,
          secret: secret,
          type: type == "totp" ? AuthTokenType.totp : AuthTokenType.hotp,
          counter: type == "totp" ? null : 1,
        );

        BlocProvider.of<TokensBloc>(context).add(AddToken(newToken));

        final currentState = BlocProvider.of<TokensBloc>(context).state;
        final allTokens = currentState.allTokens;

        User? user = FirebaseAuth.instance.currentUser;
        final storage = FlutterSecureStorage();
        String? idToken = await storage.read(key: SecureStorageKeys.idToken);

        if (user != null && idToken != null) {
          if (await SynchronizeRepository().isSynchronizing(user.uid)) {
            await TokenService().saveTokensForUser(user.uid, allTokens);
          }

          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    } catch (ex) {
      if (mounted) {
        ErrorDialog().showErrorDialog(
          context,
          AppLocalizations.of(context)!.add_error,
          AppLocalizations.of(context)!.add_error_message,
        );
      }
    } finally {
      _isProcessing = false;
    }
  }

  Widget _buildQRScannerOverlay() {
    final scannerSize = MediaQuery.of(context).size.width * 0.7;

    final screenSize = MediaQuery.of(context).size;
    final scannerLeft = (screenSize.width - scannerSize) / 2;
    final scannerTop = (screenSize.height - scannerSize) / 2 - 118;

    return Stack(
      children: [
        _buildOverlayWithHole(scannerSize, scannerLeft, scannerTop),
        Center(
          child: Container(
            width: scannerSize,
            height: scannerSize,
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: 0,
                  top: 0,
                  child: _buildCorner(),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Transform.rotate(
                    angle: 90 * 3.14159 / 180,
                    child: _buildCorner(),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: 180 * 3.14159 / 180,
                    child: _buildCorner(),
                  ),
                ),
                Positioned(
                  left: 0,
                  bottom: 0,
                  child: Transform.rotate(
                    angle: 270 * 3.14159 / 180,
                    child: _buildCorner(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOverlayWithHole(double scannerSize, double left, double top) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: top,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: top,
          left: 0,
          width: left,
          height: scannerSize,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: top,
          right: 0,
          width: left,
          height: scannerSize,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
        Positioned(
          top: top + scannerSize,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            color: Colors.black.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildCorner() {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.white, width: 3),
          left: BorderSide(color: Colors.white, width: 3),
        ),
      ),
    );
  }
}
