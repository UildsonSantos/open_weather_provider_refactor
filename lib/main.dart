import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:http/http.dart' as http;
import 'package:open_weather_provider_refactor/pages/pages.dart';
import 'package:open_weather_provider_refactor/providers/providers.dart';
import 'package:open_weather_provider_refactor/providers/theme/theme_provider.dart';
import 'package:open_weather_provider_refactor/repositories/repositories.dart';
import 'package:open_weather_provider_refactor/services/services.dart';
import 'package:provider/provider.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<WeatherRepository>(
          create: (context) => WeatherRepository(
            weatherApiServices: WeatherApiServices(
              httpClient: http.Client(),
            ),
          ),
        ),
        StateNotifierProvider<WeatherProvider, WeatherState>(
          create: (context) => WeatherProvider(),
        ),
        StateNotifierProvider<TempSettingsProvider, TempSettingsState>(
          create: (context) => TempSettingsProvider(),
        ),
        StateNotifierProvider<ThemeProvider, ThemeState>(
          create: (context) => ThemeProvider(),
        ),
        
      ],
      builder: (context, _) => MaterialApp(
        title: 'Open Weather',
        debugShowCheckedModeBanner: false,
        theme: context.watch<ThemeState>().appTheme == AppTheme.light
            ? ThemeData.light()
            : ThemeData.dark(),
        home: const HomePage(),
      ),
    );
  }
}
