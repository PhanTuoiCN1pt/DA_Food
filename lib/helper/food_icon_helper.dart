import 'emun.dart';

class FoodIconHelper {
  // Lấy FoodType từ tên tiếng Việt
  static FoodType getFoodType(String name) {
    switch (name.toLowerCase()) {
      // ----- Trái cây -----
      case "táo":
        return FoodType.apple;
      case "đào":
        return FoodType.apricot;
      case "bơ":
        return FoodType.avocado;
      case "chuối":
        return FoodType.banana;
      case "việt quất":
        return FoodType.blueberry;
      case "cherry":
        return FoodType.cherry;
      case "thanh long":
        return FoodType.dragonFruit;
      case "nho":
        return FoodType.grape;
      case "bưởi":
        return FoodType.grapefruit;
      case "kiwi":
        return FoodType.kiwi;
      case "chanh vàng":
        return FoodType.lemon;
      case "chanh":
        return FoodType.lime;
      case "sầu riêng":
        return FoodType.durian;
      case "xoài":
        return FoodType.mango;
      case "lê":
        return FoodType.pear;
      case "dứa gai":
        return FoodType.pineapple;
      case "lựu":
        return FoodType.pomegranate;
      case "chôm chôm":
        return FoodType.rambutan;
      case "dưa hấu":
        return FoodType.watermelon;
      case "cà chua":
        return FoodType.tomato;
      case "dâu tây":
        return FoodType.strawberry;
      case "dưa gang":
        return FoodType.melon;
      case "dưa lưới":
        return FoodType.cantaloupe;
      case "vải thiều":
        return FoodType.lychee;
      case "hồng":
        return FoodType.persimmon;
      case "đu đủ":
        return FoodType.papaya;
      case "mận":
        return FoodType.plum;
      case "nhãn":
        return FoodType.longan;
      case "dừa":
        return FoodType.coconut;
      case "ổi":
        return FoodType.guava;

      // ----- Rau -----
      case "rau muống":
        return FoodType.morningGlory;
      case "bắp cải":
        return FoodType.cabbage;

      // ----- Thịt -----
      case "thịt bò":
        return FoodType.beef;
      case "thịt gà":
        return FoodType.chicken;
      case "thịt heo":
        return FoodType.pork;

      // ----- Hải sản -----
      case "cá":
        return FoodType.fish;
      case "tôm":
        return FoodType.shrimp;
      case "cua":
        return FoodType.crab;
      case "mực":
        return FoodType.squid;

      // ----- Sữa -----
      case "sữa":
        return FoodType.milk;
      case "phô mai":
        return FoodType.cheese;
      case "sữa chua":
        return FoodType.yogurt;

      // ----- Món ăn -----
      case "cơm":
        return FoodType.rice;
      case "bánh mì":
        return FoodType.bread;
      case "món ăn":
        return FoodType.dinner;

      // ----- Đồ uống -----
      case "nước ngọt":
        return FoodType.softDrink;
      case "rượu":
        return FoodType.alcohol;
      case "nước":
        return FoodType.water;

      // ----- Gia vị -----
      case "nước sốt":
        return FoodType.ketchup;
      case "gia vị":
        return FoodType.spice;

      // ----- Tráng miệng -----
      case "kem":
        return FoodType.iceCream;

      // ----- Khác -----
      case "quả hạch":
        return FoodType.nut;
      case "vân vân":
        return FoodType.etc;

      default:
        return FoodType.unknown;
    }
  }

  // Trả về đường dẫn icon theo FoodType (đã bỏ assets/)
  static String getIcon(FoodType type) {
    switch (type) {
      // ----- Trái cây -----
      case FoodType.apple:
        return "icons/fruit/apple.png";
      case FoodType.apricot:
        return "icons/fruit/apricot.png";
      case FoodType.avocado:
        return "icons/fruit/avocado.png";
      case FoodType.banana:
        return "icons/fruit/banana.png";
      case FoodType.blueberry:
        return "icons/fruit/blueberry.png";
      case FoodType.cherry:
        return "icons/fruit/berry.png";
      case FoodType.dragonFruit:
        return "icons/fruit/dragon-fruit.png";
      case FoodType.grape:
        return "icons/fruit/grapes.png";
      case FoodType.grapefruit:
        return "icons/fruit/grapefruit.png";
      case FoodType.kiwi:
        return "icons/fruit/kiwi.png";
      case FoodType.lemon:
        return "icons/fruit/lemon.png";
      case FoodType.lime:
        return "icons/fruit/lime.png";
      case FoodType.durian:
        return "icons/fruit/durian.png";
      case FoodType.mango:
        return "icons/fruit/mango.png";
      case FoodType.pear:
        return "icons/fruit/pear.png";
      case FoodType.pineapple:
        return "icons/fruit/pineapple.png";
      case FoodType.pomegranate:
        return "icons/fruit/pomegranate.png";
      case FoodType.rambutan:
        return "icons/fruit/rambutan.png";
      case FoodType.watermelon:
        return "icons/fruit/watermelon.png";
      case FoodType.tomato:
        return "icons/fruit/tomato.png";
      case FoodType.strawberry:
        return "icons/fruit/strawberrry.png";
      case FoodType.melon:
        return "icons/fruit/melon.png";
      case FoodType.cantaloupe:
        return "icons/fruit/melon (1).png";
      case FoodType.lychee:
        return "icons/fruit/lychee.png";
      case FoodType.persimmon:
        return "icons/fruit/persimmon.png";
      case FoodType.papaya:
        return "icons/fruit/papaya.png";
      case FoodType.plum:
        return "icons/fruit/plum.png";
      case FoodType.longan:
        return "icons/fruit/longan.png";
      case FoodType.coconut:
        return "icons/fruit/coconut.png";
      case FoodType.guava:
        return "icons/fruit/guava.png";

      // ----- Rau -----
      case FoodType.morningGlory:
      case FoodType.cabbage:
        return "icons/category/vegetable.png";

      // ----- Thịt -----
      case FoodType.beef:
        return "icons/foods/beef.png";
      case FoodType.chicken:
        return "icons/foods/chicken.png";
      case FoodType.pork:
        return "icons/foods/pork.png";

      // ----- Hải sản -----
      case FoodType.fish:
      case FoodType.shrimp:
      case FoodType.crab:
      case FoodType.squid:
        return "icons/category/seafood.png";

      // ----- Sữa -----
      case FoodType.milk:
      case FoodType.cheese:
      case FoodType.yogurt:
        return "icons/category/dairy.png";

      // ----- Món ăn -----
      case FoodType.rice:
        return "icons/category/rice.png";
      case FoodType.bread:
        return "icons/category/bakery.png";
      case FoodType.dinner:
        return "icons/category/dinner.png";

      // ----- Đồ uống -----
      case FoodType.softDrink:
        return "icons/category/soft-drink.png";
      case FoodType.alcohol:
        return "icons/category/drink.png";
      case FoodType.water:
        return "icons/category/drink.png";

      // ----- Gia vị -----
      case FoodType.ketchup:
        return "icons/category/ketchup.png";
      case FoodType.spice:
        return "icons/category/spice.png";

      // ----- Tráng miệng -----
      case FoodType.iceCream:
        return "icons/category/ice-cream.png";

      // ----- Khác -----
      case FoodType.nut:
        return "icons/category/dried-fruits.png";
      case FoodType.etc:
        return "icons/category/food.png";

      // ----- Default -----
      case FoodType.unknown:
      default:
        return "icons/category/food.png";
    }
  }

  // Hàm tiện lợi: từ tên → icon
  static String getIconByName(String name) {
    final type = getFoodType(name);
    return getIcon(type);
  }
}
