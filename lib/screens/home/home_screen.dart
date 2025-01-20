import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:reach_out_rural/app/bloc/app_bloc.dart';
import 'package:reach_out_rural/constants/constants.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/repository/user/user_patient_repository.dart';
import 'package:reach_out_rural/screens/chatbot/cubit/chat_cubit.dart';
import 'package:reach_out_rural/screens/dashboard/cubit/dashboard_cubit.dart';
import 'package:reach_out_rural/screens/home/cubit/home_cubit.dart';
import '../../services/api/api_service.dart';
import '../../../repository/storage/storage_repository.dart';
import 'package:reach_out_rural/screens/chatbot/chat_bot_screen.dart';
import 'package:reach_out_rural/screens/community/community_screen.dart';
import 'package:reach_out_rural/screens/dashboard/dashboard_screen.dart';
import 'package:reach_out_rural/screens/scanner/scanner_screen.dart';
import 'package:reach_out_rural/utils/size_config.dart';
import 'package:reach_out_rural/widgets/custom_bottom_navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    return BlocProvider(
      create: (context) => HomeCubit(
        apiService: context.read<ApiService>(),
        storageRepository: context.read<StorageRepository>(),
        userPatientRepository: context.read<UserPatientRepository>(),
        authBloc: context.read<AuthBloc>(),
      )..initializeApp(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (previous, current) =>
            (current.nextPath != null &&
                current.nextPath != previous.nextPath) ||
            (current.locale != null && current.locale != previous.locale) ||
            current.permissionEvent != previous.permissionEvent,
        listener: (context, state) {
          if (state.permissionEvent is ShowPermissionDeniedDialog) {
            final event = state.permissionEvent as ShowPermissionDeniedDialog;
            showPermanentlyDeniedDialog(
                context, event.permissionName, event.permissionType);
            context.read<HomeCubit>().clearPermissionEvent();
          }
          if (state.permissionEvent != null) {
            _showPermissionDialog(context, state.permissionEvent!, () async {
              if (state is ShowLocationServiceDisabledDialog) {
                await Geolocator.openLocationSettings();
              } else {
                await openAppSettings();
              }
              if (!context.mounted) return;
              context.read<HomeCubit>().retryLocationInitialization();
            }, () {
              context.read<HomeCubit>().retryLocationInitialization();
            });
          }

          if (state.nextPath != null && state.nextPath!.isNotEmpty) {
            GoRouter.of(context).push(state.nextPath!);
          }

          if (state.locale != null) {
            context.read<AppBloc>().add(LanguageChanged(locale: state.locale!));
          }
        },
        builder: (context, state) {
          return Scaffold(
            body: Stack(
              children: [
                _buildCurrentScreen(context, state.currentIndex),
                if (state.recognizedText.isNotEmpty)
                  _buildRecognizedTextOverlay(state.recognizedText),
              ],
            ),
            bottomNavigationBar: CustomBottomNavbar(
              isListening: state.isListening,
              currentIndex: state.currentIndex,
              onPressed: (index) =>
                  context.read<HomeCubit>().changeIndex(index),
              onCaptureVoice: () => context.read<HomeCubit>().toggleListening(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrentScreen(BuildContext context, int index) {
    final List<Widget> screens = [
      BlocProvider(
        create: (context) => DashboardCubit(
          apiService: context.read<ApiService>(),
          storageRepository: context.read<StorageRepository>(),
          userPatientRepository: context.read<UserPatientRepository>(),
        )..loadDashboardData(),
        child: const DashboardScreen(),
      ),
      BlocProvider(
        create: (context) => ChatCubit(
            homeCubit: context.read<HomeCubit>(),
            api: context.read<ApiService>(),
            storageRepository: context.read<StorageRepository>(),
            userPatientRepository: context.read<UserPatientRepository>())
          ..init(),
        child: const ChatBotScreen(),
      ),
      const ScannerScreen(),
      const CommunityScreen(),
    ];
    return screens[index];
  }

  Widget _buildRecognizedTextOverlay(String text) {
    return Positioned(
      bottom: 45,
      left: 0,
      right: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(text,
                  style: TextStyle(
                      color: kBlackColor,
                      fontSize: SizeConfig.getProportionateTextSize(20))),
            ),
          ],
        ),
      ),
    );
  }

  void showPermanentlyDeniedDialog(BuildContext context, String permissionName,
      Permission permissionType) async {
    final req = await permissionType.request();
    if (req.isPermanentlyDenied) {
      await openAppSettings();
      return;
    }
    if (!context.mounted) return;
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Permission Denied'),
          content: Text(
            'Please allow $permissionName permission to continue using the app.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                final req = await permissionType.request();
                if (req.isPermanentlyDenied) {
                  await openAppSettings();
                  return;
                }
                if (!context.mounted) return;
                context.pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showPermissionDialog(BuildContext context, PermissionEvent event,
      VoidCallback onRetry, VoidCallback onSettings) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            title: Text(_getDialogTitle(event)),
            content: Text(_getDialogContent(event)),
            actions: <Widget>[
              TextButton(
                onPressed: onSettings,
                child: const Text('Settings'),
              ),
              TextButton(
                onPressed: onRetry,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getDialogTitle(PermissionEvent event) {
    if (event is ShowLocationServiceDisabledDialog) {
      return 'Location Services Disabled';
    } else if (event is ShowLocationPermissionDeniedDialog) {
      return 'Location Permission Denied';
    } else if (event is ShowLocationPermissionPermanentlyDeniedDialog) {
      return 'Location Permission Permanently Denied';
    } else if (event is ShowLocationErrorDialog) {
      return 'Location Error';
    }
    return 'Permission Required';
  }

  String _getDialogContent(PermissionEvent event) {
    if (event is ShowLocationServiceDisabledDialog) {
      return 'Please enable location services to use this feature.';
    } else if (event is ShowLocationPermissionDeniedDialog) {
      return 'This app needs location permission to function properly. Please grant the permission.';
    } else if (event is ShowLocationPermissionPermanentlyDeniedDialog) {
      return 'Location permission is permanently denied. Please enable it in app settings.';
    } else if (event is ShowLocationErrorDialog) {
      return 'An error occurred while accessing your location: ${event.error}';
    }
    return 'This app needs certain permissions to function properly.';
  }
}
