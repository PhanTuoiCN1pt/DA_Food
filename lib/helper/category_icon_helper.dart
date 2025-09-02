class CategoryIconHelper {
  static String getIcon(String category) {
    switch (category) {
      case "Mì":
        return "assets/icons/alcohol/beer.png";
      case "Nước":
        return "assets/icons/alcohol/brandy.png";
      case "Đồ uống":
        return "assets/icons/alcohol/brandy.png";
      default:
        return "assets/icons/alcohol/beer.png"; // icon mặc định
    }
  }
}
