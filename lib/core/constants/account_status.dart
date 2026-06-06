enum AccountStatus {
  available("available"),
  limitHit("limit-hit");

  final String value;
  const AccountStatus(this.value);

  factory AccountStatus.fromString(String value) {
    return AccountStatus.values.firstWhere(
      (element) => element.value.toLowerCase() == value.toLowerCase(),
      orElse: () => AccountStatus.available,
    );
  }
}
