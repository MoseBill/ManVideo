//
//  ChooseModel.h
//  Clipyeu ++
//
//  Created by Josee on 01/04/2019.
//  Copyright © 2019 Josee. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChooseModel : NSObject

@property(nonatomic,strong)NSArray *cellModels;
@property(nonatomic,strong)NSArray *list;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *sectionTitle;
@property(nonatomic,copy)NSString *musicType;
@property(nonatomic,copy)NSString *musicUrl;
@property(nonatomic,copy)NSString *musicName;
@property(nonatomic,copy)NSString *createTime;
@property(nonatomic,copy)NSString *musicImg;
@property(nonatomic,copy)NSString *musicAuthor;
@property(nonatomic,assign)NSInteger totalPage;
@property(nonatomic,assign)NSInteger startIndex;
@property(nonatomic,assign)NSInteger pageSize;
@property(nonatomic,assign)NSInteger totalRecord;
@property(nonatomic,assign)NSInteger pageNum;
@property(nonatomic,assign)int Id;
@property(nonatomic,assign)BOOL isExpanded;

@end

@interface HYBCellModel : NSObject

@property(nonatomic,copy)NSString *title;

@end

NS_ASSUME_NONNULL_END
