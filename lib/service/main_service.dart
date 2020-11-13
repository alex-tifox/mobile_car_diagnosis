class MainService {
  static final MainService _instance = MainService._internal();

  factory MainService() {
    return _instance;
  }

  MainService._internal();
}
