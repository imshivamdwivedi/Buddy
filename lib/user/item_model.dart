class ItemModel {
  String text;
  bool isSelected;

  ItemModel({
    required this.text,
    this.isSelected = false,
  });

  factory ItemModel.fromJson(Map<String, dynamic> map) {
    return ItemModel(
      text: map['text'],
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
      };
}
