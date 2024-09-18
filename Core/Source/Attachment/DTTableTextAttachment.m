//
//  DTTableTextAttachment.m
//  LiveIn_Home
//
//  Created by Walg on 2024/4/9.
//

#import "DTTableTextAttachment.h"
#import "DTTextHTMLElement.h"
#import "DTTableHTMLElement.h"
#import "DTTHeadHTMLElement.h"
#import "DTTBodyHTMLElement.h"
#import "DTTrHTMLElement.h"
#import "DTThHTMLElement.h"
#import "DTTdHTMLElement.h"
#import "DTCoreTextParagraphStyle.h"
#import "DTCoreTextFontDescriptor.h"

#import <LJBaseToolKit/NSString+LJSize.h>

@interface DTTableTextAttachment ()

@property (nonatomic, weak) DTHTMLElement *element;
@property (nonatomic, strong) DTTableModel *tableModel;

@end

@implementation DTTableTextAttachment

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
        _element = element;
        _tableModel = [DTTableModel new];
    }
    return self;
}

//- (void)drawInRect:(CGRect)rect context:(CGContextRef)context {
//    
////    [self.image drawInRect:rect];
//}

- (void)didFinishParserElement {
    
    DTTableHTMLElement *tableElement = self.element;
    NSArray *childArr = [tableElement childNodes];
    for (DTHTMLElement *subElement in childArr) {
        if ([subElement isKindOfClass:[DTTHeadHTMLElement class]]) {
            DTTableBaseModel *tHeadModel = [self tableModelWithClass:DTTableHeadModel.class element:subElement];
            self.tableModel.headModel = tHeadModel;
            [self loopElement:subElement parentModel:tHeadModel];
        } else if ([subElement isKindOfClass:[DTTBodyHTMLElement class]]) {
            DTTableBaseModel *tBodyModel = [self tableModelWithClass:DTTableBodyModel.class element:subElement];
            self.tableModel.bodyModel = tBodyModel;
            [self loopElement:subElement parentModel:tBodyModel];
        }
    }
    
    self.tableModel.rectModel.widthModel.value = MAX((self.tableModel.headModel.rectModel.displaySize.width), (self.tableModel.bodyModel.rectModel.displaySize.width));
    self.tableModel.rectModel.heightModel.value = self.tableModel.headModel.rectModel.displaySize.height + self.tableModel.bodyModel.rectModel.displaySize.height;
    
    // 计算尺寸
//    self.displaySize = self.tableModel.rectModel.displaySize;
    self.originalSize = self.tableModel.rectModel.displaySize;
}

- (void)loopElement:(DTHTMLElement *)element parentModel:(DTTableBaseModel *)parentModel {
    
    for (DTHTMLElement *subElement in element.childNodes) {
        if ([subElement isKindOfClass:[DTTrHTMLElement class]]) { // 添加行
            DTTableBaseModel *lineModel = [self tableModelWithClass:DTTableLineModel.class element:subElement];
            [parentModel addSubModel:lineModel];
            [self loopElement:subElement parentModel:lineModel];
            
            // 宽度取最大值，高度增加
            parentModel.rectModel.widthModel.value = MAX(parentModel.rectModel.widthModel.value, (lineModel.rectModel.displaySize.width));
            parentModel.rectModel.heightModel.value = parentModel.rectModel.heightModel.value + lineModel.rectModel.displaySize.height;
            
        } else if ([subElement isKindOfClass:[DTThHTMLElement class]]) { // 添加具体cell
            [self loopTextElement:subElement parentModel:parentModel];
        } else if ([subElement isKindOfClass:[DTTdHTMLElement class]]) { // 添加具体cell
            [self loopTextElement:subElement parentModel:parentModel];
        }
    }
}

- (void)loopTextElement:(DTHTMLElement *)element parentModel:(DTTableLineModel *)parentModel {
    
    DTTableCellModel *cellModel = [self tableModelWithClass:DTTableCellModel.class element:element];
    
    if (parentModel.cellModelArr.count == 0) {
        cellModel.rectModel.leftSpace -= 1;
    }
    
    [parentModel addSubModel:cellModel];
    
    // 处理cell 文字
    NSMutableString *text = [NSMutableString string];
    for (DTTextHTMLElement *subElement in element.childNodes) {
        if ([subElement isKindOfClass:[DTTextHTMLElement class]]) {
            [text appendString:subElement.text];
        }
    }
    cellModel.text = [text copy];
    
    
    DTTableValueModel *widthModel = nil;
    // 计算尺寸
    CGFloat maxWidth = CGFLOAT_MAX;
    // 纵列宽度统一，取第一行的值
    DTTableLineModel *headLineModel = [self.tableModel.headModel.lineModelArr firstObject];
    if (headLineModel && parentModel != headLineModel) {
        NSInteger index = [parentModel.cellModelArr count] - 1;
        DTTableLineModel *headCellModel = [headLineModel.cellModelArr objectAtIndexSafe:index];
        if (headCellModel) {
            maxWidth = headCellModel.rectModel.widthModel.value;
            widthModel = headCellModel.rectModel.widthModel;
        }
    }
    
    CGSize size = [text lj_sizeWithFont:cellModel.font constrainedToWidth:maxWidth];
    
    if (widthModel) {
        cellModel.rectModel.widthModel = widthModel;
    } else {
        cellModel.rectModel.widthModel.value = size.width;
    }
    
    __weak typeof(parentModel) weakParentModel = parentModel;
    __weak typeof(cellModel) weakCellModel = cellModel;
    cellModel.rectModel.heightModel.valueBlock = ^CGFloat{
        return weakParentModel.rectModel.heightModel.value - weakCellModel.rectModel.topSpace - weakCellModel.rectModel.bottomSpace;
    };
    
    // 总宽度增加
    parentModel.rectModel.widthModel.value = parentModel.rectModel.widthModel.value + cellModel.rectModel.displaySize.width;
    
    // 高度取整行最大值
    parentModel.rectModel.heightModel.value = MAX((parentModel.rectModel.heightModel.value), (size.height + cellModel.rectModel.topSpace + cellModel.rectModel.bottomSpace));
}

- (DTTableBaseModel *)tableModelWithClass:(Class)modelClass element:(DTHTMLElement *)element {
    
    DTTableBaseModel *model = [modelClass new];
    model.backgroundColor = element.backgroundColor;
    model.textColor = element.textColor;
    if (element.fontDescriptor) {
        model.font = [UIFont systemFontOfSize:element.fontDescriptor.pointSize];
    } else {
        model.font = [UIFont systemFontOfSize:element.currentTextSize];
    }
    if (element.paragraphStyle) {
        model.textAlignment = element.paragraphStyle.alignment;
    }
    return model;
}

#pragma mark - Over
- (void)setDisplaySize:(CGSize)displaySize withMaxDisplaySize:(CGSize)maxDisplaySize {
    
    if (_originalSize.width != 0 && _originalSize.height != 0) {
        
        // width and/or height missing
        if (displaySize.width == 0 && displaySize.height == 0) {
            displaySize = _originalSize;
        } else if (displaySize.width == 0 && displaySize.height != 0) {
            // width missing, calculate it
            CGFloat factor = _originalSize.height / displaySize.height;
            displaySize.width = round(_originalSize.width / factor);
        } else if (displaySize.width != 0 && displaySize.height == 0 ) {
            // height missing, calculate it
            CGFloat factor = _originalSize.width / displaySize.width;
            displaySize.height = round(_originalSize.height / factor);
        }
    }

    if (maxDisplaySize.width > 0 && maxDisplaySize.height > 0 ) {
        if (maxDisplaySize.width < displaySize.width) {
            displaySize.width = maxDisplaySize.width;
        }
    }
    _displaySize = displaySize;
}

//- (CGFloat)ascentForLayout {
//    
//    CGFloat ascent = [super ascentForLayout];
//    return 0;
//}
//
//- (CGFloat)descentForLayout {
//    
//    CGFloat descent = [super descentForLayout];
//    return self.displaySize.height;
//}

@end
