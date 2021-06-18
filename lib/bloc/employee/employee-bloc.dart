import 'package:zukses_app_1/API/user-data-services.dart';
import 'package:zukses_app_1/bloc/employee/employee-event.dart';
import 'package:zukses_app_1/bloc/employee/employee-state.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  StreamSubscription _subscription;

  final UserDataServiceHTTP _userDataService = UserDataServiceHTTP();

  EmployeeBloc() : super(null);

  // Bloc for loadd all employee
  Stream<EmployeeState> mapAllEmployee() async* {
    yield EmployeeStateLoading();
    // return list user model
    var res = await _userDataService.fetchEmployeeData();
    // return checkbox handler
    List<bool> bools = [];

    // directly throw into success load or fail load
    if (res != null) {
      if (res.length > 0) {
        for (var i = 0; i < res.length; i++) {
          bools.add(false);
        }
        print('EMPLOYEE STATE GET ALL EMPLOYEE');
        yield EmployeeStateSuccessLoad(employees: res, checklist: bools);
      } else {
        yield EmployeeStateFailLoad();
      }
    } else {
      yield EmployeeStateFailLoad();
    }
  }

  Stream<EmployeeState> mapUpdatingEmployeeState(
      EmployeeEventDidUpdated event) async* {
    yield EmployeeStateSuccessLoad(employees: event.employee);
  }

  @override
  Stream<EmployeeState> mapEventToState(EmployeeEvent event) async* {
    if (event is LoadAllEmployeeEvent) {
      yield* mapAllEmployee();
    } else if (event is EmployeeEventDidUpdated) {
      yield* mapUpdatingEmployeeState(event);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
