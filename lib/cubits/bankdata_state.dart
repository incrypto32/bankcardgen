part of 'bankdata_cubit.dart';

@immutable
abstract class BankdataState {}

class BankdataInitial extends BankdataState {}

class BankDataError extends BankdataState {
  final String message;
  BankDataError(this.message);
}

class CountriesData extends BankdataState {
  final List<String> countries;
  CountriesData(this.countries);
}

class BankData extends BankdataState {
  final List<Bank> banks;
  BankData(this.banks);
}
