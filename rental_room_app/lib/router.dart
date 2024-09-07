import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:rental_room_app/Views/all_room_screen.dart';
import 'package:rental_room_app/Views/change_password_screen.dart';
import 'package:rental_room_app/Views/edit_form_screen.dart';
import 'package:rental_room_app/Views/create_room_screen.dart';
import 'package:rental_room_app/Views/edit_profile_screen.dart';
import 'package:rental_room_app/Views/edit_room_screen.dart';
import 'package:rental_room_app/Views/home_screen.dart';
import 'package:rental_room_app/Views/list_notification_screen.dart';
import 'package:rental_room_app/Views/login_screen.dart';
import 'package:rental_room_app/Views/no_internet_page.dart';
import 'package:rental_room_app/Views/notification_screen.dart';
import 'package:rental_room_app/Views/pincode_screen.dart';
import 'package:rental_room_app/Views/receipt_detail_screen.dart';
import 'package:rental_room_app/Views/register_form_screen.dart';
import 'package:rental_room_app/Views/rental_form_screen.dart';
import 'package:rental_room_app/Views/report_screen.dart';
import 'package:rental_room_app/Views/setting_screen.dart';
import 'package:rental_room_app/Views/signup_screen.dart';
import 'package:rental_room_app/Views/your_room_screen.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      redirect: (BuildContext context, GoRouterState state) {
        if (FirebaseAuth.instance.currentUser != null) {
          return '/home';
        } else {
          return '/log_in';
        }
      },
    ),
    GoRoute(
        path: '/log_in',
        name: 'log_in',
        builder: (context, state) => const LoginScreen(key: Key('log_in')),
        routes: [
          GoRoute(
              path: 'sign_up',
              name: 'sign_up',
              builder: (context, state) =>
                  const SignupScreen(key: Key('sign_up')),
              routes: [
                GoRoute(
                    path: 'pincode/:email',
                    name: 'pincode',
                    builder: (context, state) => PincodeScreen(
                        key: const Key('pincode'),
                        email: state.pathParameters['email']),
                    routes: [
                      GoRoute(
                        path: 'register_form',
                        name: 'register_form',
                        builder: (context, state) => RegisterFormScreen(
                            key: const Key('register_form'),
                            email: state.pathParameters['email']),
                      )
                    ])
              ]),
        ]),
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(key: Key('home')),
      routes: [
        GoRoute(
          path: 'all_room',
          name: 'all_room',
          builder: (context, state) => const AllRoom(key: Key('all_room')),
        ),
        GoRoute(
          path: 'create_room',
          name: 'create_room',
          builder: (context, state) =>
              const CreateRoomScreen(key: Key('create_room')),
        ),
      ],
    ),
    GoRoute(
      path: '/your_room',
      name: 'your_room',
      builder: (context, state) => const YourRoomScreen(key: Key('your_room')),
    ),
    GoRoute(
      path: '/notification_list',
      name: 'notification_list',
      builder: (context, state) =>
          const ListNotificationScreen(key: Key('notification_list')),
    ),
    GoRoute(
      path: '/report',
      name: 'report',
      builder: (context, state) => const ReportScreen(key: Key('report')),
    ),
    GoRoute(
      path: '/setting',
      name: 'setting',
      builder: (context, state) => const SettingScreen(key: Key('setting')),
      routes: [
        GoRoute(
          path: 'edit_profile',
          name: 'edit_profile',
          builder: (context, state) =>
              const EditProfileScreen(key: Key('edit_profile')),
          routes: [
            GoRoute(
              path: 'change_password',
              name: 'change_password',
              builder: (context, state) =>
                  const ChangePasswordScreen(key: Key('change_password')),
            ),
          ],
        ),
        GoRoute(
          path: 'notification',
          name: 'notification',
          builder: (context, state) =>
              const NotificationScreen(key: Key('notification')),
        ),
      ],
    ),
    GoRoute(
      path: '/nointernet',
      name: 'nointernet',
      builder: (context, state) => const NoInternetPage(key: Key('nointernet')),
    ),
  ],
);
