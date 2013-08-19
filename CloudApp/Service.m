#import "Service.h"

#import <Foundation/Foundation.h>
#import <OCFoundation/OCFoundation.h>
#import <OCFoundation/OCFJSONCoder.h>

@implementation Service

+ (NSString*)sayHello {
	return @"Hello Service!";
}

+ (NSDictionary *)facesInImageAtURL:(NSString *)imageURLStringValue
{
    NSURL *imageURL = [NSURL URLWithString:imageURLStringValue];
    CIImage *image = [CIImage imageWithContentsOfURL:imageURL];
    NSDictionary *options = @{ CIDetectorAccuracy : CIDetectorAccuracyLow };
    
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:options];
    
    NSArray *faceFeatures = [detector featuresInImage:image
                                              options:nil];
    
    NSMutableArray *detectedFaces = [NSMutableArray array];
    for(CIFeature *faceFeature in faceFeatures)
    {
        [detectedFaces addObject:[NSDictionary dictionaryWithPropertiesOfObject:faceFeature]];
    }
    
    NSMutableDictionary *response = [NSMutableDictionary dictionary];
    response[@"detectedFaces"] = detectedFaces;
    
    return response;
}

+ (NSString *)nameOfLocationAtLatitude:(NSNumber *)latitude
                             longitude:(NSNumber *)longitude
{
    CLLocationDegrees latitudeValue = [latitude doubleValue];
    CLLocationDegrees longitudeValue = [longitude doubleValue];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:latitudeValue
                                                      longitude:longitudeValue];
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    __block NSString *nameOfLocation = nil;
    __block BOOL finished = NO;
    
    [reverseGeocoder reverseGeocodeLocation:location
                          completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks lastObject];
         if(placemark)
         {
             nameOfLocation = placemark.name;
         }
         else
         {
             nameOfLocation = @"Location not found!";
         }
         finished = YES;
     }];
    
    while (!finished)
    {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0f]];
    }

    return nameOfLocation;
}

+ (NSNumber *)addNumbers:(NSNumber *)first andNumber:(NSNumber *)second
{
    return [NSNumber numberWithInteger:[first intValue] + [second intValue]];
}
@end

@implementation NSDictionary(dictionaryWithObject)
+ (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        [dict setObject:[obj valueForKey:key] forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}
@end