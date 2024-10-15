enum Flag {
  help(abbr: 'h'),
  verbose(abbr: 'v'),
  version(),
  config();

  const Flag({this.abbr});
  final String? abbr;
}
