import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../core/theme.dart';

class FeedbackScreen extends StatefulWidget {
  final String type; // 'feedback', 'bug_report', or 'feature_request'

  const FeedbackScreen({super.key, required this.type});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  
  bool _isSubmitting = false;
  String _appVersion = '';
  String _deviceInfo = '';

  @override
  void initState() {
    super.initState();
    _loadDeviceInfo();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadDeviceInfo() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final deviceInfo = DeviceInfoPlugin();
      
      setState(() {
        _appVersion = packageInfo.version;
      });

      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        setState(() {
          _deviceInfo = '${androidInfo.brand} ${androidInfo.model} (Android ${androidInfo.version.release})';
        });
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        setState(() {
          _deviceInfo = '${iosInfo.name} ${iosInfo.model} (iOS ${iosInfo.systemVersion})';
        });
      }
    } catch (e) {
      print('Error loading device info: $e');
    }
  }

  String get _title {
    switch (widget.type) {
      case 'bug_report':
        return 'Report a Bug';
      case 'feature_request':
        return 'Feature Request';
      default:
        return 'Send Feedback';
    }
  }

  IconData get _icon {
    switch (widget.type) {
      case 'bug_report':
        return LucideIcons.bug;
      case 'feature_request':
        return LucideIcons.lightbulb;
      default:
        return LucideIcons.messageSquare;
    }
  }

  Color get _iconColor {
    switch (widget.type) {
      case 'bug_report':
        return AppTheme.danger;
      case 'feature_request':
        return AppTheme.warning;
      default:
        return AppTheme.primaryLight;
    }
  }

  String get _placeholder {
    switch (widget.type) {
      case 'bug_report':
        return 'Describe the bug you encountered...\n\n'
            'Steps to reproduce:\n'
            '1. \n'
            '2. \n'
            '3. \n\n'
            'Expected behavior:\n\n'
            'Actual behavior:';
      case 'feature_request':
        return 'Describe the feature you\'d like to see...\n\n'
            'Use case:\n\n'
            'How it would help:';
      default:
        return 'Share your thoughts about ZeScan...\n\n'
            'What do you like?\n\n'
            'What could be improved?';
    }
  }

  Future<void> _submitFeedback() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await http.post(
        Uri.parse('https://zescan.zeppelinlabs.digital/api/feedback'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'type': widget.type,
          'email': _emailController.text.trim(),
          'subject': _subjectController.text.trim(),
          'message': _messageController.text.trim(),
          'appVersion': _appVersion,
          'deviceInfo': _deviceInfo,
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 201) {
        // Success
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you! Your feedback has been received.'),
            backgroundColor: AppTheme.success,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      } else {
        // Error
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to submit feedback');
      }
    } catch (e) {
      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.danger,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.getBackgroundColor(isDark),
      appBar: AppBar(
        title: Row(
          children: [
            Icon(_icon, color: _iconColor, size: 24),
            const SizedBox(width: 12),
            Text(_title),
          ],
        ),
        backgroundColor: AppTheme.getBackgroundColor(isDark),
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _iconColor.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(_icon, color: _iconColor, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Your input helps us improve ZeScan!\n'
                      'We read every submission carefully.',
                      style: TextStyle(
                        color: AppTheme.getTextPrimary(isDark),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),

            // Email Field (Optional)
            Text(
              'Email (Optional)',
              style: TextStyle(
                color: AppTheme.getTextPrimary(isDark),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(
                color: AppTheme.getTextPrimary(isDark),
              ),
              decoration: InputDecoration(
                hintText: 'your@email.com',
                hintStyle: TextStyle(
                  color: AppTheme.getTextMuted(isDark),
                ),
                helperText: 'Provide your email if you\'d like us to respond',
                helperStyle: TextStyle(
                  color: AppTheme.getTextSecondary(isDark),
                  fontSize: 11,
                ),
                filled: true,
                fillColor: AppTheme.getSurfaceColor(isDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryLight,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  LucideIcons.mail,
                  color: AppTheme.getTextSecondary(isDark),
                ),
              ),
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Subject Field
            Text(
              'Subject *',
              style: TextStyle(
                color: AppTheme.getTextPrimary(isDark),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _subjectController,
              style: TextStyle(
                color: AppTheme.getTextPrimary(isDark),
              ),
              decoration: InputDecoration(
                hintText: 'Brief description',
                hintStyle: TextStyle(
                  color: AppTheme.getTextMuted(isDark),
                ),
                filled: true,
                fillColor: AppTheme.getSurfaceColor(isDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryLight,
                    width: 2,
                  ),
                ),
                prefixIcon: Icon(
                  LucideIcons.text,
                  color: AppTheme.getTextSecondary(isDark),
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Subject is required';
                }
                if (value.trim().length < 3) {
                  return 'Subject must be at least 3 characters';
                }
                if (value.trim().length > 200) {
                  return 'Subject must be less than 200 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Message Field
            Text(
              'Message *',
              style: TextStyle(
                color: AppTheme.getTextPrimary(isDark),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _messageController,
              maxLines: 10,
              maxLength: 2000,
              style: TextStyle(
                color: AppTheme.getTextPrimary(isDark),
              ),
              decoration: InputDecoration(
                hintText: _placeholder,
                hintStyle: TextStyle(
                  color: AppTheme.getTextMuted(isDark),
                  fontSize: 13,
                ),
                filled: true,
                fillColor: AppTheme.getSurfaceColor(isDark),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppTheme.primaryLight,
                    width: 2,
                  ),
                ),
                alignLabelWithHint: true,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Message is required';
                }
                if (value.trim().length < 10) {
                  return 'Message must be at least 10 characters';
                }
                if (value.trim().length > 2000) {
                  return 'Message must be less than 2000 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Device Info Display
            if (_deviceInfo.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.getSurfaceColor(isDark),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.getBorderColor(isDark),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Automatically Included:',
                      style: TextStyle(
                        color: AppTheme.getTextSecondary(isDark),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.smartphone,
                          size: 14,
                          color: AppTheme.getTextMuted(isDark),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _deviceInfo,
                            style: TextStyle(
                              color: AppTheme.getTextMuted(isDark),
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          LucideIcons.package,
                          size: 14,
                          color: AppTheme.getTextMuted(isDark),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Version $_appVersion',
                          style: TextStyle(
                            color: AppTheme.getTextMuted(isDark),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],

            // Submit Button
            SizedBox(
              height: 54,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitFeedback,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _iconColor,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppTheme.getTextMuted(isDark),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(LucideIcons.send, size: 20),
                          const SizedBox(width: 12),
                          Text(
                            _isSubmitting ? 'Sending...' : 'Submit ${_title}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
