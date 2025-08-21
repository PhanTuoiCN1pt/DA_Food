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
      case "cải thảo":
        return FoodType.chineseCabbage;
      case "bắp cải":
        return FoodType.cabbage;
      case "cà rốt":
        return FoodType.carrot;
      case "hành":
        return FoodType.onion;
      case "cà tím":
        return FoodType.eggplant;
      case "bí đỏ":
        return FoodType.pumpkin;
      case "hành lá":
        return FoodType.greenOnion;
      case "hẹ":
        return FoodType.chives;
      case "củ sen":
        return FoodType.potato;
      case "khoai tây":
        return FoodType.tomato;
      case "nấm":
        return FoodType.mushroom;
      case "hành tây":
        return FoodType.onionTay;
      case "cải thìa":
        return FoodType.bokChoy;
      case "giá đỗ":
        return FoodType.sprouts;
      case "khoai lang":
        return FoodType.sweetPotato;
      case "dưa chuột":
        return FoodType.cucumber;
      case "khoai môn":
        return FoodType.taro;
      case "tía tô":
        return FoodType.perilla;
      case "ngô":
        return FoodType.corn;
      case "su hào":
        return FoodType.kohlrabi;
      case "bí ngô":
        return FoodType.bingo;
      case "ớt":
        return FoodType.chili;
      case "ớt chuông":
        return FoodType.bellPepper;
      case "súp lơ trắng":
        return FoodType.cauliflower;
      case "súp lơ xanh":
        return FoodType.broccoli;
      case "đậu cuve":
        return FoodType.greenBeans;
      case "mướp":
        return FoodType.food;
      case "quả bí":
        return FoodType.zucchini;
      case "rau mùi":
        return FoodType.coriander;
      case "tỏi":
        return FoodType.garlic;
      case "mướp đắng":
        return FoodType.bitterGourd;
      case "húng quế":
        return FoodType.basil;
      case "rau muống":
        return FoodType.morningGlory;
      case "rau mồng tơi":
        return FoodType.spinach1;
      case "rau ngót":
        return FoodType.rauNgot;
      case "măng":
        return FoodType.bamboo;

      // ----- Thịt -----
      case "ba chỉ heo":
        return FoodType.porkBelly;
      case "thịt vịt":
        return FoodType.duck;
      case "thịt gà":
        return FoodType.chicken;
      case "cánh gà":
        return FoodType.chickenWings;
      case "đùi gà":
        return FoodType.drumstick;
      case "giăm bông":
        return FoodType.ham;
      case "sườn":
        return FoodType.ribs;
      case "thăn bò":
        return FoodType.tenderloin;
      case "chân giò heo":
        return FoodType.porkLeg;
      case "thịt bò":
        return FoodType.beef;
      case "thịt lợn":
        return FoodType.pig;
      case "chế phẩm từ thịt":
        return FoodType.meatProduct;
      case "trứng":
        return FoodType.eggs;
      case "trứng cút":
        return FoodType.quailEggs;
      case "bít tết":
        return FoodType.tomahawk;

      // ----- Hải sản -----
      case "tôm":
        return FoodType.shrimp;
      case "cá":
        return FoodType.fish;
      case "lươn":
        return FoodType.eel;
      case "cua":
        return FoodType.crab;
      case "ốc":
        return FoodType.snail;
      case "ngao":
        return FoodType.clam;
      case "hến":
        return FoodType.mussel;
      case "trai":
        return FoodType.shellfish;
      case "sò":
        return FoodType.scallop;
      case "mực":
        return FoodType.squid;
      case "cá hồi":
        return FoodType.salmon;
      case "bạch tuộc":
        return FoodType.octopus;
      case "trứng cá":
        return FoodType.roe;
      case "tôm hùm":
        return FoodType.lobster;
      case "sứa":
        return FoodType.jellyfish;
      case "cua hoàng đế":
        return FoodType.snowCrab;
      case "dong biển":
        return FoodType.seaweed;

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
      case FoodType.chineseCabbage:
        return "icons/vegetables/chinese-cabbage.png";
      case FoodType.cabbage:
        return "icons/vegetables/cabbage.png";
      case FoodType.carrot:
        return "icons/vegetables/carrots.png";
      case FoodType.onion:
        return "icons/vegetables/onion.png";
      case FoodType.eggplant:
        return "icons/vegetables/eggplant.png";
      case FoodType.pumpkin:
        return "icons/vegetables/pumpkin.png";
      case FoodType.greenOnion:
        return "icons/vegetables/green-onion.png";
      case FoodType.chives:
        return "icons/vegetables/chives.png";
      case FoodType.lotusRoot:
        return "icons/vegetables/lotus-root.png";
      case FoodType.potato:
        return "icons/vegetables/potato.png";
      case FoodType.mushroom:
        return "icons/vegetables/mushroom.png";
      case FoodType.onionTay:
        return "icons/vegetables/oniontay.png";
      case FoodType.bokChoy:
        return "icons/vegetables/bok-choy.png";
      case FoodType.sprouts:
        return "icons/vegetables/sprouts.png";
      case FoodType.sweetPotato:
        return "icons/vegetables/sweet-potato.png";
      case FoodType.cucumber:
        return "icons/vegetables/cucumber.png";
      case FoodType.taro:
        return "icons/vegetables/taro.png";
      case FoodType.perilla:
        return "icons/vegetables/perilla.png";
      case FoodType.corn:
        return "icons/vegetables/corn.png";
      case FoodType.kohlrabi:
        return "icons/vegetables/kohlrabi.png";
      case FoodType.bingo:
        return "icons/vegetables/bingo.png";
      case FoodType.chili:
        return "icons/vegetables/chili.png";
      case FoodType.bellPepper:
        return "icons/vegetables/bell-pepper.png";
      case FoodType.cauliflower:
        return "icons/vegetables/cauliflower.png";
      case FoodType.broccoli:
        return "icons/vegetables/healthy.png";
      case FoodType.greenBeans:
        return "icons/vegetables/green-beans.png";
      case FoodType.food:
        return "icons/vegetables/food.png";
      case FoodType.zucchini:
        return "icons/vegetables/zucchini.png";
      case FoodType.coriander:
        return "icons/vegetables/coriander.png";
      case FoodType.garlic:
        return "icons/vegetables/garlic.png";
      case FoodType.bitterGourd:
        return "icons/vegetables/bitter-gourd.png";
      case FoodType.basil:
        return "icons/vegetables/basil.png";
      case FoodType.morningGlory:
        return "icons/vegetables/spinach.png";
      case FoodType.spinach1:
        return "icons/vegetables/spinach1.png";
      case FoodType.rauNgot:
        return "icons/vegetables/2.png";
      case FoodType.bamboo:
        return "icons/vegetables/bamboo.png";

      // --- Thịt ---
      case FoodType.pork:
        return "assets/icons/meats/pork.png";
      case FoodType.duck:
        return "assets/icons/meats/peking-duck.png";
      case FoodType.chicken:
        return "assets/icons/meats/roast-chicken.png";
      case FoodType.chickenWings:
        return "assets/icons/meats/chicken-wings.png";
      case FoodType.drumstick:
        return "assets/icons/meats/drumstick.png";
      case FoodType.ham:
        return "assets/icons/meats/ham.png";
      case FoodType.ribs:
        return "assets/icons/meats/ribs.png";
      case FoodType.tenderloin:
        return "assets/icons/meats/tenderloin.png";
      case FoodType.porkLeg:
        return "assets/icons/meats/pork-leg.png";
      case FoodType.beef:
        return "assets/icons/meats/beef.png";
      case FoodType.pig:
        return "assets/icons/meats/pig.png";
      case FoodType.meatProduct:
        return "assets/icons/meats/ham1.png";
      case FoodType.eggs:
        return "assets/icons/meats/eggs.png";
      case FoodType.quailEggs:
        return "assets/icons/meats/eggcut.png";
      case FoodType.tomahawk:
        return "assets/icons/meats/tomahawk.png";

      // --- Hải sản ---
      case FoodType.shrimp:
        return "assets/icons/seafood/shrimp.png";
      case FoodType.fish:
        return "assets/icons/seafood/fish.png";
      case FoodType.eel:
        return "assets/icons/seafood/angler.png";
      case FoodType.crab:
        return "assets/icons/seafood/crab.png";
      case FoodType.snail:
        return "assets/icons/seafood/shell.png";
      case FoodType.clam:
        return "assets/icons/seafood/clam.png";
      case FoodType.mussel:
        return "assets/icons/seafood/she.png";
      case FoodType.mussel:
        return "assets/icons/seafood/mussel.png";
      case FoodType.scallop:
        return "assets/icons/seafood/so.png";
      case FoodType.squid:
        return "assets/icons/seafood/squid.png";
      case FoodType.salmon:
        return "assets/icons/seafood/salmon.png";
      case FoodType.octopus:
        return "assets/icons/seafood/octopus.png";
      case FoodType.roe:
        return "assets/icons/seafood/sushi.png";
      case FoodType.lobster:
        return "assets/icons/seafood/lobster.png";
      case FoodType.jellyfish:
        return "assets/icons/seafood/jellyfish.png";
      case FoodType.snowCrab:
        return "assets/icons/seafood/snow-crab.png";
      case FoodType.seaweed:
        return "assets/icons/seafood/seaweed.png";

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
