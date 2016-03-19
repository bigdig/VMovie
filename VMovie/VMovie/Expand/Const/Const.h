//
//  Const.h
//  VMovie
//
//  Created by wyz on 16/3/13.
//  Copyright © 2016年 wyz. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 切换跟控制器通知*/
extern NSString  *const SwitchRootViewControllerNotification;

typedef NS_ENUM(NSInteger,BackStageType) {
    BackStageTypeAll = 2,
    BackStageTypeStudy = 47,
    BackStageTypeLounge = 53,
    BackStageTypeShot = 4,
    BackStageTypeOverView = 26,
    BackStageTypeLaterStage = 30,
    BackStageTypeEquipment = 31
};