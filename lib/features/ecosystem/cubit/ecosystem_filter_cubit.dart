import 'package:flutter_bloc/flutter_bloc.dart';

/// Which app family the chip cloud highlights.
enum EcosystemFilter { all, erp, serviceCenter }

/// Selected ecosystem filter. Provided by the page (not the section) so the
/// choice survives the section scrolling out of the list.
final class EcosystemFilterCubit extends Cubit<EcosystemFilter> {
  EcosystemFilterCubit() : super(EcosystemFilter.all);

  void select(EcosystemFilter filter) {
    if (filter == state) return;
    emit(filter);
  }
}
