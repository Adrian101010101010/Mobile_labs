import 'package:mobile_labs/shared/auth_scaffold_base.dart';

class AuthScaffold extends AuthScaffoldBase {
  const AuthScaffold({
    required super.title,
    required super.buttonText,
    required super.onButtonPressed,
    required super.linkText,
    required super.onLinkPressed,
    super.key,
    super.subtitle,
  });

  @override
  AuthScaffoldBaseState<AuthScaffold> createState() => _AuthScaffoldState();
}

class _AuthScaffoldState extends AuthScaffoldBaseState<AuthScaffold> {}
