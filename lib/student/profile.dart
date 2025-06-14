import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login.dart';
import 'submissions.dart';
import 'classroom.dart';
import 'main.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECEC),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: const BoxDecoration(
                color: Color(0xFF6CBCFB),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontFamily: 'KronaOne',
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginFormScreen()),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('icons/user-icon.png'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Christine Joy Cleofe',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 30,
                color: const Color(0xFF0187F1),
              ),
            ),
            const Text(
              '24-07628',
              style: TextStyle(fontSize: 16, color: Color(0xFF383838)),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    'Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildInfoRow('Department:', 'College of Computer Studies'),
                  buildInfoRow('Year:', '3rd'),
                  buildInfoRow('Course:', 'BSIT'),
                  buildInfoRow('Email:', 'cristinejoy.cleofe@unc.edu.ph'),
                  buildInfoRow('Password:', '**hidden**'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => _buildPasswordUpdateDialog(context),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0187F1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Update',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                        color: const Color(0xFFFFFFFF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          color: Colors.white,
          child: SizedBox(
            height: 80.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildBottomNavigationItem(context, Icons.dashboard, 'Dashboard', const MyApp()),
                buildBottomNavigationItem(context, Icons.folder, 'Classroom', const ClassroomScreen()),
                buildBottomNavigationItem(context, Icons.featured_play_list, 'Submissions', const SubmissionsScreen()),
                buildBottomNavigationItem(context, Icons.person, 'Profile', const ProfileScreen(), isActive: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget buildBottomNavigationItem(BuildContext context, IconData icon, String label, Widget targetScreen, {bool isActive = false}) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => targetScreen),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFF0187F1) : Colors.black,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? const Color(0xFF0187F1) : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordUpdateDialog(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Update Password',
        style: TextStyle(color: Color(0xFF6CBCFB), fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: InputDecoration(
              labelText: 'Current Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'New Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: InputDecoration(
              labelText: 'Verify New Password',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            obscureText: true,
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Handle password update logic here
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0187F1),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            'Update',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: 16,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ],
    );
  }
}
