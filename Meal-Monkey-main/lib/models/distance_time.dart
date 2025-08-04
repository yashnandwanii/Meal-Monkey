class DistanceTime {
  final double distance;
  final double time;
  final double price;

  DistanceTime({
    required this.price,
    required this.distance,
    required this.time,
  });

  @override
  String toString() {
    return 'DistanceTime(distance: $distance km, time: $time min)';
  }
}
