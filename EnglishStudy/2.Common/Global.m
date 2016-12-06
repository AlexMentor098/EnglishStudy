
#import "Global.h"
#import "UserManager.h"

@implementation StudySetting

@end

@implementation Global

Global* _sharedGlobal = nil;

+ (Global*)sharedGlobal
{
    if( _sharedGlobal == nil )
    {
        _sharedGlobal = [[Global alloc] init];
        [_sharedGlobal loadParams];
    }

    return _sharedGlobal;
}

- (void)initGlobal
{
    self.dbManager = [[SQLLite alloc] initWithPath:@"word_db.db"];

    [UserManager createUserTable];
}

+ (BOOL)hasFourInchDisplay
{
    //return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height == 568.0);
    return ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && [UIScreen mainScreen].bounds.size.height > 500);
}

+ (int)getCurMonth
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    
    NSString*   curDateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return [curDateString intValue];
}

+ (int)getCurDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd"];
    
    NSString    *curDateString = [dateFormatter stringFromDate:[NSDate date]];

    return [curDateString intValue];
}

+ (NSString *)getStringOfDate:(NSDate *)date ofFormat:(NSString *)strFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:strFormat];

    NSString    *strDate = [dateFormatter stringFromDate:date];

    return strDate;
}

+ (NSString *)getCurDateString
{
    return [self getStringOfDate:[NSDate date] ofFormat:@"yyyy-MM-dd"];
}

+ (NSString *)getCurDateTimeString
{
    return [self getStringOfDate:[NSDate date] ofFormat:@"yyyy-MM-dd hh:mm"];
}

+ (void)resizeView:(UIView *)view withRatioWidth:(int)nWidth andHeight:(int)nHeight
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone )
        return;

    if( [UIScreen mainScreen].bounds.size.height != 480 && [UIScreen mainScreen].bounds.size.height != 960 )
        return;
    
    if( view == nil )
        return;

    CGRect frame = view.frame;
    CGSize size = frame.size;
    
    float wRatio = size.width/nWidth;
    float hRatio = size.height/nHeight;
    
    if( wRatio > hRatio )
    {
        float fWidth = size.height*nWidth/nHeight;
        float fXMove = (fWidth - size.width)/2;
        
        frame.size.width = fWidth;
        frame.origin.x -= fXMove;
    }
    else
    {
        float fHeight = size.width*nHeight/nWidth;
        float fYMove = (fHeight - size.height)/2;

        frame.size.height = fHeight;
        frame.origin.y -= fYMove;
    }
    
    view.frame = frame;
}

+ (void)resizeViewToLeft:(UIView *)view withRatioWidth:(int)nWidth andHeight:(int)nHeight
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone )
        return;
    
    if( [UIScreen mainScreen].bounds.size.height != 480 && [UIScreen mainScreen].bounds.size.height != 960 )
        return;

    if( view == nil )
        return;
    
    CGRect frame = view.frame;
    CGSize size = frame.size;
    
    float wRatio = size.width/nWidth;
    float hRatio = size.height/nHeight;
    
    if( wRatio > hRatio )
    {
        float fWidth = size.height*nWidth/nHeight;
        frame.size.width = fWidth;
    }
    else
    {
        float fHeight = size.width*nHeight/nWidth;
        float fYMove = (fHeight - size.height)/2;
        frame.size.height = fHeight;
        frame.origin.y -= fYMove;
    }
    
    view.frame = frame;
}

+ (void)resizeViewToRight:(UIView *)view withRatioWidth:(int)nWidth andHeight:(int)nHeight
{
    if( [[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone )
        return;
    
    if( [UIScreen mainScreen].bounds.size.height != 480 && [UIScreen mainScreen].bounds.size.height != 960 )
        return;

    if( view == nil )
        return;
    
    CGRect frame = view.frame;
    CGSize size = frame.size;
    
    float wRatio = size.width/nWidth;
    float hRatio = size.height/nHeight;
    
    if( wRatio > hRatio )
    {
        float fWidth = size.height*nWidth/nHeight;
        float fXMove = (fWidth - size.width);
        
        frame.size.width = fWidth;
        frame.origin.x -= fXMove;
    }
    else
    {
        float fHeight = size.width*nHeight/nWidth;
        float fYMove = (fHeight - size.height)/2;
        
        frame.size.height = fHeight;
        frame.origin.y -= fYMove;
    }
    
    view.frame = frame;
}

+ (void)removeAllSubviewFromView:(UIView *)view
{
    for( UIView *subview in view.subviews )
    {
        [subview removeFromSuperview];
    }
}

//=====================================================================================================//

- (void)loadParams
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
	BOOL            bInstalled = [defaults boolForKey:@"Launch Application"];

	if( !bInstalled )
    {
		[defaults setBool:YES forKey:@"Launch Application"];
        [defaults setBool:NO forKey:@"LicenseAgree"];
	}
	else
    {
	}

    self.setting = [[StudySetting alloc] init];
}

- (void)saveParams
{
    
}

- (void)setLoginUser:(int)nUserID
{
    self.nUserID = nUserID;
    
    NSDictionary    *dicUser = [UserManager getUserInfo];
    
    self.setting.nRepeatStep1 = [[dicUser objectForKey:@"repeat1"] intValue];
    self.setting.nRepeatStep2 = [[dicUser objectForKey:@"repeat2"] intValue];
    self.setting.nWordColorMode = [[dicUser objectForKey:@"wordcolor"] intValue];
    self.setting.nMeanColorMode = [[dicUser objectForKey:@"meancolor"] intValue];
    self.setting.nTestTimeMode = [[dicUser objectForKey:@"testtime"] intValue];
    self.setting.nTestMethod = [[dicUser objectForKey:@"testmode"] intValue];
    self.setting.nStudySpeedMode = [[dicUser objectForKey:@"studyspeed"] intValue];
    
    self.nLevel = [[dicUser objectForKey:@"level"] intValue];
    self.nScheduleStartDate = [[dicUser objectForKey:@"startdate"] intValue];

    self.nStarRate = [[dicUser objectForKey:@"star_rate"] intValue];

    self.nDayWords = [[dicUser objectForKey:@"daywords"] intValue];
    self.nStudyWords = [[dicUser objectForKey:@"studywords"] intValue];
    
    self.strUserName = [dicUser objectForKey:@"username"];
    self.strEmail = [dicUser objectForKey:@"email"];
    self.imgUserPhoto = [UserManager getUserPhoto];
    
    if( self.nDayWords < 10 )
    {
        self.nDayWords = 20;
        [self saveUserInfo];
    }

    [UserManager createUserScheduleTable];
}

- (void)saveUserInfo
{
    NSMutableDictionary *dicUser = [NSMutableDictionary dictionaryWithCapacity:0];

    [dicUser setObject:self.strUserName forKey:@"username"];
    //[dicUser setObject:email forKey:@"email"];
    //[dicUser setObject:password forKey:@"password"];

    [dicUser setObject:[NSNumber numberWithInt:self.setting.nRepeatStep1] forKey:@"repeat1"];
    [dicUser setObject:[NSNumber numberWithInt:self.setting.nRepeatStep2] forKey:@"repeat2"];
    [dicUser setObject:[NSNumber numberWithInt:self.setting.nWordColorMode] forKey:@"wordcolor"];
    [dicUser setObject:[NSNumber numberWithInt:self.setting.nMeanColorMode] forKey:@"meancolor"];
    [dicUser setObject:[NSNumber numberWithInt:self.setting.nTestTimeMode] forKey:@"testtime"];
    [dicUser setObject:[NSNumber numberWithInt:self.setting.nTestMethod] forKey:@"testmode"];
    [dicUser setObject:[NSNumber numberWithInt:self.setting.nStudySpeedMode] forKey:@"studyspeed"];

    [dicUser setObject:[NSNumber numberWithInt:self.nLevel] forKey:@"level"];
    [dicUser setObject:[NSNumber numberWithInt:self.nScheduleStartDate] forKey:@"startdate"];

    [dicUser setObject:[NSNumber numberWithInt:self.nStarRate] forKey:@"star_rate"];
    [dicUser setObject:[NSNumber numberWithInt:self.nDayWords] forKey:@"daywords"];
    [dicUser setObject:[NSNumber numberWithInt:self.nStudyWords] forKey:@"studywords"];

    [UserManager updateUserInfo:dicUser];
}

//====================================================================================================//

- (void)loadAutoLoginUserParam
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL bAutoLogin = [defaults boolForKey:@"auto_login"];
    if( bAutoLogin == NO )
    {
        self.strSavedEmail = @"";
        self.strSavedPassword = @"";
    }
    else
    {
        self.strSavedEmail = [defaults objectForKey:@"auto_login_email"];
        self.strSavedPassword = [defaults objectForKey:@"auto_login_password"];
    }
}

- (void)saveAutoLoginUserParam
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:YES    forKey:@"auto_login"];
    [defaults setObject:self.strSavedEmail forKey:@"auto_login_email"];
    [defaults setObject:self.strSavedPassword forKey:@"auto_login_password"];

    [defaults synchronize];
}

- (void)ClearRememberUser
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO    forKey:@"Remember"];

    [defaults synchronize];
}

//=====================================================================================================//

- (BOOL)getLicenseAgree
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL bLicense = [defaults boolForKey:@"LicenseAgree"];

    return bLicense;
}

- (void)setLicenseAgree
{
    NSUserDefaults  *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"LicenseAgree"];
    [defaults synchronize];
}

//============================================================================================//

+ (void)resetFontSizeOfAnswerLabel:(UILabel *)lblAnswer
{
    float fFontSize = lblAnswer.frame.size.height;
    
    lblAnswer.font = [UIFont fontWithName:@"Gulim" size:fFontSize];

    while( YES )
    {
        CGSize size = [lblAnswer sizeThatFits:lblAnswer.bounds.size];
        if( size.width <= lblAnswer.bounds.size.width )
        {
            break;
        }
        
        fFontSize--;
        lblAnswer.font = [UIFont fontWithName:@"Gulim" size:fFontSize];
    }
}

- (void)selectStudyLevel:(int)nLevel
{
    self.nLevel = nLevel;
}

@end