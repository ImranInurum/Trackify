import 'package:flutter/material.dart';

class SettingListTile extends StatelessWidget {
    final IconData icon;
    final String title;
    final String? subtitle;
    final bool isSubtitle;
    final bool showArrow;
    final bool showIcon;
    final VoidCallback onTap;
    final Widget? trailing;

    const SettingListTile({
        super.key,
        required this.icon,
        required this.title,
        this.subtitle,
        this.isSubtitle = true,
        required this.showArrow,
        required this.showIcon,
        required this.onTap,
        this.trailing,
    });

    @override
    Widget build(BuildContext context) {
      return ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: isSubtitle ? 8 : 0,
        ),
      leading: showIcon ? Icon(icon, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), size: 28) : null,
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 16,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: isSubtitle == true ? Padding(
        padding: const EdgeInsets.only(top: 4),
        child:Text(
            subtitle ?? "",
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5), fontSize: 13, height: 1.3),
          ),
      ) : null,
      trailing: showArrow
          ? Icon(Icons.arrow_forward_ios, size: 14, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3))
          : trailing,
      onTap: onTap,
    );
    }
}