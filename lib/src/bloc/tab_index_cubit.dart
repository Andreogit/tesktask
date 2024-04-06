import 'package:flutter_bloc/flutter_bloc.dart';

class TabIndexCubit extends Cubit<int> {
  TabIndexCubit() : super(0);

  void changeTab(int index) {
    emit(index);
  }
}