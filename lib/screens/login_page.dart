import 'package:dynamic_background/dynamic_background.dart';
import 'package:enhanzer_login/config/database.dart';
import 'package:enhanzer_login/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:modern_textfield/modern_textfield.dart';
import 'package:quickalert/quickalert.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sqflite/sqflite.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final DatabaseHelper dbHelper = DatabaseHelper();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper.initDatabase();
  }

  Future<void> fetchData(String username, String password) async {
    const url = "https://api.ezuite.com/api/External_Api/Mobile_Api/Invoke";

    final requestBody = jsonEncode({
      "API_Body": [
        {"Unique_Id": "", "Pw": password}
      ],
      "Api_Action": "GetUserData",
      "Company_Code": username
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final users = data["Response_Body"];

        await saveToDatabase(users);
        EasyLoading.dismiss();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.success,
          title: "Done",
          text: 'Transaction Completed Successfully!',
          onConfirmBtnTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        );
      } else {
        EasyLoading.dismiss();
        print("Failed to fetch data: ${response.statusCode}");
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: "Failed!",
          text: "Failed to fetch data: ${response.statusCode}",
        );
      }
    } catch (e) {
      EasyLoading.dismiss();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        title: "Failed!",
        text: "Error to fetch data: $e",
      );
    }
  }

  Future<void> saveToDatabase(List<dynamic> users) async {
    final database = await dbHelper.getDatabase();

    for (var user in users) {
      await database.insert(
        'UserData',
        {
          'User_Code': user['User_Code'],
          'User_Display_Name': user['User_Display_Name'],
          'Email': user['Email'],
          'User_Employee_Code': user['User_Employee_Code'],
          'Company_Code': user['Company_Code'],
        },
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );

      List<dynamic> locations = user['User_Locations'];
      for (var location in locations) {
        await database.insert(
          'UserLocations',
          {
            'User_Code': user['User_Code'],
            'Location_Code': location['Location_Code'],
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }

      List<dynamic> permissions = user['User_Permissions'];
      for (var permission in permissions) {
        await database.insert(
          'UserPermissions',
          {
            'User_Code': user['User_Code'],
            'Permission_Name': permission['Permisson_Name'],
            'Permission_Status': permission['Permission_Status'],
          },
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: DynamicBg(
          painterData: ScrollerPainterData(
            shape: ScrollerShape.circles,
            backgroundColor: ColorSchemes.gentlePurpleBg,
            color: ColorSchemes.gentlePurpleFg,
            shapeOffset: ScrollerShapeOffset.shiftAndMesh,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ModernTextField(
                          textEditingController: _usernameController,
                          iconBackgroundColor: Colors.purple,
                          borderRadius: 10,
                          customTextFieldIcon: const Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          hintText: "Email",
                          hintStyling: const TextStyle(color: Colors.purple),
                        ),
                        const SizedBox(height: 8),
                        ModernTextField(
                          textEditingController: _passwordController,
                          isPasswordField: true,
                          iconBackgroundColor: Colors.purple,
                          borderRadius: 10,
                          customTextFieldIcon: const Icon(
                            Icons.key,
                            color: Colors.white,
                          ),
                          hintText: "Password",
                          hintStyling: const TextStyle(color: Colors.purple),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: AnimatedButton(
                  onPress: () async {
                    EasyLoading.show(status: 'Please Wait...');
                    String username = _usernameController.text;
                    String password = _passwordController.text;
                    fetchData(username, password);
                  },
                  height: 70,
                  text: 'Login to Account',
                  isReverse: true,
                  selectedTextColor: Colors.black,
                  transitionType: TransitionType.LEFT_TO_RIGHT,
                  backgroundColor: Colors.black,
                  borderColor: Colors.purple,
                  borderRadius: 25,
                  borderWidth: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
