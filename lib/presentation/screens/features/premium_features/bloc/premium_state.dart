sealed class PremiumFeaturesState {
  final bool isAuthenticated;
  final bool isSyncEnabled;
  final bool isPremium;
  final bool isSyncing;
  final String? errorMessage;

  const PremiumFeaturesState({
    this.isAuthenticated = false,
    this.isSyncEnabled = false,
    this.isPremium = false,
    this.isSyncing = false,
    this.errorMessage,
  });

  PremiumFeaturesState copyWith({
    bool? isAuthenticated,
    bool? isSyncEnabled,
    bool? isPremium,
    bool? isSyncing,
    String? errorMessage,
  });
}

class PremiumFeaturesInitial extends PremiumFeaturesState {
  const PremiumFeaturesInitial() : super();

  @override
  PremiumFeaturesState copyWith({
    bool? isAuthenticated,
    bool? isSyncEnabled,
    bool? isPremium,
    bool? isSyncing,
    String? errorMessage,
  }) {
    return PremiumFeaturesInitial();
  }
}

class PremiumFeaturesLoading extends PremiumFeaturesState {
  const PremiumFeaturesLoading() : super();

  @override
  PremiumFeaturesState copyWith({
    bool? isAuthenticated,
    bool? isSyncEnabled,
    bool? isPremium,
    bool? isSyncing,
    String? errorMessage,
  }) {
    return PremiumFeaturesLoading();
  }
}

class PremiumFeaturesLoaded extends PremiumFeaturesState {
  const PremiumFeaturesLoaded({
    required super.isAuthenticated,
    required super.isSyncEnabled,
    required super.isPremium,
    super.isSyncing,
    super.errorMessage,
  });

  @override
  PremiumFeaturesState copyWith({
    bool? isAuthenticated,
    bool? isSyncEnabled,
    bool? isPremium,
    bool? isSyncing,
    String? errorMessage,
  }) {
    return PremiumFeaturesLoaded(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSyncEnabled: isSyncEnabled ?? this.isSyncEnabled,
      isPremium: isPremium ?? this.isPremium,
      isSyncing: isSyncing ?? super.isSyncing,
      errorMessage: errorMessage ?? super.errorMessage,
    );
  }
}

class PremiumFeaturesError extends PremiumFeaturesState {
  const PremiumFeaturesError(String message, {
    super.isAuthenticated,
    super.isSyncEnabled,
    super.isPremium,
    super.isSyncing,
  }) : super(errorMessage: message);

  @override
  PremiumFeaturesState copyWith({
    bool? isAuthenticated,
    bool? isSyncEnabled,
    bool? isPremium,
    bool? isSyncing,
    String? errorMessage,
  }) {
    return PremiumFeaturesError(
      errorMessage ?? this.errorMessage!,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isSyncEnabled: isSyncEnabled ?? this.isSyncEnabled,
      isPremium: isPremium ?? this.isPremium,
      isSyncing: isSyncing ?? super.isSyncing,
    );
  }
}