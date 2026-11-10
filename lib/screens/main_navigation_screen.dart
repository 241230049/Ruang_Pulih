import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../services/app_state_service.dart';
import 'dashboard/dashboard_tab.dart';
import 'journal/journal_tab.dart';
import 'forum/forum_tab.dart';
import 'consultation/consultation_tab.dart';
import 'education/education_tab.dart';
import 'donation/donation_tab.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final AppStateService appState;

  const MainNavigationScreen({super.key, required this.appState});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.appState,
      builder: (context, _) {
        final tabs = [
          DashboardTab(
            appState: widget.appState,
            onNavigateToTab: _navigateToTab,
          ),
          JournalTab(appState: widget.appState),
          ForumTab(appState: widget.appState),
          ConsultationTab(appState: widget.appState),
          _CommunityHubTab(appState: widget.appState),
        ];

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          body: IndexedStack(index: _currentIndex, children: tabs),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              currentIndex: _currentIndex,
              backgroundColor: Colors.white,
              selectedItemColor: AppColors.primary,
              unselectedItemColor: const Color.fromARGB(255, 98, 63, 63),
              type: BottomNavigationBarType.fixed,
              selectedFontSize: 11,
              unselectedFontSize: 11,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w800),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Beranda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_fire_department_outlined),
                  activeIcon: Icon(Icons.local_fire_department_rounded),
                  label: 'Streak',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.forum_outlined),
                  activeIcon: Icon(Icons.forum_rounded),
                  label: 'Menfess',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.support_agent_outlined),
                  activeIcon: Icon(Icons.support_agent_rounded),
                  label: 'Konseling',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.explore_outlined),
                  activeIcon: Icon(Icons.explore_rounded),
                  label: 'Edukasi',
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: _currentIndex == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: FloatingActionButton.small(
                    heroTag: 'profile_btn',
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    tooltip: 'Profil & Privasi',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProfileScreen(appState: widget.appState),
                        ),
                      );
                    },
                    child: Text(
                      widget.appState.currentUser.avatar,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )
              : null,
        );
      },
    );
  }
}

class _CommunityHubTab extends StatelessWidget {
  final AppStateService appState;

  const _CommunityHubTab({required this.appState});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        appBar: AppBar(
          title: const Text('Edukasi & Donasi'),
          elevation: 0,
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            indicatorWeight: 3,
            labelColor: AppColors.primary,
            labelStyle: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(
                icon: Icon(Icons.menu_book_rounded, size: 20),
                text: 'Edukasi & Kalkulator',
              ),
              Tab(
                icon: Icon(Icons.volunteer_activism_rounded, size: 20),
                text: 'Bantuan Darurat',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            EducationTab(appState: appState),
            DonationTab(appState: appState),
          ],
        ),
      ),
    );
  }
}
