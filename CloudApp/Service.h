#import <objc/runtime.h>

#import <OCFoundation/OCAService.h>

#import <QuartzCore/QuartzCore.h>
#import <Quartz/Quartz.h>
#import <CoreLocation/CoreLocation.h>

//	Populate and then add this protocol to the class' protocol list, if you want to restrict the publishing of methods to the protocol's methods.
@protocol ServicePublishing <NSObject>
@end

@interface Service : OCAService
+ (NSDictionary *)facesInImageAtURL:(NSString *)imageURLStringValue;
+ (NSString *)nameOfLocationAtLatitude:(NSNumber *)latitude
                             longitude:(NSNumber *)longitude;
+ (NSNumber *)addNumbers:(NSNumber *)first andNumber:(NSNumber *)second;
@end

@interface NSDictionary(dictionaryWithObject)
+ (NSDictionary *) dictionaryWithPropertiesOfObject:(id) obj;
@end