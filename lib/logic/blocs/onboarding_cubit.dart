import 'package:bloc/bloc.dart';

class OnBoardingCubit extends Cubit<int> {
  OnBoardingCubit() : super(0);

  void updatePage(int pageIndex) {
    emit(pageIndex);
  }
}
