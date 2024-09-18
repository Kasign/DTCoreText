//
//  DTSpanElement.m
//  LiveIn_Home
//
//  Created by Walg on 2024/9/6.
//

#import "DTSpanElement.h"
#import "DTClickPopAttachment.h"
#import "DTCoreTextParagraphStyle.h"

#import "DTCoreTextFontDescriptor.h"
#import "UIFont+DTCoreText.h"
#import "NSCharacterSet+HTML.h"
#import "NSString+HTML.h"
#import "NSMutableAttributedString+HTML.h"

@interface DTSpanElement ()

@property (nonatomic, strong) DTClickPopAttachment *popAttachment;

@end

@implementation DTSpanElement

- (id)initWithName:(NSString *)name attributes:(NSDictionary *)attributes options:(NSDictionary *)options {
    
    self = [super initWithName:name attributes:attributes];
    if (self) {
        
        NSString *styleStr = [attributes objectForKey:@"style"];
        if (styleStr && ([styleStr containsString:@" pop:"] || [styleStr hasPrefix:@"pop:"])) {
            self.popAttachment = [[DTClickPopAttachment alloc] initWithElement:self options:options];
            _textAttachment = self.popAttachment;
       
            // to avoid much too much space before the image
            if (nil == _paragraphStyle) {
                _paragraphStyle = [[DTCoreTextParagraphStyle alloc] init];
            }
            
            _paragraphStyle.lineHeightMultiple = 1;
            
            // specifying line height interferes with correct positioning
            _paragraphStyle.minimumLineHeight = 0;
            _paragraphStyle.maximumLineHeight = 0;
            
            self.popAttachment.schema = [attributes objectForKey:@"schema"];
        }
    }
    return self;
}

- (void)applyStyleDictionary:(NSDictionary *)styles {
    
    [super applyStyleDictionary:styles];
    
    if (self.popAttachment) {
        self.popAttachment.popStr = [styles objectForKey:@"pop"];
    }
}

- (NSDictionary *)attributesForAttributedStringRepresentation {
    
    NSDictionary *tmpDict = [super attributesForAttributedStringRepresentation];
    if (self.popAttachment) {
        self.popAttachment.verticalAlignment = DTTextAttachmentVerticalAlignmentCenter;
    }
    return tmpDict;
}

- (NSAttributedString *)attributedString
{
    // super returns a mutable attributed string
    NSAttributedString *mutableAttributedString = [super attributedString];
    
    if (self.popAttachment) {
        
        NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] init];
        
        DTHTMLElement *previousChild = nil;
        
        for (DTHTMLElement *oneChild in self.childNodes)
        {
            if (oneChild.displayStyle == DTHTMLElementDisplayStyleNone)
            {
                continue;
            }
            
            // if previous node was inline and this child is block then we need a newline
            if (previousChild && previousChild.displayStyle == DTHTMLElementDisplayStyleInline)
            {
                if (oneChild.displayStyle == DTHTMLElementDisplayStyleBlock)
                {
                    // trim off whitespace suffix
                    while ([[tmpString string] hasSuffixCharacterFromSet:[NSCharacterSet ignorableWhitespaceCharacterSet]])
                    {
                        [tmpString deleteCharactersInRange:NSMakeRange([tmpString length]-1, 1)];
                    }
                    
                    // paragraph break
                    [tmpString appendString:@"\n"];
                }
            }
            
            NSAttributedString *nodeString = [oneChild attributedString];
            
            if (nodeString)
            {
                if (!oneChild.containsAppleConvertedSpace)
                {
                    // we already have a white space in the string so far
                    if ([[tmpString string] hasSuffixCharacterFromSet:[NSCharacterSet ignorableWhitespaceCharacterSet]])
                    {
                        // following e.g. a BR we don't want a space or NL
                        NSCharacterSet *charactersToIgnore = [NSCharacterSet characterSetWithCharactersInString:@" \n\t"];
                        
                        while ([[nodeString string] hasPrefixCharacterFromSet:charactersToIgnore])
                        {
                            NSString *field = [nodeString attribute:DTFieldAttribute atIndex:0 effectiveRange:NULL];
                            
                            // do not trim off field
                            if ([field isEqualToString:DTListPrefixField])
                            {
                                break;
                            }
                            
                            // do not trim off HR character
                            BOOL isHR = [[nodeString attribute:DTHorizontalRuleStyleAttribute atIndex:0 effectiveRange:NULL] boolValue];
                            
                            if (isHR)
                            {
                                break;
                            }
                            
                            nodeString = [nodeString attributedSubstringFromRange:NSMakeRange(1, [nodeString length]-1)];
                        }
                    }
                }
                
                [tmpString appendAttributedString:nodeString];
            }
            
            previousChild = oneChild;
        }
        self.popAttachment.title = [tmpString string];
    }
    return mutableAttributedString;
}

@end
