class AppData {
  AppData({
    this.id,
    this.latitude = '',
    this.longitud = '',
    this.dustbox = true,
    this.vendingmachine = true,
  });

  final String? id;
  final String latitude;
  final String longitud;
  final bool dustbox;
  final bool vendingmachine;

  factory AppData.fromDoc(String id, Map<String, dynamic> doc) => AppData(
    id: id,
    latitude: doc['latitude'],
    longitud: doc['longitud'],
    dustbox: doc['dustbox'],
    vendingmachine: doc['vendingmachine']
  );
}
