import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:l2t_launch/l10n/l10n.dart';
import 'package:flow_builder/flow_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:authentication_repository/authentication_repository.dart';
import 'package:l2t_launch/authentication/authentication.dart';
import 'package:l2t_launch/login/login.dart';
import 'package:l2t_launch/navigation/cubit/navigation_cubit.dart';

import 'package:l2t_launch/home/home.dart';
import 'package:l2t_launch/sign_up/sign_up.dart';
import 'package:l2t_launch/user/cubit/user_info_cubit.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required this.authenticationRepository,
  }) : super(key: key);

  final AuthenticationRepository authenticationRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => AuthenticationBloc(
              authenticationRepository: authenticationRepository,
            ),
          ),
          BlocProvider(
            create: (_) => NavigationCubit(),
          )
        ],
        child: AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      lazy: false,
      create: (context) => UserInfoCubit(
        context.read<AuthenticationBloc>(),
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          accentColor: const Color(0xFF13B9FF),
          appBarTheme: const AppBarTheme(color: Color(0xFF13B9FF)),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          '/': (context) => Home(),
          '/login': (context) {
            return BlocProvider(
              create: (context) =>
                  LoginCubit(context.read<AuthenticationRepository>()),
              child: LoginPage(),
            );
          },
          '/signup': (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) =>
                      SignUpCubit(context.read<AuthenticationRepository>()),
                ),
              ],
              child: const SignUpPage(),
            );
          },
        },
        initialRoute: '/',
        // builder: (context, child) {
        //   return FlowBuilder<NavigationState>(
        //     state: context.select((NavigationCubit cubit) => cubit.state),
        //     onGeneratePages: (NavigationState state, List<Page> pages) {
        //       switch (state) {
        //         case NavigationState.home:
        //           return [Home.page()];
        //         // case NavigationState.learn:
        //         //   return [Learn.page()];
        //         // case NavigationState.page2:
        //         //   return [Page2.page()];
        //         default:
        //           return [Home.page()];
        //       }
        //     },
        //   );
        // },
      ),
    );
  }
}
