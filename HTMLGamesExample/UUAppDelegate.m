#import "UUAppDelegate.h"

#import "UUDetailViewController.h"
#import "UUMasterViewController.h"

@interface UUAppDelegate ()

@property (strong, nonatomic) UISplitViewController *splitVC;

@end

@implementation UUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Setup our master / detail view controllers.
    
    self.splitVC = [UISplitViewController new];
    UUMasterViewController *masterVC = [UUMasterViewController new];
    UUDetailViewController *detailVC = [UUDetailViewController new];
    self.splitVC.delegate = detailVC;
    
    UINavigationController *masterNav = [[UINavigationController alloc] initWithRootViewController:masterVC];
    UINavigationController *detailNav = [[UINavigationController alloc] initWithRootViewController:detailVC];
    
    [self.splitVC addChildViewController:masterNav];
    [self.splitVC addChildViewController:detailNav];
    
    self.window.rootViewController = self.splitVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
