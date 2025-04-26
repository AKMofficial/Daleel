import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; 
import 'package:daleel/providers/settings_provider.dart'; 

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _appVersion = '1.0.0'; 

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16.0), 
        children: [
          
          _buildSectionTitle(theme, 'الوصولية'), 
          SwitchListTile(
            title: Text(
              'وضع الملاحة الصوتية', 
               style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'تفعيل التوجيه الصوتي للمكفوفين وضعاف البصر', 
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
              ),
            
            value: settingsProvider.isAccessibilityModeEnabled, 
            onChanged: (bool value) {
               
               settingsProvider.toggleAccessibilityMode(value); 
                 ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('وضع الملاحة الصوتية ${value ? "مُفعّل" : "مُعطّل"}')) 
                );
              
            },
            secondary: Icon(Icons.volume_up_outlined, color: theme.primaryColor),
            activeColor: theme.primaryColor,
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          ),

          _buildSectionTitle(theme, 'المظهر'), 
          SwitchListTile(
            title: Text(
              'الوضع الداكن', 
              style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
             subtitle: Text(
              'فعّل المظهر الداكن للتطبيق', 
              style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
             ),
            value: settingsProvider.isDarkModeEnabled, 
            onChanged: (bool value) {
              settingsProvider.toggleDarkMode(value); 
            },
             secondary: Icon(Icons.dark_mode_outlined, color: theme.primaryColor),
             activeColor: theme.primaryColor,
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          ),

          _buildSectionTitle(theme, 'اللغة'), 
           ListTile(
            leading: Icon(Icons.language_outlined, color: theme.colorScheme.primary),
            title: Text(
              'اللغة', 
               style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
            ),
            
             subtitle: Text(
              'العربية', 
               style: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.7)),
             ),
            
            trailing: Icon(Icons.arrow_forward_ios_rounded, size: 16, color: theme.colorScheme.primary),
            onTap: () {
               
              print("Language selection tapped"); 
               ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سيتم فتح خيارات اللغة هنا قريباً')) 
                );
            },
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
          ),

          
          _buildSectionTitle(theme, 'حول التطبيق'), 
           ListTile(
            leading: Icon(Icons.info_outline, color: theme.colorScheme.primary),
            title: Text('عن دليل', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)), 
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            onTap: () {
              
              print("Navigate to About Daleel");
            },
          ),
          ListTile(
            leading: Icon(Icons.help_outline, color: theme.colorScheme.primary),
            title: Text('الأسئلة الشائعة', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)), 
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            onTap: () {
              
              print("Navigate to FAQ");
            },
          ),
           
           ListTile(
            leading: Icon(Icons.report_problem_outlined, color: theme.colorScheme.primary),
            title: Text('الإبلاغ عن مشكلة', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)), 
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            onTap: () {
              
              print("Navigate to Report Problem");
            },
          ),
          ListTile(
            leading: Icon(Icons.support_agent_outlined, color: theme.colorScheme.primary),
            title: Text('تواصل معنا', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            onTap: () {
              print("Navigate to Contact Us");
            },
          ),
          
           ListTile(
            leading: Icon(Icons.privacy_tip_outlined, color: theme.colorScheme.primary),
            title: Text('سياسة الخصوصية', style: TextStyle(color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold)),
            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
             contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
            onTap: () {
              print("Navigate to Privacy Policy");
            },
          ),
          
          
           Padding(
            padding: const EdgeInsets.only(top: 24.0, bottom: 16.0, left: 20.0, right: 20.0), 
            child: Text(
              'صنع بإتقان من\nطلبة جامعة الملك سعود', 
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.5), 
                height: 1.5, 
              ),
            ),
          ),
          
          
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0, left: 20.0, right: 20.0), 
            child: Text(
              'إصدار التطبيق: $_appVersion', 
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6)),
            ),
          ),
        ],
      ),
    );
  }

  
  Widget _buildSectionTitle(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 16.0, bottom: 8.0), 
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          color: theme.primaryColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 