import 'emun.dart';

class FoodIconHelper {
  // Chuyển từ tên sang FoodType
  static FoodType getFoodType(String name) {
    switch (name.toLowerCase()) {
      case "táo":
        return FoodType.apple;
      case "chuối":
        return FoodType.banana;
      case "trứng":
        return FoodType.egg;
      case "thịt gà":
        return FoodType.chicken;
      case "cà chua":
        return FoodType.tomato;
      default:
        return FoodType.unknown;
    }
  }

  // Lấy icon từ FoodType
  static String getIcon(FoodType type) {
    switch (type) {
      case FoodType.apple:
        return "icons/apple.png";
      case FoodType.banana:
        return "assets/icons/foods/banana.png";
      case FoodType.egg:
        return "assets/icons/foods/egg.png";
      case FoodType.chicken:
        return "assets/icons/foods/chicken.png";
      case FoodType.tomato:
        return "assets/icons/foods/tomato.png";
      case FoodType.unknown:
      default:
        return "icons/diet.png";
    }
  }

  // Hàm tiện lợi: từ tên → icon
  static String getIconByName(String name) {
    final type = getFoodType(name);
    return getIcon(type);
  }
}
