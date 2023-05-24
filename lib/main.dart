import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'providers/great_places.dart';
import 'screens/place_detail_screen.dart';
import 'screens/place_form_screen.dart';
import 'screens/places_list_screen.dart';
import 'utils/app_routes.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.indigo,
        primary: Colors.indigo,
        secondary: Colors.amber,
      ),
    );

    return ChangeNotifierProvider(
      create: (ctx) => GreatPlaces(),
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: theme.copyWith(
            progressIndicatorTheme: ProgressIndicatorThemeData(
              color: theme.colorScheme.secondary,
            ),
          ),
          home: const PlacesListScreen(),
          routes: {
            AppRoutes.PLACE_FORM: (ctx) => const PlaceFormScreen(),
            AppRoutes.PLACE_DETAIL: (ctx) => const PlaceDetailScreen(),
          }),
    );
  }
}
