 class  DiscoverEntity{

  final String title;
  final String subtitle;
  final  String exploredText;
  final  String  image;
  final String? route;
  final String id;



  DiscoverEntity({
    required this.title,
    required this.subtitle,
    required this.exploredText,
    required this.image,
    this.route,
    required this.id
 });

 }