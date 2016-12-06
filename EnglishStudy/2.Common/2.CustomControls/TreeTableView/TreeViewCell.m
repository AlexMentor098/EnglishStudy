
#import "Global.h"
#import "TreeViewCell.h"

@implementation TreeViewCell

@synthesize imgThumb;

+ (id)createWithTitle:(NSString*)title bigIndex:(int)nBigIndex subIndex:(int)nSubIndex
{
    NSArray         *nibs = [[NSBundle mainBundle] loadNibNamed:@"TreeViewCell" owner:self options:nil];
    TreeViewCell    *cell = (TreeViewCell *)nibs[0];

    cell = [cell initWithTitle:title bigIndex:nBigIndex subIndex:nSubIndex];

    return cell;
}

- (id)initWithTitle:(NSString*)title bigIndex:(int)nBigIndex subIndex:(int)nSubIndex
{
    _lblText.text   = title;
    
    self.nBigIndex = nBigIndex;
    self.nSubIndex = nSubIndex;

    if( self.nSubIndex != -1 )
    {
        CGRect rect = _lblText.frame;
        rect.origin.x += 20;
        _lblText.frame = rect;
        
        _btnExpand.hidden = YES;
    }
    else
    {
        // TODO : remove this code for real tree view
        _btnExpand.hidden = YES;
    }

    self.bClosed = YES;

    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if( self )
    {
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //if( _nClassIndex != -1 )
    //    return;
    //[super setSelected:selected animated:animated];
}

- (void)setClosed:(BOOL)bClosed
{
    UIImage*    image;

    if( bClosed == YES )
        image = [UIImage imageNamed:@"icon_plus.png"];
    else
        image = [UIImage imageNamed:@"icon_minus.png"];

    [_btnExpand setImage:image forState:UIControlStateNormal];
    
    _bClosed = bClosed;
}

- (void)hideExpandButton
{
    _btnExpand.hidden = YES;
}

- (IBAction)onClickBtnExpand:(id)sender
{
    [self.delegate didTreeViewCellExpanded:self];
}

@end
