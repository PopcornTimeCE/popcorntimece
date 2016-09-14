#import "substrate.h"
#import <UIKit/UIKit.h>

@interface UIScrollsToTopInitiatorView : UIView
@end

@interface UIStatusBar : UIScrollsToTopInitiatorView
@property (assign,nonatomic) UIStatusBarWindow * statusBarWindow;
@end

@class SBLIClass;
static SBLIClass *pwner;


@interface SBLIClass : NSObject {
	UIView *lockView;
}
@property (nonatomic, assign) BOOL enabled;

-(void) pwnStatusBar;
-(void) unPwnStatusBar;
@end

@implementation SBLIClass
-(void) pwnStatusBar {
	if (self.enabled) [self performSelector:@selector(_pwnStatusBar) withObject:nil afterDelay:0];
}

-(void) unPwnStatusBar {
	[self performSelector:@selector(_unPwnStatusBar) withObject:nil afterDelay:0];
}

-(void) _pwnStatusBar {
	UIStatusBar *bar = MSHookIvar<UIStatusBar *>([UIApplication sharedApplication], "_statusBar");
	if (!bar) return;
	//UIStatusBarWindow *window = [bar statusBarWindow];

	if (!lockView) {
		lockView = [[UIImageView alloc] initWithImage:[self _lockImage]];
		lockView.frame = CGRectMake(([[UIScreen mainScreen] bounds].size.width-20)/2, 0, 20, 20);
		[lockView setAlpha:0.9f];
	}
	[bar addSubview:lockView];
	//[window addSubview:lockView];
}

-(void) _unPwnStatusBar {
	if (lockView) [lockView removeFromSuperview];
}

-(UIImage *) _lockImage {
	//Init the Context and stuff
	UIGraphicsBeginImageContextWithOptions(CGSizeMake(20.f, 20.f), NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //Draw the ring of the lock
    CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(ctx, 1.5);

    CGMutablePathRef path = CGPathCreateMutable();

	CGPathAddArc(path, NULL, 10, 7, 3, 3.14159, 6.28318, NO);

	CGContextAddPath(ctx, path);
	CGContextStrokePath(ctx);

	CGPathRelease(path);

	//Draw the straight parts of the ring
	CGMutablePathRef path2 = CGPathCreateMutable();

	CGPathMoveToPoint(path2, NULL, 10-3, 7);
	CGPathAddLineToPoint(path2, NULL, 10-3, 7+4);
	CGPathMoveToPoint(path2, NULL, 10+3, 7);
	CGPathAddLineToPoint(path2, NULL, 10+3, 7+4);

	CGContextAddPath(ctx, path2);
	CGContextStrokePath(ctx);

	CGPathRelease(path2);

	//Draw the body of the lock
	CGContextSetFillColorWithColor(ctx, [UIColor whiteColor].CGColor);
	CGMutablePathRef path3 = CGPathCreateMutable();

	CGPathAddRoundedRect(path3, NULL, CGRectMake(10-5, 8+2, 10, 7), 1, 1);

	CGContextAddPath(ctx, path3);
	CGContextDrawPath(ctx, kCGPathEOFill);

	CGPathRelease(path3);

    //Draw stuff back to a UIImage
    UIImage *nImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return nImage;
}
@end


%hook SBStatusBarDataManager
-(void)_updateQuietModeItem {
	%orig;

	if (!pwner) pwner = [[SBLIClass alloc] init];
	char *items = &MSHookIvar<char>(self , "_itemIsEnabled");
	if (items[1] == YES) {
		pwner.enabled = NO;
	} else {
		pwner.enabled = YES;
	}
}
-(void)enableTime:(char)arg1 crossfade:(char)arg2 crossfadeDuration:(double)arg3 {
	if (!pwner) pwner = [[SBLIClass alloc] init];
	if (arg1 == YES) {
		[pwner unPwnStatusBar];
	} else {
		[pwner pwnStatusBar];
	}
	%orig;
}
%end


%ctor {
	pwner = [[SBLIClass alloc] init];
	[pwner pwnStatusBar];
}