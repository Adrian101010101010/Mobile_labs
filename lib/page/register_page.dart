import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_labs/cubit/register_cubit.dart';
import 'package:mobile_labs/widgets/auth_scaffold.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(const FlutterSecureStorage()),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatelessWidget {
  const RegisterView({super.key});

  void _handleRegister(BuildContext context, String email, String password) {
    context.read<RegisterCubit>().register(email, password);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state.status == RegisterStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        } else if (state.status == RegisterStatus.success) {
          Navigator.pushReplacementNamed(context, '/home');
        }
      },
      builder: (context, state) {
        return AuthScaffold(
          title: 'Register',
          buttonText:
              state.status == RegisterStatus.loading
                  ? 'Signing Up...'
                  : 'Sign Up',
          onButtonPressed: (email, password) {
            if (state.status != RegisterStatus.loading) {
              _handleRegister(context, email, password);
            }
          },
          linkText: 'Already have an account? Login',
          onLinkPressed: () => Navigator.pushNamed(context, '/login'),
        );
      },
    );
  }
}
