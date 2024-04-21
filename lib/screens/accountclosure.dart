import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tapa_0/screens/login.dart';

// class AccountClosureScreen extends StatelessWidget {
//   const AccountClosureScreen({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: Text('Account Closure Screen'),
//       ),
//     );
//   }
// }

class AccountClosureScreen extends StatefulWidget {
  @override
  _AccountClosureScreenState createState() => _AccountClosureScreenState();
}

class _AccountClosureScreenState extends State<AccountClosureScreen> {
  void _handleCloseAccount() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Confirm Account Deletion'),
          content: Text('Are you sure you want to delete your account? This action is irreversible.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await user.delete();
                await FirebaseAuth.instance.signOut();
                // Navigate to LoginScreen using pushReplacement
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text('Delete'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Closure'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _handleCloseAccount,
          child: Text('Delete Account'),
        ),
      ),
    );
  }
}