#import "UUMasterViewController.h"

#import "UUDetailViewController.h"

@interface UUMasterViewController ()

@property (strong, nonatomic) NSArray *games;

- (NSDictionary *)gameForIndexPath:(NSIndexPath *)indexPath;

@end

@implementation UUMasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];

    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);

    self.title = @"Games";
    self.detailViewController = (UUDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

#pragma mark - Properties

- (NSArray *)games {
    if (_games) return _games;
    _games = (@[
              @{@"Crossword": @"crossword"},
              @{@"Sudoku": @"sudoku"},
              @{@"Word Roundup": @"wordroundup"},
              @{@"Up and Down Words": @"upanddownwords"},
              @{@"PlayFour": @"playfour"},
              ]);
    return _games;
}

#pragma mark - Orientation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

#pragma mark - Methods

- (NSDictionary *)gameForIndexPath:(NSIndexPath *)indexPath {
    return self.games[indexPath.row];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.games.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    NSDictionary *game = [self gameForIndexPath:indexPath];
    cell.textLabel.text = [game allKeys][0];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *game = self.games[indexPath.row];
    self.detailViewController.gameName = [game allKeys][0];
    self.detailViewController.gameKey = [game allValues][0];
}

@end
