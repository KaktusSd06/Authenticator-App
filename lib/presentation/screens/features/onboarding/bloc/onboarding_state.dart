class OnboardingState {
  final int currentPage;
  final double progress;
  final bool navigateToPaywall;
  final bool isFirstAppLaunch;

  OnboardingState({
    required this.currentPage,
    required this.progress,
    this.navigateToPaywall = false,
    required this.isFirstAppLaunch,
  });

  factory OnboardingState.initial({required bool isFirstAppLaunch}) =>
      OnboardingState(
        currentPage: 0,
        progress: 0.0,
        isFirstAppLaunch: isFirstAppLaunch,
      );

  OnboardingState copyWith({
    int? currentPage,
    double? progress,
    bool? navigateToPaywall,
    bool? isFirstAppLaunch,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      progress: progress ?? this.progress,
      navigateToPaywall: navigateToPaywall ?? false,
      isFirstAppLaunch: isFirstAppLaunch ?? this.isFirstAppLaunch,
    );
  }
}