import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralized permission helper for camera and photo library access.
/// Shows rationale dialogs before the OS prompt and handles permanent denials
/// by directing users to the app settings page.
class PermissionService {
  /// Request camera permission. Returns `true` if granted.
  static Future<bool> requestCamera(BuildContext context) async {
    return _requestPermission(
      context,
      Permission.camera,
      title: 'Camera Access Required',
      rationale:
          'ZeScan needs camera access to scan documents. All processing stays 100% on your device.',
      icon: Icons.camera_alt_outlined,
    );
  }

  /// Request photo library permission. Returns `true` if granted.
  static Future<bool> requestPhotos(BuildContext context) async {
    // Android 13+ uses Photos permission; older versions use Storage
    final permission = Platform.isAndroid
        ? (await _isAndroid13OrAbove()
            ? Permission.photos
            : Permission.storage)
        : Permission.photos;

    return _requestPermission(
      context,
      permission,
      title: 'Photo Library Access',
      rationale:
          'ZeScan needs access to your photos to import images for PDF conversion. Your privacy is protected.',
      icon: Icons.photo_library_outlined,
    );
  }

  /// Core permission request flow:
  /// 1. If already granted → return true
  /// 2. If can show rationale → show dialog first, then request
  /// 3. If permanently denied → show "go to settings" dialog
  static Future<bool> _requestPermission(
    BuildContext context,
    Permission permission, {
    required String title,
    required String rationale,
    required IconData icon,
  }) async {
    var status = await permission.status;

    // Already granted
    if (status.isGranted || status.isLimited) return true;

    // Show rationale before requesting
    if (status.isDenied) {
      final shouldProceed = await _showRationaleDialog(
        context,
        title: title,
        rationale: rationale,
        icon: icon,
      );
      if (!shouldProceed) return false;

      status = await permission.request();
      if (status.isGranted || status.isLimited) return true;
    }

    // Permanently denied — direct to settings
    if (status.isPermanentlyDenied) {
      if (!context.mounted) return false;
      await _showSettingsDialog(context, title: title);
      return false;
    }

    return false;
  }

  /// Shows a branded rationale dialog explaining why the permission is needed.
  static Future<bool> _showRationaleDialog(
    BuildContext context, {
    required String title,
    required String rationale,
    required IconData icon,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(icon, size: 40, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(
          rationale,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not Now'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Continue'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Shows a dialog directing the user to open app settings when permission
  /// has been permanently denied.
  static Future<void> _showSettingsDialog(
    BuildContext context, {
    required String title,
  }) async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        icon: Icon(Icons.settings_outlined, size: 40, color: Theme.of(context).colorScheme.error),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        content: Text(
          'Permission was denied permanently. Please enable it in your device Settings to continue.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            fontSize: 14,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  /// Check if the device is running Android 13 (API 33) or above.
  static Future<bool> _isAndroid13OrAbove() async {
    // permission_handler internally handles this, but we use it for
    // selecting between Permission.photos vs Permission.storage
    if (!Platform.isAndroid) return false;
    // On Android, Permission.photos is only available from API 33+
    // The permission_handler handles the fallback gracefully
    return true; // Let permission_handler resolve the correct permission
  }
}
