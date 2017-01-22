//
//  IUTextInputRestrict.m
//  IUTextInput
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 刘海文. All rights reserved.
//

#import "IUTextInputRestrict.h"
#import <UIKit/UIKit.h>

@interface IUTextInputRestrict ()

@property (nonatomic, assign) NSUInteger maxTextLength; // restricts text length, default is NSUIntegerMax

@end

@implementation IUTextInputRestrict

+ (instancetype)textInputRestrict {
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
        self.maxTextLength = NSUIntegerMax;
    }
    return self;
}

- (void)_textDidChange:(UITextField *)textField {
    if (textField.markedTextRange) return;
    // get text
    NSString *text = textField.text;
    
    // get cursor start index
    NSInteger index = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
    
    // handle text & index
    NSInteger indexAfter = [self restrictText:&text cursorIndex:index];
    
    // return if text not changed
    if ([text isEqualToString:textField.text] && indexAfter == index) return;

    // set text immediately if the text field is not the first responder
    if (!textField.isFirstResponder) {
        textField.text = text;
        return;
    }
    
    /* adjust undo stack */
    NSUndoManager *undoManager = textField.undoManager;
    // undo once
    if ([undoManager canUndo] && ![undoManager isUndoing] && ![undoManager isRedoing]) {
        [undoManager undo];
    }
    
    // if text is same with target text, undo once again
    if ([text isEqualToString:textField.text] && [undoManager canUndo] && ![undoManager isUndoing] && ![undoManager isRedoing]) {
        [undoManager undo];
    }
    
    // reset text, clear redo stack
    [textField replaceRange:[textField textRangeFromPosition:textField.beginningOfDocument toPosition:textField.endOfDocument] withText:text];
    
    // config cursor position
    UITextPosition *position = [textField positionFromPosition:textField.beginningOfDocument offset:indexAfter];
    textField.selectedTextRange = [textField textRangeFromPosition:position toPosition:position];
}

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    return cursorIndex;
}

- (NSInteger)restrictText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    // handle text & index
    NSInteger indexAfter = [self handleText:text cursorIndex:cursorIndex];
    
    // restrict max text length
    if ((*text).length > self.maxTextLength) *text = [*text substringToIndex:self.maxTextLength];
    
    // fix index below text length
    indexAfter = MIN(indexAfter, (*text).length);
    
    return indexAfter;
}

@end

@implementation IUTextInputRestrictNumberOnly

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    return returnIndex;
}

@end

@implementation IUTextInputRestrictNumberWithFormat

+ (instancetype)textInputRestrictWithFormat:(NSString *)format {
    IUTextInputRestrictNumberWithFormat *textInputRestrict = [self textInputRestrict];
    textInputRestrict.format = format;
    return textInputRestrict;
}

- (instancetype)init {
    if (self = [super init]) {
        self.format = @"0";
    }
    return self;
}

- (void)setFormat:(NSString *)format {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"[^0-9]"];
    if ([predicate evaluateWithObject:format]) {
        _format = [@"0" stringByAppendingString:format];
    } else {
        _format = format;
    }
}

- (NSInteger)restrictText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0, j = 0, k = 0; i < [*text length] && k < self.maxTextLength; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            NSString *f = [self.format substringWithRange:NSMakeRange(j++ % [self.format length], 1)];
            while (![predicate evaluateWithObject:f]) {
                [string appendString:f];
                f = [self.format substringWithRange:NSMakeRange(j++ % [self.format length], 1)];
                if (i < cursorIndex) {
                    returnIndex++;
                }
            }
            [string appendString:charater];
            k++;
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    
    returnIndex = MIN(returnIndex, [string length]);
    
    *text = [string copy];

    return returnIndex;
}

@end

@implementation IUTextInputRestrictPhone

+ (instancetype)textInputRestrictWithSeparator:(NSString *)separator {
    IUTextInputRestrictPhone *textInputRestrict = [self textInputRestrict];
    textInputRestrict.separator = separator;
    return textInputRestrict;
}

- (NSString *)separator {
    return _separator ?: @"";
}

- (NSUInteger)maxTextLength {
    return 11;
}

- (NSString *)format {
    return [NSString stringWithFormat:@"000%@0000%@0000", self.separator, self.separator];
}

@end

@implementation IUTextInputRestrictDecimalOnly

+ (instancetype)textInputRestrictWithDecimalDigits:(NSUInteger)decimalDigits {
    IUTextInputRestrictDecimalOnly *textInputRestrict = [self textInputRestrict];
    textInputRestrict.decimalDigits = decimalDigits;
    return textInputRestrict;
}

- (instancetype)init {
    if (self = [super init]) {
        self.decimalDigits = NSUIntegerMax;
    }
    return self;
}

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSPredicate *dotPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[.]*$"];
    NSMutableString *string = [@"" mutableCopy];
    BOOL hasDotBefore = NO;
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (!hasDotBefore && [dotPredicate evaluateWithObject:charater]) {
            hasDotBefore = YES;
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    
    NSRange dotRange = [*text rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        NSInteger digitLength = [*text length] - dotRange.location - dotRange.length;
        if (digitLength > self.decimalDigits) {
            *text = [*text substringToIndex:dotRange.location + dotRange.length + self.decimalDigits];
        }
    }
    return returnIndex;
}

@end

@implementation IUTextInputRestrictDecimalNegative

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[0-9]*$"];
    NSPredicate *dotPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[.]*$"];
    NSPredicate *minusPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[-]*$"];
    NSMutableString *string = [@"" mutableCopy];
    BOOL hasDotBefore = NO;
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ((i == 0 && [minusPredicate evaluateWithObject:charater]) ||
            [predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (!hasDotBefore && [dotPredicate evaluateWithObject:charater]) {
            hasDotBefore = YES;
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    
    NSRange dotRange = [*text rangeOfString:@"."];
    if (dotRange.location != NSNotFound) {
        NSInteger digitLength = [*text length] - dotRange.location - dotRange.length;
        if (digitLength > self.decimalDigits) {
            *text = [*text substringToIndex:dotRange.location + dotRange.length + self.decimalDigits];
        }
    }
    return returnIndex;
}

@end

@implementation IUTextInputRestrictCharaterOnly

- (NSInteger)handleText:(inout NSString **)text cursorIndex:(NSInteger)cursorIndex {
    NSInteger returnIndex = cursorIndex;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"^[^\u4e00-\u9fa5]*$"];
    NSMutableString *string = [@"" mutableCopy];
    for (int i = 0; i < [*text length]; i++) {
        NSString *charater = [*text substringWithRange:NSMakeRange(i, 1)];
        if ([predicate evaluateWithObject:charater]) {
            [string appendString:charater];
        } else if (i < cursorIndex) {
            returnIndex--;
        }
    }
    *text = [string copy];
    return returnIndex;
}

@end
