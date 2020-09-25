List<String> names = ["국어","수학(가)","수학(나)", "영어" ,"한국사"];
List<int> year = [2020, 2019, 2018, 2017];
List<int> month = [4, 5, 6, 7, 8, 9, 10, 11];

class Object {
  String name;
  bool isExpanded;

  Object({this.name, this.isExpanded = false});
}

class Year {
  int year;
  bool isExpanded;

  Year({this.year, this.isExpanded = false});
}

List<Year> generateYears(List<int> list) {
  return List.generate(list.length, (index) {
    return Year(year: list[index]);
  });
}

List<Object> generateObjects(List<String> list) {
  return List.generate(list.length, (index) {
    return Object(name: list[index]);
  });
}
