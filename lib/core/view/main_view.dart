import 'package:cryptotrade/core/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import '../../history/view/analysis_history_view.dart';
import '../../profile/view/profile_view.dart';
import '../viewmodel/main_viewmodel.dart';
import '../../analysis/view/analysis_view.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Consumer<MainViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            body: IndexedStack(
              index: viewModel.currentIndex,
              children: const [
                AnalysisView(),
                AnalysisHistoryView(),
                ProfileView(),
              ],
            ),
            bottomNavigationBar: Theme(
              data: ThemeData(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
              ),
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 0.5,
                    ),
                  ),
                ),
                child: BottomNavigationBar(
                  currentIndex: viewModel.currentIndex,
                  onTap: (index) {
                    viewModel.setCurrentIndex(index);
                  },
                  backgroundColor: Colors.black,
                  selectedItemColor: colorss.primaryColor,
                  unselectedItemColor: Colors.grey,
                  type: BottomNavigationBarType.fixed,
                  selectedFontSize: 12,
                  unselectedFontSize: 12,
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.chartBar),
                      activeIcon: Icon(FontAwesomeIcons.chartGantt),
                      label: 'Analiz',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.history),
                      activeIcon: Icon(FontAwesomeIcons.rotate),
                      label: 'Geçmiş',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(FontAwesomeIcons.personBurst),
                      activeIcon: Icon(FontAwesomeIcons.child),
                      label: 'Profil',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
