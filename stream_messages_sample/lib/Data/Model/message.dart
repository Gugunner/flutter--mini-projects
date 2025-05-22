class Message {
  final int id;
  final String primaryText;
  final String secondaryText;

  const Message({
    required this.id,
    required this.primaryText,
    required this.secondaryText,
  });

  Message copyWith({int? id, String? primaryText, String? secondaryText}) {
    return Message(
      id: id ?? this.id,
      primaryText: primaryText ?? this.primaryText,
      secondaryText: secondaryText ?? this.secondaryText,
    );
  }
}
