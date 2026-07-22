import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trackify/core/config/network/api_host.dart';
import 'package:trackify/core/config/network/network_api_service.dart';
import 'package:trackify/core/utils/shared_preferences.dart';
import 'package:trackify/core/widgets/trackify_loader.dart';
import 'package:trackify/l10n/app_localizations.dart';

class CurrentSessionsScreen extends StatefulWidget {
  const CurrentSessionsScreen({super.key});

  @override
  State<CurrentSessionsScreen> createState() => _CurrentSessionsScreenState();
}

class _CurrentSessionsScreenState extends State<CurrentSessionsScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _sessions = [];
  String? _deletingSessionId;

  @override
  void initState() {
    super.initState();
    _fetchSessions();
  }

  Future<void> _fetchSessions() async {
    if (mounted) {
      setState(() {
        _isLoading = true;
      });
    }

    final userId = await AppPreference.instance.get(
      key: AppPreference.KEY_USER_ID,
    );

    if (userId.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    final url = ApiURL.getSessions(userId);
    final apiService = NetworkApiService();
    final result = await apiService.getGetApiResponse(url);

    result.fold(
      (failure) {
        debugPrint("Error fetching sessions: ${failure.message}");
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      },
      (response) {
        try {
          List dynamicList = [];
          if (response is Map<String, dynamic> && response['data'] is List) {
            dynamicList = response['data'] as List;
          } else if (response is List) {
            dynamicList = response;
          }

          if (mounted) {
            setState(() {
              _sessions = dynamicList
                  .map((item) => Map<String, dynamic>.from(item as Map))
                  .toList();
              _isLoading = false;
            });
          }
        } catch (e) {
          debugPrint("Error parsing sessions: $e");
          if (mounted) {
            setState(() {
              _isLoading = false;
            });
          }
        }
      },
    );
  }

  Future<void> _confirmAndLogout(String sessionId, String deviceName) async {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to log out from "$deviceName"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _executeLogout(sessionId);
    }
  }

  Future<void> _executeLogout(String sessionId) async {
    if (mounted) {
      setState(() {
        _deletingSessionId = sessionId;
      });
    }

    final url = ApiURL.logoutSession(sessionId);
    final apiService = NetworkApiService();
    final result = await apiService.getPostApiResponse(url, {});

    result.fold(
      (failure) {
        if (mounted) {
          setState(() {
            _deletingSessionId = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to logout session: ${failure.message}')),
          );
        }
      },
      (response) {
        if (mounted) {
          setState(() {
            _deletingSessionId = null;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Session logged out successfully')),
          );
          _fetchSessions();
        }
      },
    );
  }

  String _formatDate(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return DateFormat('d MMM yyyy, hh:mm a').format(dt);
    } catch (_) {
      return rawDate;
    }
  }

  String _getTimeAgo(String? rawDate) {
    if (rawDate == null || rawDate.isEmpty) return '';
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);

      if (diff.inDays >= 365) {
        final years = (diff.inDays / 365).floor();
        return years == 1 ? '1 year' : '$years years';
      } else if (diff.inDays >= 30) {
        final months = (diff.inDays / 30).floor();
        return months == 1 ? '1 month' : '$months months';
      } else if (diff.inDays >= 1) {
        return diff.inDays == 1 ? '1 day' : '${diff.inDays} days';
      } else if (diff.inHours >= 1) {
        return diff.inHours == 1 ? '1 hour' : '${diff.inHours} hours';
      } else if (diff.inMinutes >= 1) {
        return diff.inMinutes == 1 ? '1 min' : '${diff.inMinutes} mins';
      } else {
        return 'Just now';
      }
    } catch (_) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Split active vs other sessions
    final activeSessions = _sessions.where((s) => s['isActive'] == true).toList();
    final otherSessions = _sessions.where((s) => s['isActive'] != true).toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.colorScheme.onSurface,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.currentSessions,
          style: TextStyle(
            fontSize: 20.0,
            color: theme.colorScheme.onSurface,
          ),
        ),
        surfaceTintColor: Colors.transparent,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchSessions,
        child: _isLoading
            ? const Center(child: TrackifyLoader())
            : _sessions.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.devices_other,
                            size: 64,
                            color: theme.colorScheme.onSurface.withOpacity(0.4),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No active sessions found',
                            style: TextStyle(
                              fontSize: 16,
                              color: theme.colorScheme.onSurface.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (activeSessions.isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            color: theme.dividerColor.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: const Text(
                              'Active Session',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...activeSessions.map((session) {
                            return _buildSessionItem(
                              context: context,
                              l10n: l10n,
                              session: session,
                              isActiveDevice: true,
                            );
                          }),
                        ],
                        if (otherSessions.isNotEmpty || activeSessions.isEmpty) ...[
                          Container(
                            width: double.infinity,
                            color: theme.dividerColor.withOpacity(0.3),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Text(
                              l10n.otherDevices,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ...otherSessions.map((session) {
                            return Column(
                              children: [
                                _buildSessionItem(
                                  context: context,
                                  l10n: l10n,
                                  session: session,
                                  isActiveDevice: false,
                                ),
                                const Divider(height: 1, thickness: 1),
                              ],
                            );
                          }),
                        ],
                      ],
                    ),
                  ),
      ),
    );
  }

  Widget _buildSessionItem({
    required BuildContext context,
    required AppLocalizations l10n,
    required Map<String, dynamic> session,
    required bool isActiveDevice,
  }) {
    final theme = Theme.of(context);
    final sessionId = session['_id']?.toString() ?? '';
    final deviceModel = session['deviceModel']?.toString() ?? 'Unknown Device';
    final osVersion = session['osVersion']?.toString() ?? 'Unknown OS';
    final lastActiveStr = session['lastActive']?.toString() ?? session['createdAt']?.toString() ?? '';
    final formattedLastActive = _formatDate(lastActiveStr);
    final timeAgo = _getTimeAgo(lastActiveStr);
    final isDeletingThis = _deletingSessionId == sessionId;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.android,
            color: theme.colorScheme.onSurface.withOpacity(0.6),
            size: 30,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        deviceModel,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (timeAgo.isNotEmpty)
                      Text(
                        timeAgo,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                if (isActiveDevice)
                  Text(
                    l10n.activeOnThisDevice,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                if (formattedLastActive.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.lastUsed} $formattedLastActive',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
                if (osVersion.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${l10n.osLabel} $osVersion',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.public,
                          size: 18,
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          l10n.chromeNotificationDisabled,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (sessionId.isNotEmpty)
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: isDeletingThis
                              ? null
                              : () => _confirmAndLogout(sessionId, deviceModel),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: theme.colorScheme.error,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                          ),
                          child: isDeletingThis
                              ? SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: theme.colorScheme.error,
                                  ),
                                )
                              : Text(
                                  l10n.logOut,
                                  style: TextStyle(
                                    color: theme.colorScheme.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
