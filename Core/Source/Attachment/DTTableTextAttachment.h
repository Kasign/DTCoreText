//
//  DTTableTextAttachment.h
//  LiveIn_Home
//
//  Created by Walg on 2024/4/9.
//

#import "DTTextAttachment.h"
#import "DTTableModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DTTableTextAttachment : DTTextAttachment

- (void)didFinishParserElement;

- (DTTableModel *)tableModel;

@end

NS_ASSUME_NONNULL_END
