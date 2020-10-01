//
//  VDBaseModel.h
//  iOSMovie
//
//  Created by Josee on 08/03/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,MUAddedPropertyType){
    
    MUAddedPropertyTypeAssign = 0,
    MUAddedPropertyTypeRetain = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface VDBaseModel : NSObject

/** 请求参数返回 */
@property (nonatomic,strong) NSString *code;
@property (nonatomic,strong) NSDictionary *data;
@property (nonatomic,strong) NSString *success;
@property (nonatomic,strong) NSString *msg;
@property (nonatomic,strong) NSString *message;

- (BOOL)addProperty:(id)object propertyName:(NSString *)name type:(MUAddedPropertyType)type;
- (CGFloat)getValueFromObject:(id)object name:(NSString *)name;
- (void)setValueToObject:(id)object name:(NSString *)name value:(CGFloat)value;

- (NSObject *)getObjectFromObject:(id)object name:(NSString *)name;
- (void)setObjectToObject:(id)object name:(NSString *)name value:(NSObject *)value;

- (CGSize)getSizeFromObject:(id)object name:(NSString *)name;
- (void)setSizeToObject:(id)object name:(NSString *)name value:(CGSize)newValue;

@end

NS_ASSUME_NONNULL_END
