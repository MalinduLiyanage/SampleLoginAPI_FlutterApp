import 'package:flutter/material.dart';
import 'package:enhanzer_login/models/data_model.dart';
import 'package:enhanzer_login/config/database.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/quickalert.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<UserData> userData;
  late Future<List<UserLocation>> userLocations;
  late Future<List<UserPermission>> userPermissions;

  @override
  void initState() {
    super.initState();
    userData = fetchUserData();
    userLocations = fetchUserLocations();
    userPermissions = fetchUserPermissions();
  }

  Future<UserData> fetchUserData() async {
    final db = await DatabaseHelper().getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('UserData');
    return UserData.fromMap(maps.first);
  }

  Future<List<UserLocation>> fetchUserLocations() async {
    final db = await DatabaseHelper().getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('UserLocations');
    return List.generate(maps.length, (i) => UserLocation.fromMap(maps[i]));
  }

  Future<List<UserPermission>> fetchUserPermissions() async {
    final db = await DatabaseHelper().getDatabase();
    final List<Map<String, dynamic>> maps = await db.query('UserPermissions');
    return List.generate(maps.length, (i) => UserPermission.fromMap(maps[i]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'User Information',
        style: TextStyle(fontWeight: FontWeight.bold),
      )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FutureBuilder<UserData>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(status: 'Loading User Data...');
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else if (snapshot.hasError) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: "Failed!",
                    text: "Error to fetch data!",
                  );
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else if (!snapshot.hasData) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    title: "Failed!",
                    text: "No Data Available",
                  );
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else {
                  EasyLoading.dismiss();
                  final user = snapshot.data!;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      title: const Text(
                        'USER INFORMATION',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('User Code: ${user.userCode}'),
                          Text('Name: ${user.userDisplayName}'),
                          Text('Email: ${user.email}'),
                          Text('Employee Code: ${user.userEmployeeCode}'),
                          Text('Company Code: ${user.companyCode}'),
                        ],
                      ),
                    ),
                  );
                }
              },
            ),
            FutureBuilder<List<UserLocation>>(
              future: userLocations,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(status: 'Loading Location Data...');
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else if (snapshot.hasError) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: "Failed!",
                    text: 'Error: ${snapshot.error}',
                  );
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    title: "Failed!",
                    text: 'No available Locations!',
                  );
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else {
                  EasyLoading.dismiss();
                  final locations = snapshot.data!;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: const Text(
                        'USER LOCATIONS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: locations.map((location) {
                          return Row(
                            children: [
                              const Icon(
                                Icons.location_pin,
                                color: Colors.purple,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                location.locationCode,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
            FutureBuilder<List<UserPermission>>(
              future: userPermissions,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  EasyLoading.show(status: 'Loading Permission Data...');
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else if (snapshot.hasError) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.warning,
                    title: "Failed!",
                    text: 'Error: ${snapshot.error}',
                  );
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  QuickAlert.show(
                    context: context,
                    type: QuickAlertType.info,
                    title: "Failed!",
                    text: 'No available Permissions!',
                  );
                  return const SizedBox(
                    width: 1,
                    height: 1,
                  );
                } else {
                  EasyLoading.dismiss();
                  final permissions = snapshot.data!;
                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: const Text(
                        'USER PERMISSIONS',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: permissions.map((permission) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  permission.permissionName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Checkbox(
                                value:
                                    permission.permissionStatus.toLowerCase() ==
                                        'enable',
                                onChanged: (bool? newValue) {},
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
