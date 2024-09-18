//
//  DTTBodyHTMLElement.m
//  LiveIn_Home
//
//  Created by Walg on 2024/4/11.
//

#import "DTTBodyHTMLElement.h"
#import "NSMutableAttributedString+HTML.h"

@implementation DTTBodyHTMLElement

- (NSAttributedString *)attributedString {
    
    @synchronized(self) {
        NSDictionary *attributes = [self attributesForAttributedStringRepresentation];
        // ignore text, use unicode object placeholder
        NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithString:UNICODE_ZERO_WIDTH_NO_BREAK_SPACE attributes:attributes];
        return tmpString;
    }
}

@end
