//
//  DTClickPopAttachment.m
//  LiveIn_Home
//
//  Created by Walg on 2024/8/2.
//

#import "DTClickPopAttachment.h"

@implementation DTClickPopAttachment

- (id)initWithElement:(DTHTMLElement *)element options:(NSDictionary *)options {
    
    self = [super initWithElement:element options:options];
    if (self) {
        self.displaySize = CGSizeMake(24, 22);
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    _title = title;
    CGFloat width = [title lj_sizeFromStringWithFont:PFSC_S(12) constrainedToSize:CGSizeMake(CGFLOAT_MAX, 22)].width;
    width = MAX(6, width);
    self.displaySize = CGSizeMake(width + 16, 22);
}

@end
