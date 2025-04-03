import 'package:mobile_labs/abstract_class/base_home_page.dart';

class HomePage extends BaseHomePage {
  const HomePage({super.key});

  @override
  BaseHomePageState createState() => _HomePageState();
}

class _HomePageState extends BaseHomePageState<HomePage> {}
