# DAONaviBar
DAONaviBar is a Facebook like navigation bar with smooth auto-scrolling animation.

![Image of navibar](https://media.giphy.com/media/aMkjGZk8fA8HC/giphy.gif)

## Installation ##
### CocoaPods ###
```
pod 'DAONaviBar', '~> 0.3.4'
```

## Usage ##
### 1.Import DAONaviBar first ###
```objective-c
#import "DAONaviBar.h"
```

### 2.Just need one line in viewDidAppear ###
```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[DAONaviBar sharedInstance] setupWithController:self scrollView:self.scrollViewToTrack];
}
```
