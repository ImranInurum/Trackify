import 'package:flutter/material.dart';

class ManageAccessScreen extends StatefulWidget {
  const ManageAccessScreen({super.key});

  @override
  State<ManageAccessScreen> createState() => _ManageAccessScreenState();
}

class _ManageAccessScreenState extends State<ManageAccessScreen> {
  final TextEditingController _emailController = TextEditingController();
  final String _selectedRole = 'View Only';

  // Specific permissions
  final Map<String, bool> _permissions = {
    'View Live Location': true,
    'View Trip History': true,
    'Engine Lock / Unlock': false,
    'Receive Alerts': false,
  };
  
  // Dummy data for shared users
  final List<Map<String, dynamic>> _sharedUsers = [
    {
      'email': 'driver@trackify.com',
      'permissions': ['View Live Location', 'View Trip History'],
    },
    {
      'email': 'manager@trackify.com',
      'permissions': ['View Live Location', 'View Trip History', 'Receive Alerts', 'Engine Lock / Unlock'],
    },
  ];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _shareAccess() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an email or mobile number')),
      );
      return;
    }
    
    // Get list of selected permissions
    List<String> selectedPermissions = _permissions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    if (selectedPermissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one permission')),
      );
      return;
    }

    setState(() {
      _sharedUsers.add({
        'email': _emailController.text,
        'permissions': selectedPermissions,
      });
      _emailController.clear();
      // Reset permissions to default
      _permissions.updateAll((key, value) => key.startsWith('View') ? true : false);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Access shared successfully')),
    );
  }

  void _removeAccess(int index) {
    setState(() {
      _sharedUsers.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Access removed')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Manage Access',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Share vehicle access with others',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter email/mobile and select the exact features they can access.',
              style: TextStyle(
                fontSize: 14,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 16),
            
            // Input field and role dropdown
            Material(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: theme.dividerColor),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email or Mobile Number',
                      hintStyle: TextStyle(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                      border: InputBorder.none,
                      icon: Icon(Icons.person_add_alt_1, color: theme.colorScheme.primary),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 8),
                  Text('Select Permissions:', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  ..._permissions.keys.map((String key) {
                    return CheckboxListTile(
                      title: Text(key, style: TextStyle(color: theme.colorScheme.onSurface, fontSize: 14)),
                      value: _permissions[key],
                      activeColor: theme.colorScheme.primary,
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      visualDensity: VisualDensity.compact,
                      dense: true,
                      onChanged: (bool? value) {
                        setState(() {
                          _permissions[key] = value ?? false;
                        });
                      },
                    );
                  }),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _shareAccess,
                      child: const Text('Share Access', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
              ),
            ),
            const SizedBox(height: 24),
            
            // List of shared users
            Text(
              'Shared With',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _sharedUsers.isEmpty
                  ? Center(
                      child: Text(
                        'No users have access yet.',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _sharedUsers.length,
                      itemBuilder: (context, index) {
                        final user = _sharedUsers[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: theme.cardColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: theme.dividerColor),
                            ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.2),
                              child: Icon(Icons.person, color: theme.colorScheme.primary),
                            ),
                            title: Text(
                              user['email'] ?? '',
                              style: TextStyle(color: theme.colorScheme.onSurface),
                            ),
                            subtitle: Text(
                              'Permissions: ${(user['permissions'] as List<String>).join(', ')}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                fontSize: 12,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
                              onPressed: () => _removeAccess(index),
                            ),
                          ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
