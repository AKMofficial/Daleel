import 'package:flutter/material.dart';
import 'package:daleel/utils/show_place_summary.dart';

class SavedPlace {
  final String id; 
  final String name;
  final String roomNumber;
  final IconData icon;

  const SavedPlace({required this.id, required this.name, required this.roomNumber, required this.icon});
}

class SavedScreen extends StatefulWidget {
  const SavedScreen({super.key});

  @override
  State<SavedScreen> createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  bool _isEditing = false; 

  final List<Map<String, dynamic>> _savedPlacesData = [
    {
      'id': '1', 
      'name': 'مكتبة الملك سلمان',
      'building': 'مبنى 27', 
      'icon': Icons.local_library_outlined, 
      'walkTime': 'المدة 6 دقائق', 
      'distance': 'المسافة 500 متر' 
    },
    {
      'id': '2', 
      'name': 'البهو',
      'building': 'مبنى 18', 
      'icon': Icons.account_balance_outlined, 
      'walkTime': 'المدة 8 دقائق', 
      'distance': 'المسافة 600 متر' 
    },
     {
      'id': '3', 
      'name': 'كلية العلوم',
      'building': 'مبنى 4', 
      'icon': Icons.science_outlined, 
      'walkTime': 'المدة 4 دقائق', 
      'distance': 'المسافة 250 متر' 
    },
     {
      'id': '4', 
      'name': 'النادي الثقافي الاجتماعي',
      'building': 'مبنى 31، الطابق الأول', 
      'icon': Icons.groups_outlined, 
      'walkTime': 'المدة 1 دقيقة', 
      'distance': 'المسافة 15 متر' 
    },
  ];

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _deletePlace(String id) {
    setState(() {
      _savedPlacesData.removeWhere((place) => place['id'] == id);
      
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم حذف المكان المفضل'), duration: Duration(seconds: 2)), 
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final Map<String, dynamic> item = _savedPlacesData.removeAt(oldIndex);
      _savedPlacesData.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: _savedPlacesData.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_add_outlined, size: 80, color: theme.colorScheme.secondary.withOpacity(0.5)),
                  const SizedBox(height: 15),
                  Text(
                    'لم تحفظ أي أماكن بعد', 
                    style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.secondary),
                  ),
                  const SizedBox(height: 5),
                   Text(
                    'ابحث عن مكان واضغط على أيقونة الحفظ لإضافته هنا.', 
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary.withOpacity(0.8)),
                  ),
                ],
              ),
            )
          : Stack(
             children: [
                
                _isEditing
                  ? ReorderableListView.builder(
                      padding: const EdgeInsets.only(top: 70, bottom: 90, left: 16, right: 16), 
                      clipBehavior: Clip.none, 
                      itemCount: _savedPlacesData.length,
                      itemBuilder: (context, index) {
                        final placeData = _savedPlacesData[index];
                        return Padding(
                          key: ValueKey(placeData['id']), 
                          padding: const EdgeInsets.only(bottom: 12.0), 
                          child: _buildSavedPlaceTile(context, placeData, theme, index, isEditing: true),
                        );
                      },
                      onReorder: _onReorder,
                      proxyDecorator: (Widget child, int index, Animation<double> animation) {
                        
                         return Material(
                           elevation: 4.0, 
                           color: Colors.transparent, 
                           borderRadius: BorderRadius.circular(15.0),
                           child: child,
                         );
                      },
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.only(top: 70, bottom: 90, left: 16, right: 16), 
                      clipBehavior: Clip.none, 
                      itemCount: _savedPlacesData.length,
                      itemBuilder: (context, index) {
                        final placeData = _savedPlacesData[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0), 
                          child: _buildSavedPlaceTile(context, placeData, theme, index, isEditing: false),
                        );
                      },
                    ),
                 
                 if (_savedPlacesData.isNotEmpty) 
                    Positioned(
                      top: 16, 
                      left: 16, 
                      
                      child: TextButton(
                        onPressed: _toggleEdit,
                        style: TextButton.styleFrom(
                          foregroundColor: theme.primaryColor, 
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          
                          textStyle: theme.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          
                        ),
                        child: Text(_isEditing ? 'تم' : 'تعديل'), 
                      ),
                      
                    ),
                 
                  Positioned(
                      top: 24, 
                      right: 16, 
                      
                      child: Container(
                         padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                         decoration: BoxDecoration(
                           color: theme.colorScheme.background.withOpacity(0.9), 
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Text(
                           'أماكني المفضلة', 
                           style: theme.textTheme.titleMedium?.copyWith( 
                             color: theme.colorScheme.primary, 
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                      ),
                      
                    ),
              ], 
            ),
    );
  }

  
  Widget _buildSavedPlaceTile(BuildContext context, Map<String, dynamic> placeData, ThemeData theme, int index, {required bool isEditing}) {
     
    return Card(
       elevation: 2.0, 
       shadowColor: Colors.black.withOpacity(0.1), 
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
       child: ListTile(
          tileColor: theme.colorScheme.secondary.withOpacity(0.15), 
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)), 
          contentPadding: EdgeInsets.only(
             left: isEditing ? 8 : 16, 
             right: 16,
             top: 12,
             bottom: 12
          ),
          leading: isEditing 
          ? ReorderableDragStartListener( 
              index: index,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0), 
                child: Icon(Icons.drag_indicator, color: theme.colorScheme.onSurface.withOpacity(0.5)), 
              ),
            )
          : CircleAvatar(
            radius: 24, 
            backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
            
            child: Icon(placeData['icon'] as IconData? ?? Icons.location_on_outlined, color: theme.colorScheme.primary, size: 24),
          ),
          
          title: Text(
            placeData['name'] ?? 'اسم غير معروف', 
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          
          subtitle: Text(
              placeData['building'] ?? '', 
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface),
            ),
          trailing: isEditing
          ? IconButton(
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              tooltip: 'حذف', 
              
              onPressed: () => _deletePlace(placeData['id'] ?? ''),
            )
          : Icon(Icons.arrow_forward_ios_rounded, size: 16, color: theme.colorScheme.onSurface.withOpacity(0.4)),
          onTap: isEditing ? null : () { 
             showPlaceSummaryBottomSheet(context, placeData);
          },
        ),
    );
  }
} 