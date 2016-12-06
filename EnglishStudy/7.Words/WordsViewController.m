
#import "WordsViewController.h"
#import "Global.h"
#import "WordItemView.h"

@interface WordsViewController()
{
    NSArray     *arrDicWords;
    
    int         nPage;
    int         nPageWord;
    int         nPageCount;
}

@end

@implementation WordsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tblViewContent.layer.cornerRadius = 5;
    tblViewContent.clipsToBounds = YES;
    
    bSortBySpell = YES;

    nSelTab = 0;
    viewTabContent.backgroundColor = [UIColor clearColor];
    
    [self initTabButtons];
    [self refreshButtonStatus];
    [self refreshTabContents];
    
    [self refreshSortButtonStatus];
    
    tblViewContent.dataSource = self;
    tblViewContent.delegate = self;
    
    arrDicWords = [[Global sharedGlobal].dbManager queryArrayData:@"select * from word_dic"];
    
    nPage = 0;
    nPageWord = 3;
    nPageCount = 1;
    
    [self refreshPageLabel];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    CGRect rect = tblViewContent.frame;
    
    nPageWord = (int)rect.size.height/44;
    rect.size.height = nPageWord*44;

    tblViewContent.frame = rect;

    nPageCount = ([arrDicWords count]+nPageWord-1)/nPageWord;

    [self refreshPageLabel];
}

- (void)initTabButtons
{
    arrTabButtons = [[NSArray alloc] initWithObjects:btnTab1, btnTab2, btnTab3, btnTab4, nil];
    
    for( int i = 0; i < 4; i++ )
    {
        UIButton *button  = [arrTabButtons objectAtIndex:i];
        button.tag = i;
    }

    [self refreshButtonStatus];
}

- (void)refreshSortButtonStatus
{
    btnSortName.selected = bSortBySpell;
    btnSortRegister.selected = !bSortBySpell;
    
    btnSortName.userInteractionEnabled = !bSortBySpell;
    btnSortRegister.userInteractionEnabled = bSortBySpell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)refreshButtonStatus
{
    for( int i = 0; i < 4; i++ )
    {
        UIButton *button  = [arrTabButtons objectAtIndex:i];

        if( i == nSelTab )
        {
            button.selected = YES;
            button.userInteractionEnabled = NO;
        }
        else
        {
            button.selected = NO;
            button.userInteractionEnabled = YES;
        }
    }
}

- (void)refreshTabContents
{
}

- (IBAction)onToucnDownTabButton:(id)sender
{
}

- (IBAction)onToucnUpInsideTabButton:(id)sender
{
    UIButton *curButton = (UIButton *)sender;
    
    if( nSelTab == curButton.tag )
        return;
    
    if( curButton.tag == 3 )
    {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }

    nSelTab = (int)curButton.tag;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.15];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(onTabSelected)];
    [self refreshButtonStatus];
    [UIView commitAnimations];
}

- (void)onTabSelected
{
    if( nSelTab == 0 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 1 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 2 )
    {
        [self refreshTabContents];
    }
    else if( nSelTab == 3 )
        [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)onToucnUpOutsideTabButton:(id)sender
{
    //[self refreshButtonStatus];
}


- (IBAction)onClickSortName:(id)sender
{
    bSortBySpell = YES;
    [self refreshSortButtonStatus];
}

- (IBAction)onClickSortRegister:(id)sender
{
    bSortBySpell = NO;
    [self refreshSortButtonStatus];
}

- (IBAction)onClickFilterEng:(id)sender
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone )
        imgViewWordAll.image = [UIImage imageNamed:@"btn_word_lang_eng.png"];
    else
        imgViewWordAll.image = [UIImage imageNamed:@"ph_btn_word_lang_eng.png"];
}

- (IBAction)onClickFilterAll:(id)sender
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone )
        imgViewWordAll.image = [UIImage imageNamed:@"btn_word_lang_all.png"];
    else
        imgViewWordAll.image = [UIImage imageNamed:@"ph_btn_word_lang_all.png"];
}

- (IBAction)onClickFilterKor:(id)sender
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone )
        imgViewWordAll.image = [UIImage imageNamed:@"btn_word_lang_kr.png"];
    else
        imgViewWordAll.image = [UIImage imageNamed:@"ph_btn_word_lang_kr.png"];
}

- (void)refreshPageLabel
{
    lblPage.text = [NSString stringWithFormat:@"%d/%d", nPage+1, nPageCount];
}

- (IBAction)onClickNext:(id)sender
{
    if( nPage < nPageCount-1 )
    {
        nPage++;
        [self refreshPageLabel];
        
        [tblViewContent reloadData];
    }
}

- (IBAction)onClickPrev:(id)sender
{
    if( nPage > 0 )
    {
        nPage--;
        [self refreshPageLabel];
        
        [tblViewContent reloadData];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int nCount = [arrDicWords count];

    nCount = MAX( 0, nCount - nPage*nPageWord );

    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary    *dicWord = [arrDicWords objectAtIndex:indexPath.row+nPage*nPageWord];

    WordItemView *cell = [WordItemView wordItemWithWord:dicWord];

    return cell;
}

@end
