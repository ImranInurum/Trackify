class UpdateEntity {
  final String date;
  final String version;
  final List<String> titles;
  final List<String> descriptions;

  UpdateEntity({
    required this.date,
    required this.version,
    required this.titles,
    required this.descriptions,
});
}