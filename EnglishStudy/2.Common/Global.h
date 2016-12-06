
#import <Foundation/Foundation.h>
#import "sqlite.h"

//#define COMPLETE_PRODUCT_PROJECT    //완성된 제품인가? 현재는 막을것(학습단어자료기지, 그림, 음성파일이 모두 준비되였을 때 열것)

//#define USE_POPOVER_CAMERA   //iPad에서 카메라나 갤러리를 popup창에서 보여주겠는가(정의된 경우), 아니면 fullscreen상태로 보여주겠는가(정의를 막은경우)

//#define TEST_PROJECT          //개발시 실험시간을 단축하기 위한것

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#define UIRGBColor(r, g, b, a)                      ([UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)/255.0f])

#define kButtonStateAll (UIControlStateSelected | UIControlStateNormal | UIControlStateHighlighted | UIControlStateDisabled | UIControlStateApplication)

#define TEST_METHOD_OPTION_STEP1            0x01
#define TEST_METHOD_OPTION_STEP2            0x02
#define TEST_METHOD_OPTION_STEP3            0x04
#define TEST_METHOD_OPTION_STEP4            0x08
#define TEST_METHOD_OPTION_STEP_CHOOSE      (TEST_METHOD_OPTION_STEP1 | TEST_METHOD_OPTION_STEP2 | TEST_METHOD_OPTION_STEP3 )
#define TEST_METHOD_OPTION_ALL              (TEST_METHOD_OPTION_STEP1 | TEST_METHOD_OPTION_STEP2 | TEST_METHOD_OPTION_STEP3 | TEST_METHOD_OPTION_STEP4)

#ifndef TEST_PROJECT
#define     STEP_TEST_WORD_COUNT    10
#else
#define     STEP_TEST_WORD_COUNT    2
#endif

@interface StudySetting : NSObject
{
}
@property (nonatomic) int     nRepeatStep1;
@property (nonatomic) int     nRepeatStep2;
    
@property (nonatomic) int     nWordColorMode;
@property (nonatomic) int     nMeanColorMode;
    
@property (nonatomic) int     nTestTimeMode;
@property (nonatomic) int     nTestMethod;

@property (nonatomic) int     nStudySpeedMode;

@end

@interface Global : NSObject
{
}

@property (nonatomic) SQLLite       *dbManager;

@property (nonatomic) NSString      *strSavedEmail;     //이메일
@property (nonatomic) NSString      *strSavedPassword;  //비밀번호

@property (nonatomic) int           nUserID;            //현재의 유저ID
@property (nonatomic) NSString      *strUserName;       //유저이름
@property (nonatomic) NSString      *strEmail;          //이메일
@property (nonatomic) UIImage       *imgUserPhoto;      //유저포토

@property (nonatomic) int           nLevel;             //학습급수
@property (nonatomic) int           nPrepareLevel;      //준비중 학습급수(급수선택시, 아직은 미확정)

@property (nonatomic) int           nScheduleStartDate; //일정시작일

@property (nonatomic) int           nStarRate;          //별
@property (nonatomic) int           nStudyWords;        //학습한 단어수

@property (nonatomic) int           nDayWords;          //하루학습할 단어수
@property (nonatomic) BOOL          bLevelTest;         //급수시험중 아니면 학습후 시험중

@property (nonatomic) int           nScheduledID;       //0이면 새로운 학습, 아니면 이미학습한 일정의 ID

@property (nonatomic) StudySetting  *setting;

+ (Global *)sharedGlobal;

+ (int)getCurMonth;
+ (int)getCurDay;

+ (NSString *)getStringOfDate:(NSDate *)date ofFormat:(NSString *)strFormat;
+ (NSString *)getCurDateString;
+ (NSString *)getCurDateTimeString;

+ (BOOL)hasFourInchDisplay;

+ (void)resizeView:(UIView *)view withRatioWidth:(int)nWidth andHeight:(int)nHeight;

+ (void)resizeViewToLeft:(UIView *)view withRatioWidth:(int)nWidth andHeight:(int)nHeight;

+ (void)resizeViewToRight:(UIView *)view withRatioWidth:(int)nWidth andHeight:(int)nHeight;

+ (void)removeAllSubviewFromView:(UIView *)view;

- (void)initGlobal;

- (void)loadParams;
- (void)saveParams;

- (void)setLoginUser:(int)nUserID;
- (void)saveUserInfo;

- (void)loadAutoLoginUserParam;
- (void)saveAutoLoginUserParam;

- (BOOL)getLicenseAgree;
- (void)setLicenseAgree;

//======================================================================================================//

+ (void)resetFontSizeOfAnswerLabel:(UILabel *)lblAnswer;

- (void)selectStudyLevel:(int)nLevel;

@end