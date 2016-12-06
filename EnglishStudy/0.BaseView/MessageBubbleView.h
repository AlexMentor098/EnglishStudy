
@class MessageBubbleView;

@protocol MessageBubbleViewDelegate <NSObject>

@optional

- (void)MessageBubbleView:(MessageBubbleView*)bubbleView didLoadURLImage:(UIImage*)image;

- (void)MessageBubbleView:(MessageBubbleView *)bubbleView didSelectWithURL:(NSString*)imgURL;

@end

@interface MessageBubbleView : UIView

@property (nonatomic, assign) id<MessageBubbleViewDelegate> delegate;
@property (nonatomic, assign) BOOL      toRight;
@property (nonatomic, retain) NSString* imgURL;

- (id)initWithText:(NSString *)text toRight:(BOOL)toRight;

- (id)initWithImage:(UIImage *)image toRight:(BOOL)toRight;

- (id)initWithImageURL:(NSString*)imageURL toRight:(BOOL)toRight;

@end
