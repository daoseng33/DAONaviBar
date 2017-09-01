# DAONaviBar
DAONaviBar is a Facebook like navigation bar with smooth auto-scrolling animation.

1. Show title mode

![Image of navibar](https://media.giphy.com/media/3o7aCUBZMeE0SEwYX6/giphy.gif)

2. Hide title mode

![Image of navibar](https://media.giphy.com/media/aMkjGZk8fA8HC/giphy.gif)

## Requirement ##
- iOS 8.0

## Installation ##
### CocoaPods ###
```
pod 'DAONaviBar', '~> 0.4.2'
```

## Usage ##
1. Import DAONaviBar first
```objective-c
#import "DAONaviBar.h"
```

2. Just need one line in viewDidAppear
```objective-c
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[DAONaviBar sharedInstance] setupWithController:self scrollView:self.scrollViewToTrack hideTitle:NO];
}
```
