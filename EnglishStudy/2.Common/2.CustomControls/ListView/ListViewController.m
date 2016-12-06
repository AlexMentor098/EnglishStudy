
#import "ListViewController.h"
#import "AppDelegate.h"

@implementation ListViewController

+ (id)listViewWithData:(NSArray *)arrListData ofTitle:(NSString *)strTitle
{
    ListViewController *viewController = [[ListViewController alloc] initWithArrayData:arrListData fieldName:nil ofTitle:strTitle];

    return viewController;
}

+ (id)listViewWithData:(NSArray *)arrListData fieldName:(NSString *)strFieldName ofTitle:(NSString *)strTitle
{
    ListViewController *viewController = [[ListViewController alloc] initWithArrayData:arrListData fieldName:strFieldName ofTitle:strTitle];

    return viewController;
}

-(id)initWithArrayData:(NSArray *)arrListData fieldName:(NSString *)strFieldName ofTitle:(NSString*)strTitle
{
    self = [self initWithNibName:@"ListViewController" bundle:nil];
    
    _arrListData = arrListData;
    _strFieldName = strFieldName;
    _strTitle = strTitle;

    return self;
}

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = _strTitle;
    lblTitle.text = _strTitle;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (IBAction)onClickBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

// New Autorotation support.
- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if( _arrListData == nil )
        return 0;

    return [_arrListData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if( cell == nil )
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    NSString    *strCellTitle = @"";
    if( _strFieldName == nil )
    {
        strCellTitle = [_arrListData objectAtIndex:indexPath.row];
    }
    else
    {
        strCellTitle = [[_arrListData objectAtIndex:indexPath.row] objectForKey:_strFieldName];
    }

    cell.textLabel.text = strCellTitle;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0f];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 44;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self.listDelegate respondsToSelector:@selector(listViewController:didSelectRowAtIndex:)] )
    {
        [self.listDelegate listViewController:self didSelectRowAtIndex:(int)indexPath.row];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end