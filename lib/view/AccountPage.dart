import 'package:flutter/material.dart';
import 'package:jojocart_mobile/view/LoginScreen.dart';
import '../theme/appTheme.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with profile summary
            _buildProfileHeader(context),

            // List of options
            _buildOptionItem(
              context,
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              showArrow: true,
            ),
            _buildOptionItem(
              context,
              icon: Icons.person_outline,
              title: 'My Profile',
              subtitle: 'View and edit your profile',
              showArrow: true,
            ),
            _buildOptionItem(
              context,
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              subtitle: 'Save address for a hassle-free checkout',
              showArrow: true,
            ),
            _buildOptionItem(
              context,
              icon: Icons.logout,
              title: 'Logout',
              showArrow: true,
            ),

            const SizedBox(height: 40),

            // Legal links
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text('Privacy Policy',
                      style: context.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {},
                    child: Text('Terms & Conditions',
                      style: context.bodyMedium?.copyWith(
                        decoration: TextDecoration.underline,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // App version
            Container(
              color: Colors.white,
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'App Version 1.0',
                    style: context.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue[100],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'R',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'rbalerao1478@gmail.com',
                  style: context.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.grey),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        String? subtitle,
        required bool showArrow,
      }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 0.5,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Icon(
          icon,
          color: Colors.grey[700],
          size: 22,
        ),
        title: Text(
          title,
          style: context.titleSmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
        subtitle: subtitle != null
            ? Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            subtitle,
            style: context.bodySmall?.copyWith(
              color: Colors.grey[600],
              fontSize: 13,
            ),
          ),
        )
            : null,
        trailing: showArrow
            ? Icon(
          Icons.chevron_right,
          color: Colors.grey[500],
          size: 20,
        )
            : null,
        onTap: () {},
      ),
    );
  }
}