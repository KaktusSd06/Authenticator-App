import 'dart:convert';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import '../../../data/models/auth_token.dart';
import '../../../data/models/service.dart';
import 'add_token_event.dart';
import 'add_token_state.dart';

class AddTokenBloc extends Bloc<AddTokenEvent, AddTokenState> {
  final Map<String, List<Service>> serviceCategories = {
    "General": [
      Service(name: "Banking and finance", iconPath: "assets/icons/banking.svg"),
      Service(name: "Website", iconPath: "assets/icons/website.svg"),
      Service(name: "Mail", iconPath: "assets/icons/mail.svg"),
      Service(name: "Social", iconPath: "assets/icons/social.svg"),
    ],
    "Services": [
      Service(name: "Google", iconPath: "assets/icons/google.svg"),
      Service(name: "Instagram", iconPath: "assets/icons/instagram.svg"),
      Service(name: "Facebook", iconPath: "assets/icons/facebook.svg"),
      Service(name: "LinkedIn", iconPath: "assets/icons/linkedin.svg"),
      Service(name: "Microsoft", iconPath: "assets/icons/microsoft.svg"),
      Service(name: "Discord", iconPath: "assets/icons/discord.svg"),
      Service(name: "Netflix", iconPath: "assets/icons/netflix.svg"),
    ],
  };

  AddTokenBloc() : super(const AddTokenInitial()) {
    on<ServiceSelected>(_onServiceSelected);
    on<OtpTypeSelected>(_onOtpTypeSelected);
    on<AddToken>(_onAddToken);
  }

  void _onServiceSelected(ServiceSelected event, Emitter<AddTokenState> emit) {
    emit(state.copyWith(serviceName: event.serviceName));
  }

  void _onOtpTypeSelected(OtpTypeSelected event, Emitter<AddTokenState> emit) {
    emit(state.copyWith(otpType: event.otpType));
  }

  Future<void> _onAddToken(AddToken event, Emitter<AddTokenState> emit) async {
    // Проверяем валидность входных данных
    if (state.serviceName.isEmpty) {
      emit(AddTokenError(
        message: 'Выберите сервис',
        serviceName: state.serviceName,
        otpType: state.otpType,
      ));
      return;
    }

    if (event.account.isEmpty) {
      emit(AddTokenError(
        message: 'Введите аккаунт',
        serviceName: state.serviceName,
        otpType: state.otpType,
      ));
      return;
    }

    if (event.key.isEmpty) {
      emit(AddTokenError(
        message: 'Введите ключ',
        serviceName: state.serviceName,
        otpType: state.otpType,
      ));
      return;
    }

    emit(AddTokenLoading(
      serviceName: state.serviceName,
      otpType: state.otpType,
    ));

    try {
      final newToken = AuthToken(
          service: state.serviceName,
          account: event.account,
          secret: event.key,
          type: state.otpType == "Time-based" ? AuthTokenType.totp : AuthTokenType.hotp,
          counter: state.otpType == "Time-based" ? null : 1
      );

      final file = await _getUserInfoFile();

      List<AuthToken> tokens = [];

      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.isNotEmpty) {
          tokens = AuthToken.listFromJson(content);
        }
      }

      tokens.add(newToken);

      final jsonString = AuthToken.listToJson(tokens);
      await file.writeAsString(jsonString);

      emit(AddTokenSuccess(
        serviceName: state.serviceName,
        otpType: state.otpType,
      ));
    } catch (e) {
      emit(AddTokenError(
        message: 'Ошибка при добавлении токена: ${e.toString()}',
        serviceName: state.serviceName,
        otpType: state.otpType,
      ));
    }
  }

  Future<File> _getUserInfoFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_info.json');
  }
}