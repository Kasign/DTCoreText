//
//  DTCache.h
//  LiveIn_Home
//
//  Created by Walg on 2024/6/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DTCache : NSObject

+ (instancetype)sharedInstance;

- (nullable id<NSCoding>)objectForKey:(NSString *)key;

- (void)setObject:(nullable id<NSCoding>)object forKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
