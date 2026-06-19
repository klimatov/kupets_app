abstract final class MenuCategories {
  static const all = 'all';

  static const labels = <String, String>{
    all: 'Все',
    'beer_own': 'Варим сами',
    'beer_bottle': 'Бутылочное',
    'ribs': 'Рёбрышки',
    'snacks': 'Закуски',
    'burgers': 'Бургеры',
    'grill': 'Горячее',
  };

  static List<String> get filterKeys => labels.keys.toList();
}
