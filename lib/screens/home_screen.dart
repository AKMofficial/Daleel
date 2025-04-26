import 'package:flutter/material.dart';
import 'package:daleel/utils/show_place_summary.dart'; 
import 'package:daleel/screens/ar_navigation_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFloor = 'الطابق الأول'; 

  final List<String> _floorOptions = [
    'الطابق الثاني', 
    'الطابق الأول', 
    'الطابق الأرضي'
  ];

  late TransformationController _transformationController;

  double _userLocationX = 620.0; 
  double _userLocationY = 160.0; 

  double _boxX = 236.0;
  double _boxY = 15.0;
  double _boxWidth = 120.0;
  double _boxHeight = 100.0;
  double _boxBorderWidth = 0;

  bool _showNavigationPath = false;
  List<Offset> _navigationPath = [];
  final double _navigationLineWidth = 8.0;
  final Color _navigationLineColor = Colors.blue.shade700;

  bool _isNavigating = false; 
  String? _navigationTime;
  String? _navigationDistance;

  bool _isMapExpanded = false;

  final Map<String, dynamic> _boxPlaceData = const {
      'id': 'classroom_36',
      'name': 'قاعة 36',
      'building': 'مبنى 31، الطابق الأول',
      'icon': Icons.class_outlined,
      'walkTime': 'المدة 1 دقيقة', 
      'distance': 'المسافة 18 متر' 
  };

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    final initialMatrix = Matrix4.identity()
      ..translate(-30.0, 0.0)
      ..scale(0.6);
    _transformationController.value = initialMatrix;
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isMapExpanded) {
      const double searchBarHeightEstimate = 70;
      const double quickLinksHeightEstimate = 60;
      final double topPadding = MediaQuery.of(context).padding.top;
      final double totalTopOffset = topPadding + searchBarHeightEstimate + quickLinksHeightEstimate;

      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
               top: totalTopOffset,
               left: 0,
               right: 0,
               bottom: 0,
               child: _buildMiniMapPlaceholder(theme, isExpanded: true), 
            ),
            
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
              child: _buildSearchBar(theme),
            ),
            
            Positioned(
              top: topPadding + searchBarHeightEstimate,
              left: 16,
              right: 16,
              child: Container(
                color: Colors.transparent,
                child: _buildQuickLinks(theme),
              ),
            ),
            
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom + 10, 
              left: 16,
              right: 16,
              child: Container(
                height: 50, 
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      top: 0,
                      bottom: 0,
                      child: _buildFloorSwitcherButton(theme),
                    ),
                    
                    Positioned(
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: Material(
                        color: theme.colorScheme.surface.withOpacity(0.9),
                        shape: const CircleBorder(),
                        elevation: 4.0,
                        child: IconButton(
                          icon: Icon(Icons.fullscreen_exit, color: theme.colorScheme.onSurface),
                          iconSize: 24,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          splashRadius: 24,
                          onPressed: () {
                            setState(() {
                              _isMapExpanded = false;
                              final initialMatrix = Matrix4.identity()
                                ..translate(-30.0, 0.0)
                                ..scale(0.6);
                              _transformationController.value = initialMatrix;
                            });
                          },
                          tooltip: 'الخروج من وضع التوسيع',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: _isNavigating ? MediaQuery.of(context).padding.top + 70 : 16.0,
                left: 16.0, 
                right: 16.0
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                if (!_isNavigating) _buildSearchBar(theme), 
                if (!_isNavigating) const SizedBox(height: 20),
   
                if (!_isNavigating)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 10.0),
                    child: Text(
                      'وصول سريع', 
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ),
                if (!_isNavigating) _buildQuickLinks(theme), 
                if (!_isNavigating) const SizedBox(height: 20),

                if (!_isNavigating)
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0, bottom: 10.0),
                    child: Text(
                      'الخريطة', 
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                  ),

                Expanded(
                  child: _buildMiniMapPlaceholder(theme, isExpanded: false), 
                ),
                SizedBox(height: _isNavigating ? 80 : 16),
              ],
            ),
          ),
          
          if (_isNavigating) 
            _buildNavigationControls(theme),

          Positioned(
            top: _isNavigating ? MediaQuery.of(context).padding.top + 15 : null,
            left: _isNavigating ? 16 : null,
            bottom: !_isNavigating ? 30 : null, 
            right: !_isNavigating ? 30 : null,
            child: Container(
              margin: _isNavigating ? const EdgeInsets.only(bottom: 15) : null,
              decoration: _isNavigating ? BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
              ) : null,
              padding: _isNavigating ? const EdgeInsets.only(bottom: 5) : null,
              child: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ARNavigationScreen(
                        walkTime: _navigationTime ?? _boxPlaceData['walkTime'] as String?,
                        distance: _navigationDistance ?? _boxPlaceData['distance'] as String?,
                      ),
                    ),
                  );
                },
                label: const Text('الواقع المعزز'),
                icon: const Icon(Icons.view_in_ar_rounded, size: 24),
                backgroundColor: theme.primaryColor,
                foregroundColor: theme.colorScheme.onPrimary,
                tooltip: 'الواقع المعزز', 
                elevation: 2.0,
                extendedPadding: const EdgeInsets.symmetric(horizontal: 20), 
                extendedIconLabelSpacing: 8, 
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationControls(ThemeData theme) {
    return Positioned(
      bottom: 0, 
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: 10, 
          bottom: MediaQuery.of(context).padding.bottom + 10,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
           color: theme.scaffoldBackgroundColor, 
           border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
           boxShadow: [
             BoxShadow(
               color: Colors.black.withOpacity(0.1),
               blurRadius: 4,
               offset: const Offset(0, -2), 
             )
           ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_navigationTime != null || _navigationDistance != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_navigationTime != null)
                    Text(
                      _navigationTime!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  if (_navigationDistance != null)
                    Text(
                      _navigationDistance!,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                ],
              ),
            
            if (_navigationTime == null && _navigationDistance == null) Spacer(),

            TextButton.icon(
              icon: Icon(Icons.close, color: theme.colorScheme.error),
              label: Text(
                'إلغاء',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              onPressed: () {
                setState(() {
                  _isNavigating = false;
                  _showNavigationPath = false;
                  _navigationTime = null;
                  _navigationDistance = null;
                  _navigationPath = [];

                  final initialMatrix = Matrix4.identity()
                    ..translate(-30.0, 0.0) 
                    ..scale(0.6);          
                  _transformationController.value = initialMatrix;
                });
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: theme.colorScheme.error.withOpacity(0.5))
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return TextField(
      textAlign: TextAlign.right, 
      decoration: InputDecoration(
        hintText: 'ابحث عن مبنى، قاعة، أو خدمة...', 
        prefixIcon: Icon(Icons.search, color: theme.primaryColor),
        suffixIcon: Icon(Icons.mic, color: theme.primaryColor),
        filled: true,
        fillColor: theme.colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: BorderSide.none, 
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
      ),
      
      onSubmitted: (value) {
        print("Search submitted: $value");
      },
    );
  }

  Widget _buildQuickLinks(ThemeData theme) {
    
    final List<Map<String, dynamic>> quickLinks = [
      {'icon': Icons.mosque_outlined, 'label': 'أقرب مصلى'}, 
      {'icon': Icons.wc_outlined, 'label': 'أقرب دورة مياه'}, 
      {'icon': Icons.local_cafe_outlined, 'label': 'أقرب مقهى'}, 
      {'icon': Icons.restaurant_outlined, 'label': 'أقرب مطعم'}, 
    ];

    return SizedBox(
      height: 50, 
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: quickLinks.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final link = quickLinks[index];
          return InkWell(
             onTap: () {
              
              print("Quick link tapped: ${link['label']}");
            },
            borderRadius: BorderRadius.circular(25.0), 
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.15), 
                borderRadius: BorderRadius.circular(25.0), 
                border: Border.all( 
                   color: theme.colorScheme.secondary.withOpacity(0.3), 
                   width: 1,
                 ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min, 
                children: [
                  Icon(
                    link['icon'],
                    color: theme.primaryColor,
                    size: 20, 
                  ),
                  const SizedBox(width: 8),
                  Text(
                    link['label'],
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFloorSwitcherButton(ThemeData theme) {
    return PopupMenuButton<String>(
      onSelected: (String result) {
        setState(() {
          _selectedFloor = result;
          print("Selected floor: $_selectedFloor");
        });
      },
      itemBuilder: (BuildContext context) => _floorOptions
          .map((String floor) => PopupMenuItem<String>(
                value: floor,
                child: Text(floor, style: TextStyle(color: theme.colorScheme.onSurface)),
              ))
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: theme.primaryColor.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ]
        ),
        child: Row(
           mainAxisSize: MainAxisSize.min,
           children: [
             Icon(Icons.layers_outlined, size: 18, color: theme.colorScheme.onPrimary),
             SizedBox(width: 6),
             Text(
                _selectedFloor,
                style: TextStyle(fontSize: 14, color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w500)
              ),
             SizedBox(width: 2),
             Icon(Icons.arrow_drop_down, size: 20, color: theme.colorScheme.onPrimary),
           ],
        ),
      ),
    );
  }

  Widget _buildMiniMapPlaceholder(ThemeData theme, {bool isExpanded = false}) {
    double? containerHeight = isExpanded ? null : 
                             _isNavigating ? MediaQuery.of(context).size.height * 0.7 : 
                             300;

    return Container(
      height: containerHeight,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, 
        borderRadius: isExpanded ? BorderRadius.zero : BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: InteractiveViewer(
                transformationController: _transformationController, 
                minScale: 0.5, 
                maxScale: 4.0, 
                constrained: false, 
                boundaryMargin: EdgeInsets.zero, 
                panEnabled: true, 
                scaleEnabled: true, 
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/images/map.png', 
                      fit: BoxFit.contain, 
                      errorBuilder: (context, error, stackTrace) {
                         return Center(
                           child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                 Icon(Icons.error_outline, size: 40, color: theme.colorScheme.error),
                                 const SizedBox(height: 8),
                                 Text('تعذر تحميل الخريطة', style: theme.textTheme.bodySmall),
                              ],
                           ),
                         );
                      },
                      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded) {
                          return child;
                        }
                        return AnimatedOpacity(
                          opacity: frame == null ? 0 : 1,
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeOut,
                          child: child,
                        );
                      },
                    ),
                     if (_showNavigationPath)
                       CustomPaint(
                         size: Size.infinite,
                         painter: _NavigationPathPainter(
                           points: _navigationPath,
                           color: _navigationLineColor,
                           strokeWidth: _navigationLineWidth,
                         ),
                       ),
                    Positioned(
                      left: _userLocationX,
                      top: _userLocationY,
                      child: Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3), 
                          boxShadow: [
                             BoxShadow(
                               color: Colors.black.withOpacity(0.3),
                               blurRadius: 4,
                               offset: const Offset(0, 1),
                             )
                          ]
                        ),
                      ),
                    ),
                    Positioned(
                      left: _boxX,
                      top: _boxY,
                      child: InkWell(
                        onTap: () {
                          print("Tappable box tapped!");
                          showPlaceSummaryBottomSheet(
                            context,
                            _boxPlaceData,
                            onStartNavigation: () {
                              setState(() {
                                final markerRadius = 12.5; 
                                final startPoint = Offset(_userLocationX + markerRadius, _userLocationY + markerRadius); 
                                
                                final horizontalDist1 = 60.0;
                                final verticalDist = 39.0; 

                                final point2 = Offset(startPoint.dx - horizontalDist1, startPoint.dy);

                                final point3 = Offset(point2.dx, point2.dy - verticalDist);

                                final endPointX = _boxX + (_boxWidth / 2); 
                                final endPointY = _boxY + _boxHeight; 
                                final endPoint = Offset(endPointX, endPointY);

                                final point4 = Offset(endPoint.dx, point3.dy);

                                _navigationPath = [ startPoint, point2, point3, point4, endPoint ];
                                _showNavigationPath = true;
                                
                                _isNavigating = true;
                                _navigationTime = _boxPlaceData['walkTime'] as String?;
                                _navigationDistance = _boxPlaceData['distance'] as String?;

                                const double zoomScale = 1.8;
                                final Matrix4 newMatrix = Matrix4.identity()

                                  ..translate(-startPoint.dx * zoomScale + MediaQuery.of(context).size.width / 1.8, 
                                            -startPoint.dy * zoomScale + MediaQuery.of(context).size.height / 3) // Keep vertical centering
                                  ..scale(zoomScale); 
                                _transformationController.value = newMatrix;
                              });
                            },
                          );
                        },
                        child: Container(
                          width: _boxWidth,
                          height: _boxHeight,
                          decoration: BoxDecoration(
                             color: Colors.transparent,
                             border: _boxBorderWidth > 0.01
                               ? Border.all(
                                   color: Colors.red,
                                   width: _boxBorderWidth, 
                                 )
                               : null,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (!_isNavigating && !isExpanded)
              Positioned(
                top: 10,
                left: 10,
                child: _buildFloorSwitcherButton(theme),
              ),
            if (!isExpanded && !_isNavigating)
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: theme.primaryColor,
                  shape: const CircleBorder(),
                  elevation: 2.0,
                  child: IconButton(
                    icon: Icon(Icons.fullscreen, color: theme.colorScheme.onPrimary), 
                    iconSize: 24,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    splashRadius: 24,
                    onPressed: () { 
                      setState(() {
                        _isMapExpanded = true;
                        
                        const double expandScale = 1.2; 
                        
                        final double screenWidth = MediaQuery.of(context).size.width;
                        final double screenHeight = MediaQuery.of(context).size.height;
                        final double topPadding = MediaQuery.of(context).padding.top;
                        const double searchBarHeightEstimate = 70;

                        final double verticalTranslation = topPadding + searchBarHeightEstimate;

                        final Matrix4 expandMatrix = Matrix4.identity()
                          ..translate(-_userLocationX * expandScale + screenWidth / 2, 
                                      verticalTranslation) 
                          ..scale(expandScale); 
                        _transformationController.value = expandMatrix;
                      });
                    },
                    tooltip: 'توسيع الخريطة',
                  ),
                ),
              ),
        ],
      ),
    );
  }
}

class _NavigationPathPainter extends CustomPainter {
  final List<Offset> points;
  final Color color;
  final double strokeWidth;

  _NavigationPathPainter({required this.points, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.length < 2) return;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);
    
    for (int i = 1; i < points.length; i++) {
      path.lineTo(points[i].dx, points[i].dy);
    }
    
    canvas.drawPath(path, paint);
    
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
      
    canvas.drawCircle(points.first, strokeWidth / 2, dotPaint);
    canvas.drawCircle(points.last, strokeWidth / 2, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _NavigationPathPainter oldDelegate) {
    return oldDelegate.points != points || 
           oldDelegate.color != color || 
           oldDelegate.strokeWidth != strokeWidth;
  }
} 