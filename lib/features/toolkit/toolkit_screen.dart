import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../core/theme.dart';
import '../../core/models/document.dart';
import '../../core/state/app_state.dart';
import '../../core/state/app_state_provider.dart';

class ToolkitScreen extends StatefulWidget {
  const ToolkitScreen({super.key});

  @override
  State<ToolkitScreen> createState() => _ToolkitScreenState();
}

class _ToolkitScreenState extends State<ToolkitScreen> {
  // Navigation stack indicator: null = main grid, others = specific tool view
  String? _activeToolId;
  
  // States for interactive tools
  final List<String> _selectedMergeIds = [];
  String? _selectedCompressId;
  double _compressSliderVal = 0.5; // 50% quality compression
  String? _selectedSplitId;
  final List<int> _selectedSplitPages = [];
  String? _selectedManageId;
  final List<int> _selectedManagePages = [];
  
  final TextEditingController _toolNameController = TextEditingController();

  @override
  void dispose() {
    _toolNameController.dispose();
    super.dispose();
  }

  void _resetToolStates() {
    setState(() {
      _activeToolId = null;
      _selectedMergeIds.clear();
      _selectedCompressId = null;
      _compressSliderVal = 0.5;
      _selectedSplitId = null;
      _selectedSplitPages.clear();
      _selectedManageId = null;
      _selectedManagePages.clear();
      _toolNameController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = AppStateProvider.of(context);

    if (_activeToolId == null) {
      return _buildDashboard(state);
    } else if (_activeToolId == 'merge') {
      return _buildMergeTool(state);
    } else if (_activeToolId == 'compress') {
      return _buildCompressTool(state);
    } else if (_activeToolId == 'split') {
      return _buildSplitTool(state);
    } else if (_activeToolId == 'manage') {
      return _buildManageTool(state);
    }
    
    return _buildDashboard(state);
  }

  // 1. TOOLKIT MAIN GRID DASHBOARD
  Widget _buildDashboard(AppState state) {
    final isDark = state.isDarkMode;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PDF Toolkit',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.getTextPrimary(isDark)),
          ),
          const SizedBox(height: 4),
          Text(
            'Quick PDF utilities for your documents.',
            style: TextStyle(fontSize: 12, color: AppTheme.getTextSecondary(isDark)),
          ),
          const SizedBox(height: 24),
          
          Expanded(
            child: ListView(
              children: [
                _buildToolCard(
                  id: 'merge',
                  title: 'Merge PDFs',
                  desc: 'Combine multiple files into one document',
                  icon: LucideIcons.merge,
                  color: AppTheme.primaryLight,
                ),
                const SizedBox(height: 12),
                _buildToolCard(
                  id: 'compress',
                  title: 'Compress PDF',
                  desc: 'Reduce document file size',
                  icon: LucideIcons.minimize2,
                  color: AppTheme.success,
                ),
                const SizedBox(height: 12),
                _buildToolCard(
                  id: 'split',
                  title: 'Split PDF',
                  desc: 'Extract specific pages from document',
                  icon: LucideIcons.split,
                  color: AppTheme.warning,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolCard({
    required String id,
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    final state = AppStateProvider.of(context);
    final isDark = state.isDarkMode;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _activeToolId = id;
          _toolNameController.text = '${title.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch ~/ 10000}';
        });
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: AppTheme.glassCard(isDark),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppTheme.getTextPrimary(isDark),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    desc,
                    style: TextStyle(
                      color: AppTheme.getTextSecondary(isDark),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              color: AppTheme.textMuted,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  void _showProUnlockDialog() {
    final state = AppStateProvider.of(context);
    final isDark = state.isDarkMode;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppTheme.surfaceDark : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(LucideIcons.crown, color: AppTheme.warning),
            const SizedBox(width: 8),
            Text('Go Pro Feature', style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        content: Text(
          'Managing, deleting, and rotating pages of existing PDFs requires the Pro Lifetime Unlock (\$2.99). Upgrade now!',
          style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final state = AppStateProvider.of(context);
              state.toggleProStatus();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pro Tier Unlocked!'), backgroundColor: AppTheme.success),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Unlock Pro', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // 2. MERGE PDF UTILITY
  Widget _buildMergeTool(AppState state) {
    final docs = state.documents;
    final isDark = state.isDarkMode;
    
    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Merge Documents'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: _resetToolStates,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select PDFs to Merge',
              style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: docs.length,
                itemBuilder: (context, index) {
                  final doc = docs[index];
                  final isSelected = _selectedMergeIds.contains(doc.id);
                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (val) {
                      setState(() {
                        if (val == true) {
                          _selectedMergeIds.add(doc.id);
                        } else {
                          _selectedMergeIds.remove(doc.id);
                        }
                      });
                    },
                    secondary: const Icon(LucideIcons.fileText, color: AppTheme.primaryLight),
                    title: Text(doc.name, style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontSize: 13, fontWeight: FontWeight.bold)),
                    subtitle: Text('${doc.pages.length} pgs • ${doc.sizeInMb} MB', style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 10)),
                    activeColor: AppTheme.primary,
                    checkColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            // Custom Name Input
            Text('New File Name', style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 11)),
            const SizedBox(height: 4),
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.surfaceDark : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
              ),
              child: TextField(
                controller: _toolNameController,
                style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontSize: 13),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _selectedMergeIds.length < 2
                    ? null
                    : () async {
                        final toMerge = state.documents.where((d) => _selectedMergeIds.contains(d.id)).toList();
                        
                        try {
                          // Show loading
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                              child: CircularProgressIndicator(color: AppTheme.primaryLight),
                            ),
                          );
                          
                          final merged = await state.performMerge(toMerge, _toolNameController.text.trim());
                          
                          if (mounted) {
                            Navigator.pop(context); // Close loading
                            _resetToolStates();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Merged into ${merged.name}!'), backgroundColor: AppTheme.success),
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            Navigator.pop(context); // Close loading
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Merge failed: $e'), backgroundColor: AppTheme.danger),
                            );
                          }
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  disabledBackgroundColor: isDark ? AppTheme.surfaceDark : Colors.grey.shade300,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Merge Selected files', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 3. COMPRESS PDF UTILITY
  Widget _buildCompressTool(AppState state) {
    final docs = state.documents;
    final isDark = state.isDarkMode;
    Document? selectedDoc;
    if (_selectedCompressId != null) {
      selectedDoc = docs.firstWhere((d) => d.id == _selectedCompressId);
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Compress PDF'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: _resetToolStates,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select PDF to Compress',
              style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedCompressId,
              dropdownColor: isDark ? AppTheme.surfaceDark : Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppTheme.surfaceDark : Colors.white,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? AppTheme.borderDark : AppTheme.borderLight), borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.primaryLight), borderRadius: BorderRadius.circular(12)),
              ),
              items: docs.map((doc) {
                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text('${doc.name} (${doc.sizeInMb} MB)', style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontSize: 13)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedCompressId = val;
                });
              },
            ),
            
            if (selectedDoc != null) ...[
              const SizedBox(height: 30),
              Text(
                'Compression Quality: ${(_compressSliderVal * 100).toInt()}%',
                style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontWeight: FontWeight.bold, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Slider(
                value: _compressSliderVal,
                min: 0.1,
                max: 0.9,
                activeColor: AppTheme.success,
                inactiveColor: isDark ? AppTheme.borderDark : AppTheme.borderLight,
                onChanged: (val) {
                  setState(() {
                    _compressSliderVal = val;
                  });
                },
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: AppTheme.glassCard(isDark),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Original Size', style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 11)),
                        Text('${selectedDoc.sizeInMb} MB', style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontWeight: FontWeight.bold, fontSize: 14)),
                      ],
                    ),
                    const Icon(LucideIcons.arrowRight, color: AppTheme.textMuted),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Estimated Size', style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 11)),
                        Text(
                          '${(selectedDoc.sizeInMb * _compressSliderVal).toStringAsFixed(2)} MB',
                          style: const TextStyle(color: AppTheme.success, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Show loading
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(color: AppTheme.success),
                        ),
                      );
                      
                      final compressed = await state.performCompress(selectedDoc!, _compressSliderVal);
                      
                      if (mounted) {
                        Navigator.pop(context); // Close loading
                        _resetToolStates();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Compressed PDF saved as ${compressed.name}!'), backgroundColor: AppTheme.success),
                        );
                      }
                    } catch (e) {
                      if (mounted) {
                        Navigator.pop(context); // Close loading
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Compression failed: $e'), backgroundColor: AppTheme.danger),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.success,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Compress and Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 4. SPLIT PDF UTILITY
  Widget _buildSplitTool(AppState state) {
    final docs = state.documents;
    final isDark = state.isDarkMode;
    Document? selectedDoc;
    if (_selectedSplitId != null) {
      selectedDoc = docs.firstWhere((d) => d.id == _selectedSplitId);
    }

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgDark : AppTheme.bgLight,
      appBar: AppBar(
        title: const Text('Split Document'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: _resetToolStates,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select PDF to Split',
              style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedSplitId,
              dropdownColor: isDark ? AppTheme.surfaceDark : Colors.white,
              decoration: InputDecoration(
                filled: true,
                fillColor: isDark ? AppTheme.surfaceDark : Colors.white,
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: isDark ? AppTheme.borderDark : AppTheme.borderLight), borderRadius: BorderRadius.circular(12)),
              ),
              items: docs.map((doc) {
                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text('${doc.name} (${doc.pages.length} pages)', style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontSize: 13)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedSplitId = val;
                  _selectedSplitPages.clear();
                });
              },
            ),
            
            if (selectedDoc != null) ...[
              const SizedBox(height: 20),
              Text(
                'Select Pages to Extract',
                style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 11, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 1,
                  ),
                  itemCount: selectedDoc.pages.length,
                  itemBuilder: (context, idx) {
                    final isChecked = _selectedSplitPages.contains(idx);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            _selectedSplitPages.remove(idx);
                          } else {
                            _selectedSplitPages.add(idx);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isChecked ? AppTheme.primaryGlow : (isDark ? AppTheme.surfaceDark : Colors.white),
                          border: Border.all(color: isChecked ? AppTheme.primaryLight : (isDark ? AppTheme.borderDark : AppTheme.borderLight), width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${idx + 1}', style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              Icon(
                                isChecked ? LucideIcons.check : LucideIcons.plus,
                                size: 12,
                                color: isChecked ? AppTheme.primaryLight : AppTheme.textMuted,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              Text('New File Name', style: TextStyle(color: AppTheme.getTextSecondary(isDark), fontSize: 11)),
              const SizedBox(height: 4),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.surfaceDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? AppTheme.borderDark : AppTheme.borderLight),
                ),
                child: TextField(
                  controller: _toolNameController,
                  style: TextStyle(color: AppTheme.getTextPrimary(isDark), fontSize: 13),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _selectedSplitPages.isEmpty
                      ? null
                      : () async {
                          try {
                            // Show loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(color: AppTheme.primaryLight),
                              ),
                            );
                            
                            final splitDoc = await state.performSplit(selectedDoc!, _selectedSplitPages, _toolNameController.text.trim());
                            
                            if (mounted) {
                              Navigator.pop(context); // Close loading
                              _resetToolStates();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Extracted ${splitDoc.pages.length} pages into ${splitDoc.name}!'), backgroundColor: AppTheme.success),
                              );
                            }
                          } catch (e) {
                            if (mounted) {
                              Navigator.pop(context); // Close loading
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Split failed: $e'), backgroundColor: AppTheme.danger),
                              );
                            }
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    disabledBackgroundColor: isDark ? AppTheme.surfaceDark : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  ),
                  child: const Text('Extract Pages', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // 5. MANAGE PAGES UTILITY (PRO)
  Widget _buildManageTool(AppState state) {
    final docs = state.documents;
    Document? selectedDoc;
    if (_selectedManageId != null) {
      selectedDoc = docs.firstWhere((d) => d.id == _selectedManageId);
    }

    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        title: const Text('Manage Pages'),
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowLeft),
          onPressed: _resetToolStates,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Document to Edit',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _selectedManageId,
              dropdownColor: AppTheme.surfaceDark,
              decoration: InputDecoration(
                filled: true,
                fillColor: AppTheme.surfaceDark,
                enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: AppTheme.borderDark), borderRadius: BorderRadius.circular(12)),
              ),
              items: docs.map((doc) {
                return DropdownMenuItem<String>(
                  value: doc.id,
                  child: Text('${doc.name} (${doc.pages.length} pages)', style: const TextStyle(color: Colors.white, fontSize: 13)),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _selectedManageId = val;
                  _selectedManagePages.clear();
                });
              },
            ),
            
            if (selectedDoc != null) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Select Pages', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                  Text('${_selectedManagePages.length} pages selected', style: const TextStyle(color: AppTheme.primaryLight, fontSize: 11)),
                ],
              ),
              const SizedBox(height: 8),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: selectedDoc.pages.length,
                  itemBuilder: (context, idx) {
                    final isChecked = _selectedManagePages.contains(idx);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isChecked) {
                            _selectedManagePages.remove(idx);
                          } else {
                            _selectedManagePages.add(idx);
                          }
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isChecked ? AppTheme.primaryGlow : AppTheme.surfaceDark,
                          border: Border.all(color: isChecked ? AppTheme.primaryLight : AppTheme.borderDark, width: 1.5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Text('${idx + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Icon(
                                isChecked ? LucideIcons.checkCircle : LucideIcons.circle,
                                size: 16,
                                color: isChecked ? AppTheme.primaryLight : AppTheme.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              
              // Edit Operations footer actions
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(LucideIcons.rotateCw, size: 16, color: Colors.white),
                      label: const Text('Rotate 90°', style: TextStyle(color: Colors.white)),
                      onPressed: _selectedManagePages.isEmpty
                          ? null
                          : () {
                              state.performRotatePages(selectedDoc!.id, _selectedManagePages);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Selected pages rotated successfully!'), backgroundColor: AppTheme.success),
                              );
                              _resetToolStates();
                            },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppTheme.borderDark),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(LucideIcons.trash2, size: 16, color: Colors.white),
                      label: const Text('Delete Pages', style: TextStyle(color: Colors.white)),
                      onPressed: _selectedManagePages.isEmpty
                          ? null
                          : () {
                              state.performDeletePages(selectedDoc!.id, _selectedManagePages);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Selected pages deleted successfully!'), backgroundColor: AppTheme.success),
                              );
                              _resetToolStates();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.danger,
                        disabledBackgroundColor: AppTheme.surfaceDark,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
