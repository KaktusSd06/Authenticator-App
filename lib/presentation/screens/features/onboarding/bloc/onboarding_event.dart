abstract class OnboardingEvent {}

class OnboardingStarted extends OnboardingEvent{}

class OnboardingPageChanged extends OnboardingEvent{
  final int page;
  OnboardingPageChanged(this.page);
}

class OnboardingNextPressed extends OnboardingEvent{}