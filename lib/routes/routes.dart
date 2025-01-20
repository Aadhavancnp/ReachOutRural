import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:reach_out_rural/models/community.dart';
import 'package:reach_out_rural/models/doctor.dart';
import 'package:reach_out_rural/models/hospital.dart';
import 'package:reach_out_rural/repository/auth/auth_repository.dart';
import 'package:reach_out_rural/repository/auth/bloc/auth_bloc.dart';
import 'package:reach_out_rural/screens/age/age_screen.dart';
import 'package:reach_out_rural/screens/bloodgroup/blood_group_screen.dart';
import 'package:reach_out_rural/screens/book-appointment/doctor_appointment.dart';
import 'package:reach_out_rural/screens/chatbot/chat_bot_screen.dart';
import 'package:reach_out_rural/screens/community/specialized_community.dart';
import 'package:reach_out_rural/screens/dashboard/dashboard_screen.dart';
import 'package:reach_out_rural/screens/diagnosis/diagnosis_screen.dart';
import 'package:reach_out_rural/screens/doctor/doctor_info_screen.dart';
import 'package:reach_out_rural/screens/error/error_screen.dart';
import 'package:reach_out_rural/screens/gender/gender_screen.dart';
import 'package:reach_out_rural/screens/height/height_screen.dart';
import 'package:reach_out_rural/screens/home/home_screen.dart';
import 'package:reach_out_rural/screens/login/login_screen.dart';
import 'package:reach_out_rural/screens/onboarding/onboarding_screen.dart';
import 'package:reach_out_rural/screens/otp/otp_screen.dart';
import 'package:reach_out_rural/screens/prescription/prescription_screen.dart';
import 'package:reach_out_rural/screens/prescription/uploaded_prescription_screen.dart';
import 'package:reach_out_rural/screens/edit-profile/edit_profile_screen.dart';
import 'package:reach_out_rural/screens/profile/profile_screen.dart';
import 'package:reach_out_rural/screens/register/register_screen.dart';
import 'package:reach_out_rural/screens/scanner/display_screen.dart';
import 'package:reach_out_rural/screens/scanner/scanner_screen.dart';
import 'package:reach_out_rural/screens/search/search_hospitals_screen.dart';
import 'package:reach_out_rural/screens/search/search_screen.dart';
import 'package:reach_out_rural/screens/video/video_screen.dart';
import 'package:reach_out_rural/screens/voice/voice_screen.dart';
import 'package:reach_out_rural/screens/weight/weight_screen.dart';
import 'package:reach_out_rural/screens/splash/splash_screen.dart';

class GoRouterConfig {
  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/splash',
      refreshListenable: GoRouterRefreshStream(
        context.read<AuthBloc>().stream,
      ),
      redirect: (context, state) {
        final authState = context.read<AuthBloc>().state;
        final isAuthenticated =
            authState.status == AuthenticationStatus.authenticated;

        if (state.uri.path == '/splash') {
          return null;
        }

        if (state.uri.path == '/onboarding' && !isAuthenticated) {
          return null;
        }

        if (state.uri.path == '/onboarding' && isAuthenticated) {
          return '/';
        }

        if (isAuthenticated &&
            (state.uri.path == '/login' || state.uri.path == '/register')) {
          return '/';
        }

        if (!isAuthenticated &&
            state.uri.path != '/login' &&
            state.uri.path != '/register') {
          return '/login';
        }

        return null;
      },
      routes: [
        GoRoute(
            path: "/splash",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const SplashScreen())),
        GoRoute(
          path: "/onboarding",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
              context: context, state: state, child: const OnBoardingScreen()),
        ),
        GoRoute(
            path: "/login",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const LoginScreen())),
        GoRoute(
            path: "/register",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const RegisterScreen())),
        GoRoute(
            path: "/otp/:phoneNumber",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: OtpScreen(
                    phoneNumber: state.pathParameters['phoneNumber']!,
                    isLogin: (state.extra as Map<String, dynamic>)['isLogin']
                        as bool))),
        GoRoute(
            path: "/age",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const AgeScreen())),
        GoRoute(
            path: "/height",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const HeightScreen())),
        GoRoute(
            path: "/weight",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const WeightScreen())),
        GoRoute(
            path: "/gender",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const GenderScreen())),
        GoRoute(
            path: "/bloodgroup",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const BloodGroupScreen())),
        GoRoute(
            path: "/diagnosis",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const DiagnosisScreen())),
        GoRoute(
          path: '/',
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
              context: context, state: state, child: const HomeScreen()),
          routes: <RouteBase>[
            GoRoute(
              path: 'chat',
              builder: (context, state) => const ChatBotScreen(),
            ),
            GoRoute(
              path: 'scanner',
              builder: (context, state) => const ScannerScreen(),
            ),
            GoRoute(
              path: 'prescription',
              builder: (context, state) => const PrescriptionScreen(),
              routes: <RouteBase>[
                GoRoute(
                  path: "view",
                  builder: (context, state) => UploadedPrescriptionScreen(
                      tempFilePath: state.uri.queryParameters['fileUrl']!),
                ),
              ],
            ),
            GoRoute(
              path: 'dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        GoRoute(
            path: "/analysis",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: DisplayPictureScreen(
                  imagePath: state.extra as String,
                ))),
        GoRoute(
            path: "/voice",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const VoiceScreen())),
        GoRoute(
            path: "/video",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const VideoScreen())),
        GoRoute(
          path: "/doctor",
          pageBuilder: (context, state) => _buildPageWithDefaultTransition(
              context: context,
              state: state,
              child: DoctorInfoScreen(doctor: state.extra as Doctor)),
        ),
        GoRoute(
            path: "/search-doctor",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: SearchScreen(doctors: state.extra! as List<Doctor>))),
        GoRoute(
            path: "/search-hospitals",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: SearchHospitalsScreen(
                    hospitals: state.extra! as List<Hospital>))),
        GoRoute(
            path: "/specialized-community",
            pageBuilder: (context, state) {
              final dstate = state.extra as Map<String, dynamic>;
              final community = dstate["community"]! as Community;
              final doctors = dstate["doctors"]! as List<Doctor>;
              return _buildPageWithDefaultTransition(
                  context: context,
                  state: state,
                  child: SpecializedCommunity(
                      community: community, doctors: doctors));
            }),
        GoRoute(
            path: "/appointments",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const DoctorAppointmentScreen())),
        GoRoute(
            path: "/profile",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context, state: state, child: const ProfileScreen())),
        GoRoute(
            path: "/edit-profile",
            pageBuilder: (context, state) => _buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: const EditProfileScreen()))
      ],
      errorPageBuilder: (context, state) => _buildPageWithDefaultTransition(
          context: context,
          state: state,
          child: ErrorScreen(message: state.error.toString())),
    );
  }
}

CustomTransitionPage _buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(0.0, 1.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
