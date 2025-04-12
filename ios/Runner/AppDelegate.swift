import Flutter
import UIKit
import FirebaseCore

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(preventScreenshot),
        name: UIApplication.userDidTakeScreenshotNotification,
        object: nil
    )

    NotificationCenter.default.addObserver(
        self,
        selector: #selector(screenCaptureStatusChanged),
        name: UIScreen.capturedDidChangeNotification,
        object: nil
    )

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  @objc func preventScreenshot() {
    let window = UIApplication.shared.windows.first
    window?.isHidden = true
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        window?.isHidden = false
    }

    print("Screenshot was taken!")

    NotificationCenter.default.post(name: NSNotification.Name("SCREENSHOT_TAKEN"), object: nil)
  }

  @objc func screenCaptureStatusChanged() {
    if UIScreen.main.isCaptured {
      print("Screen recording detected")

      NotificationCenter.default.post(name: NSNotification.Name("SCREEN_RECORDING_STARTED"), object: nil)
    } else {
      print("Screen recording stopped")
    }
  }
}