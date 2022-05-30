import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'home_navigation_state.dart';

class HomeNavigationCubit extends Cubit<int> {
  HomeNavigationCubit() : super(0);

  void select(int index) => emit(index);
}
