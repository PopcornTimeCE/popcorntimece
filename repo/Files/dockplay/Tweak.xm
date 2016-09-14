#import <UIKit/UIKit.h>
#import "substrate.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface SBAwayViewPluginController : NSObject
@end

@interface NowPlayingArtPluginController : SBAwayViewPluginController
@end

@interface VolumeControl : NSObject
+(id)sharedVolumeControl;
-(void)setMediaVolume:(float)arg1 ;
-(float)volume;
@end

@interface DPRecognizerClass : NSObject <UIScrollViewDelegate> {
}
@end


DPRecognizerClass *recognizerClass;
CGFloat yOffsetLastUpdate;
int count = 0;


%hook SBAwayViewPluginController
-(id)view {
	UIView *view = %orig;

	if ([[self class] isEqual:[%c(NowPlayingArtPluginController) class]] && ![objc_getAssociatedObject(view, "alreadyModdedGestures") isEqual:@YES]) {
		if (!recognizerClass) recognizerClass = [[DPRecognizerClass alloc] init];

		UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0, view.bounds.size.width, view.bounds.size.height)];

		scrollView.decelerationRate = 0;
		scrollView.scrollsToTop = NO;
		scrollView.directionalLockEnabled = YES;
		scrollView.alwaysBounceVertical = NO;
		scrollView.alwaysBounceHorizontal = YES;
		scrollView.showsHorizontalScrollIndicator = NO;
		scrollView.showsVerticalScrollIndicator = NO;
		scrollView.contentSize = CGSizeMake(scrollView.bounds.size.width, scrollView.bounds.size.height*2);
		scrollView.delegate = recognizerClass;
		scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

		[view addSubview:scrollView];

		objc_setAssociatedObject(view, "alreadyModdedGestures", @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}


	return view;
}
%end

/*%hook SBAwayController
-(void)disableLockScreenBundleWithName:(NSString *)arg1 deactivationContext:(id)arg2 {
	if ([arg1 isEqualToString:@"NowPlayingArtLockScreen"]) return;
	%orig;
}
-(void)disableLockScreenBundleWithName:(id)arg1 {
	if ([arg1 isEqualToString:@"NowPlayingArtLockScreen"]) return;
	%orig;
}
%end*/


@implementation DPRecognizerClass
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if ([scrollView contentOffset].x <= -50) [[MPMusicPlayerController iPodMusicPlayer] skipToPreviousItem];
	if ([scrollView contentOffset].x >= +50) [[MPMusicPlayerController iPodMusicPlayer] skipToNextItem];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	count++;
	if (count >= 7 && fabs(yOffsetLastUpdate - scrollView.contentOffset.y) >= 7) {
		CGFloat volume = ([scrollView contentOffset].y*2) / [scrollView contentSize].height;
		if (volume <= 0) volume = 0;
		if (volume >= 1) volume = 1;

		[[%c(VolumeControl) sharedVolumeControl] setMediaVolume:volume];

		yOffsetLastUpdate = scrollView.contentOffset.y;

		count = 0;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	CGFloat volume = [[%c(VolumeControl) sharedVolumeControl] volume];

	scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, [scrollView contentSize].height * volume * 0.5);
}
@end
