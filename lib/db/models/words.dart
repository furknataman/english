const String tableNameWord = "words";

class WordTableFields {
  static const List<String> values = [id, list_id, word_eng, word_tr, status];
  static const String id = "id";
  static const String list_id = "list_id";
  static const String word_eng = "word_eng";
  static const String word_tr = "word_tr";
  static const String status = "status";
}

class Word {
  final int? id;
  final int? list_id;
  final String? word_eng;
  final String? word_tr;
  final bool? status;

  const Word({this.id, this.list_id, this.word_eng, this.word_tr, this.status});

  Word copy({int? id, int? list_id, String? word_eng, String? word_tr, bool? status}) {
    return Word(
      id: id ?? this.id,
      list_id: list_id ?? this.list_id,
      word_eng: word_eng ?? this.word_eng,
      word_tr: word_tr ?? this.word_tr,
      status: status ?? this.status,
    );
  }

  Map<String, Object?> toJson() => {
        WordTableFields.id: id,
        WordTableFields.list_id: list_id,
        WordTableFields.word_eng: word_eng,
        WordTableFields.word_tr: word_tr,
        WordTableFields.status: status == true ? 1 : 0,
      };
  static Word fromJson(Map<String, Object?> json) => Word(
        id: json[WordTableFields.id] as int?,
        list_id: json[WordTableFields.list_id] as int?,
        word_eng: json[WordTableFields.word_eng] as String?,
        word_tr: json[WordTableFields.word_tr] as String?,
        status: json[WordTableFields.status] == 1,
      );
}
