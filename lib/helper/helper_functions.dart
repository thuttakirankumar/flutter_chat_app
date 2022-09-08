import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  static String userLoggedInKey = "LOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";
  
  //saving data in shared preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setBool(userLoggedInKey, isUserLoggedIn);
  
  }

   static Future<bool> saveUserNameSF(String userName) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userNameKey, userName);
  }

   static Future<bool> saveUserEmailSF(String userEmail) async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return await sharedPreferences.setString(userEmailKey, userEmail);
  }



  //getting data from sharedpreferences
  static Future<bool?> getUserLoggedInStatus() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     return sharedPreferences.getBool(userLoggedInKey);
  }

   static Future<String?> getUserName() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     return sharedPreferences.getString(userNameKey);
    }

     static Future<String?> getUserEmail() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     return sharedPreferences.getString(userEmailKey);
    }
  
  static Future<bool?> clearSharedPreferences() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
     return sharedPreferences.clear();
  }

}