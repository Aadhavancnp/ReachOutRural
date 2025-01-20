import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:reach_out_rural/app/bloc/app_bloc.dart';
import 'package:reach_out_rural/services/api/api_service.dart';
import 'package:reach_out_rural/services/api/dio_client.dart';
import 'package:reach_out_rural/repository/auth/auth_repository.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/services/db/shared_pref_helper.dart';
import 'package:reach_out_rural/repository/storage/storage_repository.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/routes/routes.dart';
import 'package:reach_out_rural/themes/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App(
      {super.key,
      required this.prefs,
      required this.dio,
      required this.locale});

  final SharedPreferencesAsync prefs;
  final DioClient dio;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SharedPreferencesHelper>(
          create: (context) => SharedPreferencesHelper(prefs),
        ),
        RepositoryProvider<ApiService>(
          create: (context) => ApiService(dio),
        ),
        RepositoryProvider<AuthenticationRepository>(
          create: (context) => AuthenticationRepository(
            context.read<ApiService>(),
            context.read<SharedPreferencesHelper>(),
          ),
        ),
        RepositoryProvider<UserPatientRepository>(
          create: (context) =>
              UserPatientRepository(context.read<SharedPreferencesHelper>()),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(
            context.read<SharedPreferencesHelper>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
                authenticationRepository:
                    context.read<AuthenticationRepository>(),
                userPatientRepository: context.read<UserPatientRepository>())
              ..add(AuthenticationSubscriptionRequested()),
          ),
          BlocProvider(
            create: (context) => AppBloc(
              locale: locale,
              storageRepository: context.read<StorageRepository>(),
            ),
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  MaterialTheme theme = const MaterialTheme("OpenSans");

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppBloc, AppState>(
      buildWhen: (previous, current) {
        return (previous.locale != current.locale);
      },
      builder: (context, state) {
        final goRouter = GoRouterConfig.getRouter(context);
        return MaterialApp.router(
          title: 'Reach Out Rural',
          debugShowCheckedModeBanner: false,
          theme: theme.light(),
          darkTheme: theme.dark(),
          themeMode: ThemeMode.system,
          routerConfig: goRouter,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: state.locale,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
