class AppRoutes {
  // Route name constants
  static const String home = '/home';
  static const String signin = '/signin';
  static const String signup = '/signup';


  // static const _protectedRoutes = {
  //   bottomNav,
  //   home,
  //   explore,
  //   cart,
  //   orders,
  //   orderDetail,
  //   shop,
  //   wishlist,
  //   account,
  //   addresses,
  //   personalDetails,
  //   productDetail,
  // };

  // static bool get _isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // static Route<dynamic> onGenerateRoute(RouteSettings settings) {
  //   // Guard: redirect to signin if route is protected and user is not logged in
  //   if (_protectedRoutes.contains(settings.name) && !_isLoggedIn) {
  //     return _route(const SignInScreen());
  //   }

  //   switch (settings.name) {
  //     case bottomNav:
  //       return _route(const BottomNavBar());
  //     case home:
  //       return _route(const BottomNavBar());
  //     case signin:
  //       return _route(const SignInScreen());
  //     case signup:
  //       return _route(const SignupScreen());
  //     case welcomeBack:
  //       return _route(const WelcomeBackScreen());
  //     case onboarding:
  //       return _route(const OnboardingScreen());
  //     case cart:
  //       return _route(const CartScreen());
  //     case explore:
  //       return _route(const ShopScreen());
  //     case orders:
  //       return _route(const OrdersScreen());
  //     case wishlist:
  //       return _route(const WishlistScreen());
  //     case account:
  //       return _route(const AccountScreen());
  //     case addresses:
  //       return _route(const AccountAddressesScreen());
  //     case personalDetails:
  //       return _route(const PersonalDetailsScreen());

  //     case orderDetail:
  //       final order = settings.arguments as OrderModel?;
  //       if (order != null) return _route(OrderDetailScreen(order: order));
  //       return _route(const OrdersScreen());

  //     case productDetail:
  //       final product = settings.arguments as ProductModel?;
  //       if (product != null) {
  //         return _route(
  //           ProductDetailsScreen(
  //             product: product,
  //             heroTag: int.parse(product.id),
  //           ),
  //         );
  //       }
  //       return _route(const BottomNavBar());

  //     default:
  //       return _route(const BottomNavBar());
  //   }
  // }

  // static MaterialPageRoute _route(Widget screen) =>
  //     MaterialPageRoute(builder: (_) => screen);
}
