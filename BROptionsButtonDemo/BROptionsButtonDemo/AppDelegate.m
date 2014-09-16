

#import "AppDelegate.h"
#import "MainTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:@"MainTabBarController" owner:nil options:nil];
    
    self.window.backgroundColor = [UIColor blackColor];
    UITabBarController *tabBarController = [arr lastObject];
    [self.window addSubview:tabBarController.view];
    [self.window setRootViewController:tabBarController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
