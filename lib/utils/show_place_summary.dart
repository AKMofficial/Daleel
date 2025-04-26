import 'package:flutter/material.dart';
void showPlaceSummaryBottomSheet(
  BuildContext context, 
  Map<String, dynamic> placeData, {
  VoidCallback? onStartNavigation,
}) {
  final theme = Theme.of(context);

  final String name = placeData['name'] ?? 'اسم غير معروف';
  final String building = placeData['building'] ?? '';
  final IconData icon = placeData['icon'] as IconData? ?? Icons.location_on_outlined;
  final String? distance = placeData['distance'] as String?;
  final String? walkTime = placeData['walkTime'] as String?;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    backgroundColor: theme.colorScheme.surface,
    builder: (context) {
      return SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0, bottom: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch, 
                children: [
                  CircleAvatar(
                    radius: 32, 
                    backgroundColor: theme.primaryColor.withOpacity(0.1),
                    child: Icon(icon, color: theme.primaryColor, size: 36),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    building, 
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                  ),
                  const SizedBox(height: 20),
                  // Add Distance & Estimated Time here (if available)
                  if (distance != null || walkTime != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (walkTime != null) ...[
                           Icon(Icons.directions_walk_rounded, size: 18, color: theme.primaryColor),
                           const SizedBox(width: 5),
                           Text(
                             walkTime, 
                             style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor)
                           ),
                        ],
                        if (walkTime != null && distance != null) ...[
                          const SizedBox(width: 4),
                           Text("•", style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor)), 
                          const SizedBox(width: 4),
                        ],
                         if (distance != null) ...[
                           Icon(Icons.route_outlined, size: 18, color: theme.primaryColor),
                           const SizedBox(width: 5),
                           Text(
                             distance, 
                             style: theme.textTheme.bodyMedium?.copyWith(color: theme.primaryColor)
                           ),
                        ],
                      ],
                    ),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    onPressed: () {
                      print("Start navigation to $name");
                      Navigator.pop(context); 
                      onStartNavigation?.call();
                    },
                    style: ElevatedButton.styleFrom(
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                         Icon(Icons.navigation_outlined, size: 18),
                         SizedBox(width: 8),
                         Baseline( 
                            baseline: 14.0, 
                            baselineType: TextBaseline.alphabetic,
                            child: Text('ابدأ الملاحة')
                          ), 
                      ],
                    ),
                  ),
                  const SizedBox(height: 10), 
                ],
              ),
            ),
            Positioned(
              top: 10,
              right: 10,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: theme.colorScheme.secondary,
                tooltip: 'إغلاق',
                onPressed: () => Navigator.pop(context), 
              ),
            ),
          ],
        ),
      );
    },
  );
} 