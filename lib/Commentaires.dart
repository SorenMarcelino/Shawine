class Commentaires {
  final String added_by;
  final String vin_commente_id;
  //final DateTime date;
  final String commentaire;

  const Commentaires({
    required this.added_by,
    required this.vin_commente_id,
    //required this.date,
    required this.commentaire,
  });

  static Commentaires fromJson(json) => Commentaires(
    added_by: json['added_by'],
    vin_commente_id: json['vin_commente_id'],
    //date: json['date'],
    commentaire: json['commentaire'],
  );
}
