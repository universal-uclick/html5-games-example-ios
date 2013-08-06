#import "UUDetailViewController.h"

@interface UUDetailViewController () <UIWebViewDelegate>

@property (strong, nonatomic) UIPopoverController *masterPopoverController;

@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;

@property (strong, nonatomic) NSString *clientID;
@property (strong, nonatomic) NSString *authorizationKey;

- (NSString *)gameHtmlForKey:(NSString *)gameKey;
- (void)refreshButtonItemTapped:(UIBarButtonItem *)sender;

@end

@implementation UUDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *secretsFilePath = [[NSBundle mainBundle] pathForResource:@"Secrets" ofType:@"plist"];
    NSDictionary *secrets = [NSDictionary dictionaryWithContentsOfFile:secretsFilePath];

    self.clientID = secrets[@"UUClientCode"];
    self.authorizationKey = secrets[@"UUAuthorizationKey"];

    [self.view addSubview:self.webView];
    self.navigationItem.rightBarButtonItem = self.refreshButton;
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"Choose a game.";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Properties

- (UIWebView *)webView {
    if (_webView) return _webView;
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    _webView.backgroundColor = [UIColor lightGrayColor];
    _webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    return _webView;
}

- (UIBarButtonItem *)refreshButton {
    if (_refreshButton) return _refreshButton;
    _refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                   target:self
                                                                   action:@selector(refreshButtonItemTapped:)];
    _refreshButton.enabled = NO;
    return _refreshButton;
}

- (void)setGameKey:(NSString *)gameKey {
    _gameKey = gameKey;
    [self.webView loadHTMLString:[self gameHtmlForKey:self.gameKey] baseURL:nil];
    [self.masterPopoverController dismissPopoverAnimated:YES];
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Methods

- (NSString *)gameHtmlForKey:(NSString *)gameKey {
    NSString *gameTemplate = @"<section class='game-wrapper' style='text-align: center;'> \
            <script> \
                var tag = document.createElement('script'); \
                tag.src = 'https://embed.universaluclick.com/s.js'; \
                var aScriptTag = document.getElementsByTagName('script')[0]; \
                aScriptTag.parentNode.insertBefore(tag, aScriptTag); \
                var apicontainer; \
                function onUUAPIReady() { \
                    apicontainer = new UU.Player('uu_hld', { \
                        l: '%@', \
                        height: '668', \
                        width: '768', \
                        customerId: '%@', \
                        key: '%@', \
                        gameId: '%@' \
                    }); \
                } \
            </script> \
            <div id='uu_hld'></div> \
        </section>";
    return [NSString stringWithFormat:gameTemplate,
            [[NSBundle mainBundle] bundleIdentifier], self.clientID, self.authorizationKey, gameKey];
}

- (void)refreshButtonItemTapped:(UIBarButtonItem *)sender {
    [self.webView loadHTMLString:[self gameHtmlForKey:self.gameKey] baseURL:nil];
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation {
    return YES;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willHideViewController:(UIViewController *)viewController
          withBarButtonItem:(UIBarButtonItem *)barButtonItem
       forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.title = @"Games";
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController
     willShowViewController:(UIViewController *)viewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.refreshButton.enabled = NO;
    self.title = @"Loading...";
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    self.refreshButton.enabled = YES;
    self.title = self.gameName;
}

@end
