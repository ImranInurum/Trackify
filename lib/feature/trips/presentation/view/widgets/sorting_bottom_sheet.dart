import 'package:flutter/material.dart';

class SortingBottomSheet extends StatefulWidget {
  final String initialSortBy;
  final bool initialIsRecentToOldest;
  final Function(String sortBy, bool isRecentToOldest) onApply;

  const SortingBottomSheet({
    super.key,
    required this.initialSortBy,
    required this.initialIsRecentToOldest,
    required this.onApply,
  });

  @override
  State<SortingBottomSheet> createState() => _SortingBottomSheetState();
}

class _SortingBottomSheetState extends State<SortingBottomSheet> {
  late String _selectedSortBy;
  late bool _isRecentToOldest;

  @override
  void initState() {
    super.initState();
    _selectedSortBy = widget.initialSortBy;
    _isRecentToOldest = widget.initialIsRecentToOldest;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF121212) : theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Sorting',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                  fontSize: 22,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close,
                    size: 20,
                    color: theme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1C1C1C) : Colors.grey.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort By',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _SortOptionChip(
                      label: 'Date',
                      isSelected: _selectedSortBy == 'Date',
                      onTap: () => setState(() => _selectedSortBy = 'Date'),
                    ),
                    const SizedBox(width: 10),
                    _SortOptionChip(
                      label: 'Distance',
                      isSelected: _selectedSortBy == 'Distance',
                      onTap: () => setState(() => _selectedSortBy = 'Distance'),
                    ),
                    const SizedBox(width: 10),
                    _SortOptionChip(
                      label: 'Duration',
                      isSelected: _selectedSortBy == 'Duration',
                      onTap: () => setState(() => _selectedSortBy = 'Duration'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                _RadioOption(
                  label: 'Recent to Oldest',
                  isSelected: _isRecentToOldest,
                  onTap: () => setState(() => _isRecentToOldest = true),
                ),
                const SizedBox(height: 20),
                _RadioOption(
                  label: 'Oldest to Recent',
                  isSelected: !_isRecentToOldest,
                  onTap: () => setState(() => _isRecentToOldest = false),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedSortBy = 'Date';
                      _isRecentToOldest = true;
                    });
                  },
                  child: Text(
                    'Back to Default',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(0.5),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onApply(_selectedSortBy, _isRecentToOldest);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _SortOptionChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SortOptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.transparent : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.5),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RadioOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 20,
            width: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
                    child: Container(
                      height: 10,
                      width: 10,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
