class Company {
  static final List<String> states = [
    'Yokesen Teknologi Indonesia',
    'Unilever Indonesia',
    'Wings Production Indonesia',
    'Sawit Indonesia'
  ];
  static final List<String> kode = ['YTI1', 'UNII', 'WPI', 'SWTI'];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(states);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
