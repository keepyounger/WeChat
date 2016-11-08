//
//  NSObject+RedBag.m
//  autoGetRedEnv
//
//  Created by 李向阳 on 2016/11/6.
//
//

#import "NSObject+RedBag.h"
#import "WeixinRequiredHeaders.h"
#import <objc/runtime.h>
#import "RedManager.h"

@implementation NSObject (RedBag)
- (void)xy_AsyncOnAddMsg:(id)arg1 MsgWrap:(id)arg2
{
    [self xy_AsyncOnAddMsg:arg1 MsgWrap:arg2];
    
    CMessageWrap *wrap = arg2;
    
    switch(wrap.m_uiMessageType) {
        case 49: { // AppNode
            
            CContactMgr *contactManager = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("CContactMgr") class]];
            CContact *selfContact = [contactManager getSelfContact];
            
            BOOL isMesasgeFromMe = NO;
            if ([wrap.m_nsFromUsr isEqualToString:selfContact.m_nsUsrName]) {
                isMesasgeFromMe = YES;
            }
            
            BOOL isChatroom = NO;
            if ([wrap.m_nsFromUsr rangeOfString:@"@chatroom"].location != NSNotFound)
            {
                isChatroom = YES;
            }
            
            RedManager *manager = [RedManager sharedManager];
            if (!manager.redState.boolValue) {
                break;
            }
            
            if (isMesasgeFromMe && !manager.selfState.boolValue) {//自己发的红包
                break;
            }
            
            if (isChatroom && [wrap.m_nsContent rangeOfString:@"wxpay://"].location != NSNotFound) { // 红包
                
                NSString *nativeUrl = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl];
                nativeUrl = [nativeUrl substringFromIndex:[@"wxpay://c2cbizmessagehandler/hongbao/receivehongbao?" length]];
                Class wcbizutilClass =  objc_getClass("WCBizUtil");
                NSDictionary *nativeUrlDict = [wcbizutilClass dictionaryWithDecodedComponets:nativeUrl separator:@"&"];
                
                /** 构造参数 */
                NSMutableDictionary *params = [@{} mutableCopy];
                params[@"msgType"] = nativeUrlDict[@"msgtype"] ?: @"1";
                params[@"sendId"] = nativeUrlDict[@"sendid"] ?: @"";
                params[@"channelId"] = nativeUrlDict[@"channelid"] ?: @"1";
                params[@"nickName"] = [selfContact getContactDisplayName] ?: @"红包助手";
                params[@"headImg"] = [selfContact m_nsHeadImgUrl] ?: @"";
                params[@"nativeUrl"] = [[wrap m_oWCPayInfoItem] m_c2cNativeUrl] ?: @"";
                params[@"sessionUserName"] = wrap.m_nsFromUsr ?: @"";
                
                float time = manager.delayTime.floatValue;
                
                if (manager.delayRandomState.boolValue) {
                    time = arc4random()%50/10.0;
                }
                
                [self performSelector:@selector(xy_openRedBag:) withObject:params afterDelay:time];
                
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)xy_openRedBag:(NSMutableDictionary *)params
{
    WCRedEnvelopesLogicMgr *logicMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:[objc_getClass("WCRedEnvelopesLogicMgr") class]];
    [logicMgr OpenRedEnvelopesRequest:params];
}

- (void)xy_onRevokeMsg:(id)arg1
{
    RedManager *manager = [RedManager sharedManager];
    
    if (manager.revokeState.boolValue) {
        return;
    }
    
    [self xy_onRevokeMsg:arg1];
}

@end
