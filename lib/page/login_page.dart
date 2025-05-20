import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/cubit/login_cubit.dart';
import 'package:mobile_labs/widgets/auth_scaffold.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginCubit _loginCubit;

  @override
  void initState() {
    super.initState();
    _loginCubit = LoginCubit(const FlutterSecureStorage());
  }

  @override
  void dispose() {
    _loginCubit.close();
    super.dispose();
  }

  void _onButtonPressed(String email, String password) {
    _loginCubit.login(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>.value(
      value: _loginCubit,
      child: BlocListener<LoginCubit, LoginState>(
        listener: (context, state) {
          if (state.status == LoginStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage ?? 'Login failed')),
            );
          } else if (state.status == LoginStatus.success) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        },
        child: BlocBuilder<LoginCubit, LoginState>(
          builder: (context, state) {
            return AuthScaffold(
              title: 'Login',
              buttonText: state.status == LoginStatus.loading
                  ? 'Signing In...'
                  : 'Sign In',
              onButtonPressed: state.status == LoginStatus.loading
                  ? (_, __) {}
                  : _onButtonPressed,
              linkText: "Don't have an account? Register",
              onLinkPressed: () => Navigator.pushNamed(context, '/register'),
            );
          },
        ),
      ),
    );
  }
}
