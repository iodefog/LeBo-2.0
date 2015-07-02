//
//  AddSinaFriendsDTO.h
//  LeBo
//
//  Created by Li Hongli on 13-2-17.
//
//

#import "DTOBase.h"
@interface AddSinaFriendsDTO : DTOBase
{
    NSString *sinaID;
    NSString *name;
    NSString* accountID;
    NSString *screen_name;
    NSString *sinaHeaderPhotoPath;
    NSString* description;
    NSString *currentState;     // 是否为添加或者取消状态
    NSData *mImageData;         //  这个属性只为保存数据，不是来自json解析
    BOOL isFans;           // 是否为我的粉丝
    BOOL isFriends;         //是否为我关注的人
}
@property (nonatomic,copy) NSString* sinaID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy)NSString* accountID;
@property (nonatomic,copy) NSString *screen_name;
@property (nonatomic,copy)  NSString *sinaHeaderPhotoPath;
@property (nonatomic,copy)  NSString *currentState;
@property (nonatomic, copy) NSString* description;
@property (nonatomic,copy)  NSData *mImageData;
@property (nonatomic,assign)    BOOL isFans;
@property (nonatomic,assign)    BOOL isFriends ;  
@end
