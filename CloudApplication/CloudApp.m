#import "CloudApp.h"

@implementation CloudApp

+ (NSString *)sayHelloCloudApp {
    return @"Hello Cloud App";
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
        [detectedFaces addObject:[faceFeature dictionaryRepresentation_obc]];
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
    dispatch_semaphore_t holdOn = dispatch_semaphore_create(0);
    
    [reverseGeocoder reverseGeocodeLocation:location
                          completionHandler:^(NSArray *placemarks, NSError *error)
     {
         CLPlacemark *placemark = [placemarks lastObject];
         if(placemark)
         {
             nameOfLocation = placemark.name;
         }
         dispatch_semaphore_signal(holdOn);
     }];
    
    dispatch_semaphore_wait(holdOn, DISPATCH_TIME_FOREVER);
    
    return nameOfLocation;
}
@end
