#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>

FOUNDATION_EXTERN void AudioServicesPlaySystemSoundWithVibration(unsigned long, objc_object*, NSDictionary*);



@interface UITouch ()
@property (assign,nonatomic) char isTap;

-(void)setTapCount:(unsigned)arg1;
-(void)setPhase:(int)arg1;
-(float)_pathMajorRadius;
-(void)_setPathMajorRadius:(float)arg1;
@end




static NSMutableDictionary* pulsePatternsDict;

%hook UITouch
-(id) init {
	id ret = %orig;
	objc_setAssociatedObject(ret, "alreadyVibed", @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	return ret;
}

-(void)_setPathMajorRadius:(float)arg1 {
	%orig;

	if (arg1 > 6.5f && ([objc_getAssociatedObject(self, "alreadyVibed") isEqual:@NO] || objc_getAssociatedObject(self, "alreadyVibed") == nil)) {
		objc_setAssociatedObject(self, "alreadyVibed", @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		AudioServicesPlaySystemSoundWithVibration(kSystemSoundID_Vibrate, nil, pulsePatternsDict);
	}
}
%end

%ctor {
	pulsePatternsDict = [@{} mutableCopy];
	NSMutableArray* pulsePatternsArray = [@[] mutableCopy];
		
	[pulsePatternsArray addObject:@(YES)];
	[pulsePatternsArray addObject:@(1)];
			
	[pulsePatternsArray addObject:@(NO)];
	[pulsePatternsArray addObject:@(100)];
	        
	[pulsePatternsDict setObject:pulsePatternsArray forKey:@"VibePattern"];
	[pulsePatternsDict setObject:[NSNumber numberWithFloat:0.001] forKey:@"Intensity"];
}