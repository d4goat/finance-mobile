import 'package:flutter/material.dart';
import 'package:frontend/screens/account_page.dart';
import 'package:frontend/screens/copy_home.dart';
import 'package:frontend/screens/home_page.dart';
import 'package:frontend/screens/invoice_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (value) {
          setState(() {
            currentPage = value;
          });
        },
        children: const <Widget>[
          HomePage(),
          InvoicePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentPage,
        onDestinationSelected: (int index) {
          setState(() {
            currentPage = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          });
        },
        destinations: const <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: "Account",
          ),
        ],
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:frontend/screens/account_page.dart';
// import 'package:frontend/screens/home_page.dart';

// class MainLayout extends StatefulWidget {
//   const MainLayout({super.key});

//   @override
//   State<MainLayout> createState() => _MainLayoutState();
// }

// class _MainLayoutState extends State<MainLayout> {
//   int currentPage = 0;
//   final PageController _page = PageController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: PageView(
//         controller: _page,
//         onPageChanged: ((value) {
//           setState(() {
//             currentPage = value;
//           });
//         }),
//         children: const <Widget>[
//           HomePage(),
//           AccountPage(),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: currentPage,
//         backgroundColor: const Color.fromARGB(255, 255, 255, 255),
//         selectedItemColor: const Color.fromARGB(255, 0, 0, 0),
//         onTap: (page) {
//           setState(() {
//             currentPage = page;
//             _page.animateToPage(page,
//                 duration: const Duration(milliseconds: 500),
//                 curve: Curves.easeInOut);
//           });
//         },
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.home_outlined,
//                 size: 30,
//               ),
//               label: "home"),
//           BottomNavigationBarItem(
//               icon: Icon(
//                 Icons.person_4_outlined,
//                 size: 30,
//               ),
//               label: "Account"),
//         ],
//       ),
//     );
//   }
// }
