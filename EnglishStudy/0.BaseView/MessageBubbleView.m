
#import "MessageBubbleView.h"
#import "Global.h"
#import "UIImage+Utils.h"
#import "UtilImage.h"

#define RIGHT_CONTENT_INSETS    UIEdgeInsetsMake(30, 8, 8, 20)
#define LEFT_CONTENT_INSETS     UIEdgeInsetsMake(30, 20, 8, 8)

static const float kBubbleTextSize = 14.0f;

@interface UINOBorderTextView : UITextView

@end

@implementation UINOBorderTextView

@end

@interface MessageBubbleView ()

@property (nonatomic, assign) UIEdgeInsets  contentInsets;
@property (nonatomic, retain) UIImageView*  bubbleImageView;
@property (nonatomic, assign) CGSize        imageSize;
@property (nonatomic, retain) UITextView*   txtViewContent;

@property (nonatomic, retain) UIActivityIndicatorView* activityIndicator;

@end

@implementation MessageBubbleView

- (id)initWithText:(NSString *)text toRight:(BOOL)toRight
{
    if( self = [super init] )
    {
        NSString*           baseImageFile = nil;
        
        self.toRight = toRight;
        
        if( toRight == NO )
        {
            _contentInsets = LEFT_CONTENT_INSETS;
            baseImageFile = @"bg_msg_left.png";
        }
        else
        {
            _contentInsets = RIGHT_CONTENT_INSETS;
            baseImageFile = @"bg_msg_right.png";
        }
        
        UIImage *bubbleImage = [[UIImage imageNamed:baseImageFile] resizableImageWithCapInsets:_contentInsets resizingMode:UIImageResizingModeStretch];
        
        _bubbleImageView = [[UIImageView alloc] initWithImage:bubbleImage];
        _bubbleImageView.frame = self.frame;
        _bubbleImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
#if 0
        _titleLabel = [[CopyLabel alloc] init];
        _titleLabel.delegate = self;
        _titleLabel.text = text;
        _titleLabel.font = [UIFont systemFontOfSize:kBubbleTextSize];
        _titleLabel.textColor = UIColor.blackColor;
        
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.backgroundColor = [UIColor clearColor];
        
        //self.contentEdgeInsets = contentInsets;
        self.titleLabel.preferredMaxLayoutWidth = 200.0f;
#else
        self.txtViewContent = [[UITextView alloc] init];
        //self.txtViewContent.delegate = self;
        self.txtViewContent.text = text;
        self.txtViewContent.font = [UIFont systemFontOfSize:kBubbleTextSize];
        //_titleLabel.textColor = UIColor.blackColor;
        self.txtViewContent.textColor = [UIColor blackColor];

        //self.txtViewContent.numberOfLines = 0;
        //self.txtViewContent.lineBreakMode = NSLineBreakByWordWrapping;
        self.txtViewContent.backgroundColor = [UIColor clearColor];
        self.txtViewContent.editable = NO;
        //self.txtViewContent.dataDetectorTypes = UIDataDetectorTypeAll;
        self.txtViewContent.dataDetectorTypes = UIDataDetectorTypeLink;
        self.txtViewContent.scrollEnabled = NO;

        //self.contentEdgeInsets = contentInsets;
        //self.txtViewContent.preferredMaxLayoutWidth = 200.0f;
#endif
        [self addSubview:_bubbleImageView];
        //[self addSubview:self.titleLabel];
        [self addSubview:self.txtViewContent];
        
        self.backgroundColor = [UIColor clearColor];

    }
    return self;
}

#define TWO_THIRDS_OF_PORTRAIT_WIDTH (320.0f * 0.66f)

- (void)sizeToFit
{
    [super sizeToFit];
    
#if 0
    if( self.titleLabel.text )
    {
        self.frame = CGRectMake(0,0, self.textSize.width+30, self.textSize.height+20);
        self.titleLabel.frame = CGRectMake(0, 0, self.textSize.width, self.textSize.height);
    }
#else
    if( self.txtViewContent.text )
    {
        self.frame = CGRectMake(0,0, self.textSize.width+30, self.textSize.height+20);
        self.txtViewContent.frame = CGRectMake(0, 0, self.textSize.width, self.textSize.height);
    }
#endif
}

- (CGSize)sizeThatFits:(CGSize)size
{
#if 0
    if (self.titleLabel.text)
    {
        return self.textSize;
    }
    else
    {
        return self.imageSize;
    }
#else
    if (self.txtViewContent.text)
    {
        return self.textSize;
    }
    else
    {
        return self.imageSize;
    }
#endif
}

- (CGSize)textSize
{
#if 0
    return [self.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:kBubbleTextSize]
                                           constrainedToSize:CGSizeMake(TWO_THIRDS_OF_PORTRAIT_WIDTH, INT_MAX)
                                               lineBreakMode:NSLineBreakByWordWrapping];
#else
    return [self.txtViewContent.text sizeWithFont:[UIFont systemFontOfSize:kBubbleTextSize]
                            constrainedToSize:CGSizeMake(TWO_THIRDS_OF_PORTRAIT_WIDTH, INT_MAX)
                                lineBreakMode:NSLineBreakByWordWrapping];
#endif
}

- (void)layoutSubviews
{
    [super layoutSubviews];

#if 0
    if (self.titleLabel.text)
    {
        if( self.toRight == YES )
            self.titleLabel.frame = CGRectMake(10, 10, self.textSize.width, self.textSize.height);
        else
            self.titleLabel.frame = CGRectMake(18, 10, self.textSize.width, self.textSize.height);
    }
#else
    if (self.txtViewContent.text)
    {
        if( SYSTEM_VERSION_LESS_THAN(@"7.0") )
        {
            if( self.toRight == YES )
                self.txtViewContent.frame = CGRectMake(4, 0, self.textSize.width+20, self.textSize.height+18);
            else
                self.txtViewContent.frame = CGRectMake(12, 0, self.textSize.width+20, self.textSize.height+18);
        }
        else
        {
            if( self.toRight == YES )
                self.txtViewContent.frame = CGRectMake(4, 0, self.textSize.width+10, self.textSize.height+18);
            else
                self.txtViewContent.frame = CGRectMake(12, 0, self.textSize.width+10, self.textSize.height+18);
        }
    }
#endif
}

- (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage
{
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

- (id)initWithImage:(UIImage *)image toRight:(BOOL)toRight
{
    image = [image scaleAndRotateImage];
    
    CGSize  size = image.size;
    //float   maxWidth = self.frame.size.width*0.6f;
    float   maxWidth = 120;

    if( size.width > maxWidth )
    {
        size.height = size.height*maxWidth/size.width;
        size.width = maxWidth;
    }
    
    if (self = [super init])
    {
        self.imageSize = size;

        NSString*       maskImageFile = nil;
        NSString*       frameImageFile = nil;

        self.toRight = toRight;

        if( toRight == NO )
        {
            _contentInsets = LEFT_CONTENT_INSETS;
            maskImageFile = @"bg_msg_mask.png";
            frameImageFile = @"bg_msg_left_frame.png";
        }
        else
        {
            _contentInsets = RIGHT_CONTENT_INSETS;
            //maskImageFile = @"bg_msg_mask1.png";
            maskImageFile = @"bg_msg_right.png";
            frameImageFile = @"bg_msg_right_frame.png";
        }

        UIImage *resizableMaskImage = [[UIImage imageNamed:maskImageFile] resizableImageWithCapInsets:_contentInsets resizingMode:UIImageResizingModeStretch];
        
        UIImage *maskImageDrawnToSize = [resizableMaskImage renderAtSize:size];
        
        UIImage *bubbleImage = [[UIImage imageNamed:frameImageFile] resizableImageWithCapInsets:_contentInsets resizingMode:UIImageResizingModeStretch];

        UIImageView *bubbleImageView = [[UIImageView alloc] initWithImage:bubbleImage];

        // masked image
        //UIImageView *maskedImageView = [[UIImageView alloc] initWithImage:[image maskWithImage: maskImageDrawnToSize]];
        //maskedImageView.frame = CGRectMake(0, 0, size.width, size.height);

        UIButton*   maskedImageView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        [maskedImageView setBackgroundImage:[image maskWithImage: maskImageDrawnToSize] forState:UIControlStateNormal];

        bubbleImageView.frame = maskedImageView.bounds;
        [self addSubview:maskedImageView];
        [self addSubview:bubbleImageView];
        
        [maskedImageView addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (void)onDownloadCompleteURLImage:(UIImage*)image
{
    [self.activityIndicator removeFromSuperview];
    
    if( [self.delegate respondsToSelector:@selector(MessageBubbleView:didLoadURLImage:)] )
        [self.delegate MessageBubbleView:self didLoadURLImage:image];
}

- (void)downloadURLImage:(NSString*)imageURL
{
#ifdef SERVER_TEST_MODE
    NSString*   fileName = [UtilImage extractFileNameFromURL:imageURL];
    imageURL = [NSString stringWithFormat:@"%@%@", SERVER_PHOTO_UPLOAD_URL, fileName];
#endif

    UIImage*    image = [UtilImage loadImageFromClientByURL:imageURL];

    self.imgURL = imageURL;

    [self performSelectorOnMainThread:@selector(onDownloadCompleteURLImage:) withObject:image waitUntilDone:NO];
}

- (id)initWithImageURL:(NSString*)imageURL toRight:(BOOL)toRight
{
    UIImage*    image = [UIImage imageNamed:@"no_image.png"];
    
    self = [self initWithImage:image toRight:toRight];
    [self sizeToFit];

    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = self.bounds;
    [self.activityIndicator startAnimating];
    [self addSubview:self.activityIndicator];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,
                                             (unsigned long)NULL), ^(void) {
        [self downloadURLImage:imageURL];
    });

    return self;
}

- (void)onClickButton:(id)sender
{
    if( self.imgURL == nil )
        return;
    
    if( [self.delegate respondsToSelector:@selector(MessageBubbleView:didSelectWithURL:)] )
        [self.delegate MessageBubbleView:self didSelectWithURL:self.imgURL];
}

-(void) didStartSelect
{
}

-(void) didEndSelect
{

}

@end
