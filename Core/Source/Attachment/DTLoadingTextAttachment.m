//
//  DTLoadingTextAttachment.m
//  LiveIn_Home
//
//  Created by Walg on 2024/5/9.
//

#import "DTLoadingTextAttachment.h"

@implementation DTLoadingTextAttachment

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
}

- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options {
    
    self = [super initWithElement:element options:options];
    if (self) {
        self.displaySize = CGSizeMake(20, 10);
    }
    return self;
}

//- (void)drawInRect:(CGRect)rect context:(CGContextRef)context {
//
////    [self.image drawInRect:rect];
//}

//- (CGFloat)ascentForLayout {
//
//    CGFloat ascent = [super ascentForLayout];
//    return 0;
//}

//- (CGFloat)descentForLayout {
//
//    CGFloat descent = [super descentForLayout];
//    return self.displaySize.height;
//}

@end
