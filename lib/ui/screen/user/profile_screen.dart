import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:movie/ui/constant/color_pallete.dart';
import 'package:movie/ui/screen/Favorite/favorite_page.dart';
import 'package:movie/ui/screen/auth/login_screen.dart';
import 'package:movie/ui/screen/ticket/ticket_page.dart';
import 'package:movie/ui/screen/user/cubit/user_cubit.dart';
import 'package:movie/ui/screen/webview/webview_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

// class ProfileScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: ColorPallete.colorPrimary,
//       appBar: AppBar(
//         title: Text("My Profile", style: TextStyle(color: Colors.white)),
//         backgroundColor: ColorPallete.colorPrimary,
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 20),
//             BlocBuilder<UserCubit, UserState>(builder: (context, state) {
//               if (state is UserLoaded) {
//                 return Column(
//                   children: [
//                     CircleAvatar(
//                       radius: 50,
//                       backgroundImage: NetworkImage(state.data.image!),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       "${state.data.firstName} ${state.data.lastName}",
//                       style: TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white),
//                     ),
//                     Text(
//                       "${state.data.email}",
//                       style: TextStyle(fontSize: 16, color: Colors.white),
//                     ),
//                   ],
//                 );
//               } else if (state is UserFailed) {
//                 return Text(
//                   state.message,
//                   style: TextStyle(color: Colors.white),
//                 );
//               } else {
//                 return CircularProgressIndicator();
//               }
//             }),
//             SizedBox(height: 20),
//             _buildMenuItem(
//                 icon: Icons.favorite_border, title: "Favourites", onTap: () {}),
//             _buildMenuItem(
//                 icon: Icons.download, title: "Downloads", onTap: () {}),
//             Divider(),
//             _buildMenuItem(
//                 icon: Icons.language, title: "Languages", onTap: () {}),
//             _buildMenuItem(
//                 icon: Icons.location_on, title: "Location", onTap: () {}),
//             _buildMenuItem(
//                 icon: Icons.subscriptions, title: "Subscription", onTap: () {}),
//             _buildMenuItem(
//                 icon: Icons.display_settings, title: "Display", onTap: () {}),
//             Divider(),
//             _buildMenuItem(
//                 icon: Icons.delete_outline, title: "Clear Cache", onTap: () {}),
//             _buildMenuItem(
//                 icon: Icons.history, title: "Clear History", onTap: () {}),
//             _buildMenuItem(
//                 icon: Icons.logout,
//                 title: "Log Out",
//                 onTap: () async {
//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   prefs.clear();
//                   Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => LoginScreen(),
//                       ));
//                 }),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildMenuItem(
//       {required IconData icon,
//       required String title,
//       required Function() onTap}) {
//     return ListTile(
//       leading: Icon(icon, color: Colors.white),
//       title: Text(title, style: TextStyle(fontSize: 16, color: Colors.white)),
//       trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
//       onTap: onTap,
//     );
//   }
// }

class ProfileScreen extends StatefulWidget {
  final Function(int index) onChangePage;
  const ProfileScreen({super.key, required this.onChangePage});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isBiometricActiv = false;
  final LocalAuthentication auth = LocalAuthentication();
  // Function to launch WhatsApp
  void launchWhatsApp({required String phone, required String message}) async {
    final Uri uri =
        Uri.parse("https://wa.me/$phone?text=${Uri.encodeComponent(message)}");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp')),
      );
    }
  }

  Future<void> _loadBiometricSetting() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isBiometricActiv = prefs.getBool('isBiometricActive') ?? false;
    });
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value) {
      // Jika user mengaktifkan, lakukan autentikasi fingerprint terlebih dahulu
      try {
        bool authenticated = await auth.authenticate(
          localizedReason:
              'Verifikasi fingerprint untuk mengaktifkan login biometric',
          options: const AuthenticationOptions(
            biometricOnly: true,
            useErrorDialogs: true,
            stickyAuth: true,
          ),
        );

        if (!authenticated) {
          // Jika gagal, jangan ubah nilai toggle
          return;
        }
      } catch (e) {
        debugPrint('Error saat autentikasi: $e');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorPallete.colorPrimary, // Set background color
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return Center(child: CircularProgressIndicator());
              }

              if (state is UserFailed) {
                return Center(child: Text("Error: ${state.message}"));
              }

              if (state is UserLoaded) {
                final user = state.data;
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Profile Header
                      ClipRRect(
                        borderRadius: BorderRadius.circular(60),
                        child: Image.network(
                          state.data.image!,
                          width: 120,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        state.data.username ?? 'Username not available',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        state.data.email ?? 'Email not available',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: 30),

                      // Inventories Section (Favorites & Tickets)
                      ListTile(
                        leading: Icon(Icons.bookmark, color: Colors.white),
                        title: Text("Favorite",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FavoritePage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.card_travel, color: Colors.white),
                        title: Text("Ticket",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TicketPage()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.fingerprint, color: Colors.white),
                        title: Text("Login Biometric",
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        trailing: Switch(
                            value: _isBiometricActiv,
                            activeColor: Colors.white,
                            onChanged: (value) {
                              _toggleBiometric(value);
                            }),
                        onTap: () {
                          _toggleBiometric(!_isBiometricActiv);
                        },
                      ),

                      Divider(color: Colors.grey),

                      // Preferences Section
                      ListTile(
                        leading: Icon(Icons.notifications, color: Colors.white),
                        title: Text("Privacy Policy",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WebViewScreen(
                                url:
                                    "https://example.com/privacy-policy", // Ganti dengan URL yang benar
                                title: "Privacy Policy",
                              ),
                            ),
                          );
                        },
                      ),

                      ListTile(
                        leading: Icon(Icons.face, color: Colors.white),
                        title: Text("Terms and Condition",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.lock, color: Colors.white),
                        title: Text("Contact",
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Launch WhatsApp when "Contact" is tapped
                          launchWhatsApp(
                            phone:
                                '081382000000', // Replace with actual phone number
                            message: 'Hello, I need help!',
                          );
                        },
                      ),
                      Divider(color: Colors.grey),

                      // Logout Section
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.red),
                        title:
                            Text("Logout", style: TextStyle(color: Colors.red)),
                        onTap: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          await prefs.setBool('is_Login', false);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ));
                        },
                      ),
                    ],
                  ),
                );
              }

              return Container(); // Default case if no state is matched
            },
          ),
        ),
      ),
    );
  }
}
