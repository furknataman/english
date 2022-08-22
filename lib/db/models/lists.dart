const String tableNameLists = "lists";

class ListsTableFields {
  static final List<String> values = [id, name];
  static const String id = 'id';
  static const String name = 'name';
}

class Lists {
  final int? id;
  final String? name;

  const Lists({this.id, this.name});
  Lists copy({int? id, String? name}) {
    return Lists(id: id ?? this.id, name: name ?? this.name);
  }

  Map<String, Object?> toJson() => {ListsTableFields.id: id, ListsTableFields.name: name};
  static Lists fromJson(Map<String, Object?> json) => Lists(
        id: json[ListsTableFields.id] as int?,
        name: json[ListsTableFields.name] as String?,
      );
}
