//
//  DTCache.m
//  LiveIn_Home
//
//  Created by Walg on 2024/6/19.
//

#import "DTCache.h"
#import <YYCache/YYCache.h>

@interface DTCache ()

@property (nonatomic, strong) YYCache *cacheManager;

@end

@implementation DTCache

//+ (NSData *)rawData:(UIImage *)image
//{
//    NSDictionary *options = @{(__bridge NSString *)kCGImageSourceShouldCache : @NO,
//                              (__bridge NSString *)kCGImageSourceShouldCacheImmediately : @NO
//                              };//目的是不期望图片有缓存和解码行为
//    NSMutableData *data = [NSMutableData data];
//    CGImageDestinationRef destRef = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data, kUTTypeJPEG, 1, (__bridge CFDictionaryRef)options);
//    CGImageDestinationAddImage(destRef, image.CGImage, (__bridge CFDictionaryRef)options);
//    CGImageDestinationFinalize(destRef);
//    CFRelease(destRef);
//    return data;
//}

+ (instancetype)sharedInstance {
    
    static DTCache *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [DTCache new];
    });
    return cache;
}

//- (instancetype)init
//{
//    self = [super init];
//    if (self) {
//        [self.cacheManager removeAllObjects];
//    }
//    return self;
//}

- (nullable id<NSCoding>)objectForKey:(NSString *)key {
    
    return [self.cacheManager objectForKey:key];
}

- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key {
    
    [self.cacheManager setObject:object forKey:key];
}

- (YYCache *)cacheManager {
    
    if (!_cacheManager) {
        _cacheManager = [YYCache cacheWithName:@"li_image_cache"];
    }
    return _cacheManager;
}

@end
