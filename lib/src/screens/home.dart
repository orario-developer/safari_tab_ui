import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  final double adHeight = 60.0;
  PageController pageController = PageController();
  Animation<double> iconAnimation;
  AnimationController iconAnimationController;
  Animation<double> tabListAnimation;
  Animation<double> tabListOpacityAnimation;
  AnimationController tabListAnimationController;

  double tabYPosition = 0.0;
  int currentIndex = 0;
  double tabDistance = 60.0;

  // DEBUG:
  List<Color> colors = [Colors.white, Colors.white70, Colors.white30];

  List pages;

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    iconAnimationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    iconAnimation =
        Tween(begin: 0.0, end: 1.0).animate(iconAnimationController);
    tabListAnimationController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
    tabListAnimation =
        Tween(begin: 0.0, end: tabDistance).animate(tabListAnimationController);
    tabListOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(tabListAnimationController);
  }

  @override
  void dispose() {
    pageController.dispose();
    iconAnimationController.dispose();
    tabListAnimationController.dispose();
    super.dispose();
  }

  void _initializePages() {
    if (pages != null) {
      pages[0] = _buildTab();
      return;
    }
    pages = [_buildTab(), _buildBottomSheet()];
  }

  @override
  Widget build(BuildContext context) {
    _initializePages();

    return Scaffold(
      appBar: AppBar(
        title: Text('Hello!'),
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            var nextPage = pageController.page == 0.0 ? 1 : 0;
            nextPage == 0
                ? iconAnimationController.reverse()
                : iconAnimationController.forward();
            pageController.animateToPage(
              nextPage,
              curve: Curves.easeIn,
              duration: Duration(
                milliseconds: 800,
              ),
            );
          },
          child: AnimatedIcon(
            progress: iconAnimation,
            icon: AnimatedIcons.menu_close,
            size: 30,
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: PageView.builder(
        onPageChanged: (int page) {
          page == 0
              ? iconAnimationController.reverse()
              : iconAnimationController.forward();
        },
        controller: pageController,
        itemBuilder: (context, position) => pages[position],
        itemCount: pages.length,
        scrollDirection: Axis.vertical,
      ),
    );
  }

  Widget _buildTab() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Stack(
            overflow: Overflow.visible,
            children: [
              _buildPositioned(
                  _buildTabContent(context, 0), tabYPosition, -tabYPosition, 1)
            ],
          ),
        ),
        _buildAd(),
      ],
    );
  }

  Widget _buildPositioned(
      Widget child, double top, double bottom, double opacity) {
    return Positioned(
      top: top,
      bottom: bottom,
      child: Opacity(
        opacity: opacity,
        child: child,
      ),
    );
  }

  Widget _buildTabContent(BuildContext context, int index) {
    return Container(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(0.01 * min(tabYPosition, 90)),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: colors[index], // DEBUG: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27.0),
          topRight: Radius.circular(27.0),
        ),
        boxShadow: _buildTabShadow(),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              currentIndex = index;
              tabYPosition = 0.0;
            },
            onVerticalDragUpdate: (DragUpdateDetails details) {
              currentIndex = -1;
              var newY = tabYPosition + details.delta.dy;
              if (0 < newY && newY < tabDistance * 4) {
                setState(() {
                  tabYPosition = newY;
                });
              }
            },
            child: Container(
              height: 60,
              child: Text('Drag Area'),
              color: Colors.grey,
            ),
          ),
          Text('Hi!'),
          Text('Hi!'),
          Text('Hi!'),
        ],
      ),
    );
  }

  Widget _buildAd() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: adHeight,
      decoration: BoxDecoration(
        color: Colors.green,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('Ad!'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSheet() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.error,
      ),
      child: Center(
        child: Column(
          children: <Widget>[
            Text('bottom'),
            Text('bottom'),
            Text('bottom'),
            Text('bottom'),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          title: Text('Calendar'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          title: Text('Caht'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('Settings'),
        ),
      ],
    );
  }

  List<BoxShadow> _buildTabShadow() {
    return <BoxShadow>[
      BoxShadow(
        color: Colors.grey[600],
        blurRadius: 1.5, // soften the shadow
        spreadRadius: 1.0, //extend the shadow
        offset: Offset(
          0, // Move to right horizontally
          0, // Move to bottom Vertically
        ),
      ),
    ];
  }
}
