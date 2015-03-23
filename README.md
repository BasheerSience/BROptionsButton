BROptionsButton
===============

Amazing options button for your UITabBar, with very beautiful dynamic animation. Pimp your tabBar with beautiful button. <br>
- You saw Yelp® app and impressed by the central button animtaion ? <br>
- Now you can have even better aniamation and feel by using BROptionsButton. BROptionsButton uses the power of UIDynamics to make animation very realastic and beautiful. <br>

What's new in Version 1.3
=========================
1) iOS 8 support <br>
2) iPhone 6 and 6+ support <br>
3) Less dependency on screen sizes, so now it works with all devices <br>
4) change damping and frequency of the animation on the go  <br>
5) change the location of the button dynamically with/without animation <br>


<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/videoDemo_gif.gif" alt="left" height="330" width="200" align="center">
Specifications: 
===============
1) You can add BrOptionsButton at any index in your tabBar <br>
<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/screenShot_anyLocation/iOS%20Simulator%20Screen%20shot%20Mar%2024,%202014,%206.47.47%20PM.png" alt="left" height="330" width="200" >| 
<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/screenShot_anyLocation/iOS%20Simulator%20Screen%20shot%20Mar%2024,%202014,%205.17.42%20PM.png" alt="center" height="330" width="200">| 
<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/screenShot_anyLocation/iOS%20Simulator%20Screen%20shot%20Mar%2024,%202014,%206.48.01%20PM.png" alt="right" height="330" width="200" >
<br>
2) You can have from 1 option button up to 7 for iPhone <br>
<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/screenShot-numberOfOptions/iOS%20Simulator%20Screen%20shot%20Mar%2024,%202014,%206.49.30%20PM.png" alt="left" height="330" width="200" >| 
<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/screenShot-numberOfOptions/iOS%20Simulator%20Screen%20shot%20Mar%2024,%202014,%206.49.43%20PM.png" alt="center" height="330" width="200">| 
<img src="https://raw.githubusercontent.com/BasheerSience/BROptionsButton/master/screenShot-numberOfOptions/iOS%20Simulator%20Screen%20shot%20Mar%2024,%202014,%206.49.50%20PM.png" alt="right" height="330" width="200" >
<br>
3) Choose your own custom images and colors <br>
4) Dynamically change the number of items, background color, titles, and the location of the button

What will you need:
==================
1) iOS 7 or later  <br>
2) instance of UItabBar (of course) <br>

How to use it:
==================
- import BROptionsButton.h

```Objective-C
#import "BROptionsButton.h"
```

- Initialize new button 
```Objective-C
// the index 1 is the center for UITabBar with 3 buttons
// the delegate must be setted  
 BROptionsButton *brOption = [[BROptionsButton alloc] initForTabBar:self.tabBar forItemIndex:1 delegate:self];
```
- Customize the button. Set images for different states 

```Objective-C
[brOption setImage:[UIImage imageNamed:@"Apple"] forBROptionsButtonState:BROptionsButtonStateNormal];
[brOption setImage:[UIImage imageNamed:@"close"] forBROptionsButtonState:BROptionsButtonStateOpened];
```

- Respond to the formal protocol messages 

```Objective-C
// number of items 
- (NSInteger)brOptionsButtonNumberOfItems:(BROptionsButton *)brOptionsButton
{
    return 4;
}

// respond to selection (show viewController, animation, alert...)
- (void)brOptionsButton:(BROptionsButton *)brOptionsButton didSelectItem:(BROptionItem *)item
{
    [self setSelectedIndex:brOptionsButton.locationIndexInTabBar];
}
```

- Respond to informal protocol messages to have more customizations

```Objective-C
// custom image for this item.
// nil will make rounded button with default background color
- (UIImage*)brOptionsButton:(BROptionsButton *)brOptionsButton imageForItemAtIndex:(NSInteger)index
{
    UIImage *image = [UIImage imageNamed:@"Apple"];
    return image;
}

// do any setups before displaying the button
- (void)brOptionsButton:(BROptionsButton*)optionsButton willDisplayButtonItem:(BROptionItem*)button {
    button.backgroundColor = [UIColor blackColor];
}


- (NSString*)brOptionsButton:(BROptionsButton*)brOptionsButton titleForItemAtIndex:(NSInteger)index {
   return @"buttonTitle";
}
```

Next:
=====
Stay tuned, more cool stuff and updates comming soon, click Watch to get the latest updates for this library

Lincense:
==========
Copyright (c) 2013 Basheer Malaa

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
documentation files (the "Software"), to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
