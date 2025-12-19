import 'package:flutter_dotenv/flutter_dotenv.dart';

// ignore: non_constant_identifier_names
final String API_HOST = dotenv.env['API_HOST'] ?? "";
