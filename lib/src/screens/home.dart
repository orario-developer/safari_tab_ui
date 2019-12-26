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
  double dragDeltaY = 0.0;

  List pages;
  void _initializePages() {
    if (pages != null) return;
    pages = [_buildTab(), _buildBottomSheet()];
  }

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
        Tween(begin: 0.0, end: 200.0).animate(tabListAnimationController);
    tabListOpacityAnimation =
        Tween(begin: 0.0, end: 1.0).animate(tabListAnimationController);
  }

  @override
  void dispose() {
    pageController.dispose();
    iconAnimationController.dispose();
    super.dispose();
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
              // TODO:create dynamically
              AnimatedBuilder(
                animation: tabListAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: tabListAnimation.value - 100,
                    bottom: -tabListAnimation.value - 100,
                    child: Opacity(
                        opacity: tabListOpacityAnimation.value, child: child,),
                  );
                },
                child: _buildTabContent(context),
              ),
              AnimatedBuilder(
                animation: tabListAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: tabListAnimation.value,
                    bottom: -tabListAnimation.value,
                    child: child,
                  );
                },
                child: _buildTabContent(context),
              ),
            ],
          ),
        ),
        _buildAd(),
      ],
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

  Widget _buildTabContent(context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(27.0),
          topRight: Radius.circular(27.0),
        ),
        boxShadow: _buildTabShadow(),
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onVerticalDragUpdate: (DragUpdateDetails details) {
              dragDeltaY += details.delta.dy;
              if (dragDeltaY.abs() < 10.0) return;
              dragDeltaY > 0 ? _renderTabList() : _resetTabPosition();
              dragDeltaY = 0.0;
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

  void _renderTabList() {
    tabListAnimationController.forward();
  }

  void _resetTabPosition() {
    tabListAnimationController.reverse();
  }
}
