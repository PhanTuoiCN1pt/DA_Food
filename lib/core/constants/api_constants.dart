// lib/core/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = "http://192.168.0.105:5000/api";

  // Food
  static const String foodsApi = "http://192.168.0.105:5000/api/foods";

  // Meal suggestions
  static String mealSuggestionsApi(String userId) =>
      "http://192.168.0.105:5000/api/foods/meals/suggestions/$userId";
}
