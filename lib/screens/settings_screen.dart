import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _downloadOnWifiOnly = true;
  String _audioQuality = 'High';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Settings
              Text(
                'Account Settings',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFFFD700),
                    ),
              ),
              const SizedBox(height: 16),
              _buildSettingItem(
                context,
                'Change Password',
                Icons.lock,
                onTap: () {
                  // Navigate to change password screen
                },
              ),
              _buildSettingItem(
                context,
                'Delete Account',
                Icons.delete,
                onTap: () {
                  // Show delete account confirmation
                },
                isDestructive: true,
              ),
              
              const SizedBox(height: 24),
              
              // Playback Settings
              // Text(
              //   'Playback Settings',
              //   style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              //         color: const Color(0xFFFFD700),
              //       ),
              // ),
              // const SizedBox(height: 16),
              // _buildSwitchSettingItem(
              //   context,
              //   'Notifications',
              //   Icons.notifications,
              //   _notificationsEnabled,
              //   (value) {
              //     setState(() {
              //       _notificationsEnabled = value;
              //     });
              //   },
              // ),
              // _buildSwitchSettingItem(
              //   context,
              //   'Download on Wi-Fi Only',
              //   Icons.wifi,
              //   _downloadOnWifiOnly,
              //   (value) {
              //     setState(() {
              //       _downloadOnWifiOnly = value;
              //     });
              //   },
              // ),
              // _buildDropdownSettingItem(
              //   context,
              //   'Audio Quality',
              //   Icons.high_quality,
              //   _audioQuality,
              //   ['Low', 'Medium', 'High', 'Very High'],
              //   (value) {
              //     setState(() {
              //       _audioQuality = value!;
              //     });
              //   },
              // ),
              
              // const SizedBox(height: 24),
              
              // About
              Text(
                'About',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: const Color(0xFFFFD700),
                    ),
              ),
              const SizedBox(height: 16),
              _buildSettingItem(
                context,
                'Terms of Service',
                Icons.description,
                onTap: () {
                  // Show terms of service
                },
              ),
              _buildSettingItem(
                context,
                'Privacy Policy',
                Icons.privacy_tip,
                onTap: () {
                  // Show privacy policy
                },
              ),
              _buildSettingItem(
                context,
                'App Version',
                Icons.info,
                subtitle: '1.0.0',
                onTap: () {
                  // Show app version info
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context,
    String title,
    IconData icon, {
    String? subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: isDestructive ? Colors.red.withOpacity(0.2) : const Color(0xFF1A1E3F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: isDestructive ? Colors.red : Colors.white,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: isDestructive ? Colors.red : null,
            ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withOpacity(0.7),
                  ),
            )
          : null,
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.white,
      ),
      onTap: onTap,
    );
  }

  Widget _buildSwitchSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E3F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFFFFD700),
      ),
    );
  }

  Widget _buildDropdownSettingItem(
    BuildContext context,
    String title,
    IconData icon,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1E3F),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      trailing: DropdownButton<String>(
        value: value,
        icon: const Icon(
          Icons.arrow_drop_down,
          color: Colors.white,
        ),
        elevation: 16,
        style: Theme.of(context).textTheme.bodyLarge,
        underline: Container(
          height: 0,
        ),
        dropdownColor: const Color(0xFF1A1E3F),
        onChanged: onChanged,
        items: options.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
}
