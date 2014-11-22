WZSnakeHUD
==========


A clean and neat HUD is available NOW.

<p>
<img src="WZSnakeHUDDemo/Gif/WZSnakeHUD.gif">
</p>

##Installation

First, drag the `WZSnakeHUD` document into your project.

Second, import `WZSnakeHUD.h` to the viewController you want to show.

Third, 
```` objc
[WZSnakeHUD showWithText:@"Loading"];
````

###Custom

BackgroundColor:

```` objc
[WZSnakeHUD showWithBackgroundColor:[UIColor purpleColor]];
````

MaskColor:

```` objc
[WZSnakeHUD showWithMaskColor:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f]];
````

LineWidth:

```` objc
[WZSnakeHUD showWithLineWidth:4.5f];
````

##TODO

 * More Customization and features
 * CocoaPods support
 * Uncoupled code

##Contribute

Pull request and contribution is welcomed.

##Contact

<wongzigii@outlook.com>

##License

MIT