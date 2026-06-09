import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/pages/auth_gate.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'core/services/hive_service.dart';
import 'core/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Hive.initFlutter();

  await HiveService.initHive();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

  final supabase = Supabase.instance.client;

  // Initialize Cloud Synchronization Listener
  SyncService().initAuthListener();

  // Trigger sync at startup if user is logged in
  if (supabase.auth.currentUser != null) {
    await SyncService.fetchAndSyncFromCloud();
  }

  final response = await supabase.rpc('get_tables');

  print(response);

  runApp(const ProviderScope(child: GameCatalogApp()));
}

class GameCatalogApp extends StatelessWidget {
  const GameCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ArcadiaX',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AuthGate(),
    );
  }
}
