import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';
import 'services/supabase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ytdjxtjzzpdliaamrmjx.supabase.co', //project URL
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl0ZGp4dGp6enBkbGlhYW1ybWp4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDkwNDMzNzIsImV4cCI6MjA2NDYxOTM3Mn0.jy0abB0nAMvRF8RpLez62UJrVgx3LaALEispXfVfFgE', //anon public key kamu
  );
  final supabase = Supabase.instance.client;
  final service = SupabaseService(supabase);

  runApp(MyApp(service: service));
}

class MyApp extends StatelessWidget {
  final SupabaseService service;

  const MyApp({super.key, required this.service});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Todo App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(service: service),
    );
  }
}
