//
//  DTTableHTMLElement.m
//  LiveIn_Home
//
//  Created by Walg on 2024/4/9.
//

#import "DTTableHTMLElement.h"
#import "DTTableTextAttachment.h"
#import "NSMutableAttributedString+HTML.h"
#import "DTCoreTextParagraphStyle.h"

@interface DTTableHTMLElement ()

@property (nonatomic, assign) CGSize maxDisplaySize;

@end

@implementation DTTableHTMLElement

- (id)initWithName:(NSString *)name attributes:(NSDictionary *)attributes options:(NSDictionary *)options {
    
    self = [super initWithName:name attributes:attributes];
    if (self) {
        // make appropriate attachment
        DTTextAttachment *attachment = [[DTTableTextAttachment alloc] initWithElement:self options:options];
        
        // add it to tag
        _textAttachment = attachment;
        
        // to avoid much too much space before the image
        if (nil == _paragraphStyle) {
            _paragraphStyle = [[DTCoreTextParagraphStyle alloc] init];
        }

        _paragraphStyle.lineHeightMultiple = 1;
        
        // specifying line height interferes with correct positioning
        _paragraphStyle.minimumLineHeight = 0;
        _paragraphStyle.maximumLineHeight = 0;
        
        _maxDisplaySize = CGSizeZero;
        NSValue *maxImageSizeValue =[options objectForKey:DTMaxImageSize];
        if (maxImageSizeValue) {
            _maxDisplaySize = [maxImageSizeValue CGSizeValue];
        }
    }
    
    return self;
}

- (void)applyStyleDictionary:(NSDictionary *)styles {
    
    [super applyStyleDictionary:styles];
    
    // set original size if it was previously unknown
    if (CGSizeEqualToSize(CGSizeZero, _textAttachment.originalSize))
    {
        _textAttachment.originalSize = _size;
    }
    
    NSString *widthString = [styles objectForKey:@"width"];
    NSString *heightString = [styles objectForKey:@"height"];

    if (widthString.length > 1 && [widthString hasSuffix:@"%"])
    {
        CGFloat scale = (CGFloat)([[widthString substringToIndex:widthString.length - 1] floatValue] / 100.0);
        
        _size.width = _maxDisplaySize.width * scale;
    }
    
    if (heightString.length > 1 && [heightString hasSuffix:@"%"])
    {
        CGFloat scale = (CGFloat)([[heightString substringToIndex:heightString.length - 1] floatValue] / 100.0);
        
        _size.height = _maxDisplaySize.height * scale;
    }
    // update the display size
    [_textAttachment setDisplaySize:_size withMaxDisplaySize:_maxDisplaySize];
}

- (NSAttributedString *)attributedString {
    
    @synchronized(self) {
        NSDictionary *attributes = [self attributesForAttributedStringRepresentation];
        
        // ignore text, use unicode object placeholder
        NSMutableAttributedString *tmpString = [[NSMutableAttributedString alloc] initWithString:UNICODE_ZERO_WIDTH_NO_BREAK_SPACE attributes:attributes];
       
        return tmpString;
    }
}

@end
