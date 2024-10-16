enum Flag {
  help(abbr: 'h'),
  verbose(abbr: 'v'),
  version();

  const Flag({this.abbr});
  final String? abbr;
}
