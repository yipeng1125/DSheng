//
//  DSAPIReqeust.m
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#import "DSAPIRequest.h"
#import "DSNetworkManger.h"
#import "DSNetworkManger.h"



@implementation DSAPIRequest


- (void)loginReqeust:(NSString *)account
            passWord:(NSString *)password
             success:(reqeustSuccessBlock) sblock
              failed:(reqeustFailedBlock)fblock {
    
    NSString *url = [DSHOST_URL stringByAppendingString:DS_LOGIN_API_URL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:account forKey:@"ph"];
    [parameters setObject:password forKey:@"ps"];
    [parameters setObject:@"16899528" forKey:@"code"];
    NSString *bodystr = [self makeBodyStringWithParameters:parameters];
    [[DSNetworkManger shareManager] sendPostRequesttoUrl:url body:bodystr parameter:nil success:sblock failure:fblock];

}

- (void)registerReqeust:(NSString *)account
               passWord:(NSString *)password
            serviceCode:(NSString *)scode
                takePSD:(NSString *)tpsd
                success:(reqeustSuccessBlock) sblock
                 failed:(reqeustFailedBlock)fblock {
    
    NSString *url = [DSHOST_URL stringByAppendingString:DS_REGISTER_API_URL];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:account forKey:@"ph"];
    [parameters setObject:password forKey:@"ps"];
    [parameters setObject:tpsd forKey:@"tps"];
    if (scode) {
        [parameters setObject:scode forKey:@"pph"];
    }
    [parameters setObject:@"6899528" forKey:@"code"];
    
    NSString *bodystr = [self makeBodyStringWithParameters:parameters];
    
    [[DSNetworkManger shareManager] sendPostRequesttoUrl:url body:bodystr parameter:nil success:sblock failure:fblock];
}



- (NSString *)makeBodyStringWithParameters:(NSDictionary *)parameters {
    
    NSMutableString *bodystr = [NSMutableString string];
    for (NSString *key in parameters.allKeys) {
        if (bodystr.length > 0) {
            [bodystr appendString:@"&"];
        }
        [bodystr appendFormat:@"%@=%@", key, parameters[key]];
    }
    return bodystr;
}


- (void)lotteryTicketTInfoRequest:(reqeustSuccessBlock)sblock failed:(reqeustFailedBlock)fblock {
    NSString *url = [DSHOST_URL stringByAppendingString:DS_LOTTERYT_TICKET_INFO_API_URL];
    [[DSNetworkManger shareManager] sendPostRequesttoUrl:url body:nil parameter:nil success:sblock failure:fblock];

}

/*
 http://www.desheng168.cn/dsadmin/reg.php?ph=1234567890&ps=112345&tps=1112&code=1393993
public void RegUser(String userinfo)//注册
{
    String url="http://www.desheng168.cn/dsadmin/reg.php";
    String[] sendmsg=userinfo.split(";");
    SetUserInfo(sendmsg[0]+";"+sendmsg[1]);
    new webThread(url,"ph="+sendmsg[0]+"&ps="+sendmsg[1]+"&tps="+sendmsg[2]+"&code=16899528&pph="+sendmsg[3],"POST",2).start();
}

public void Login(String userinfo)//登录
{
    String url="http://www.desheng168.cn/dsadmin/login.php";
    SetUserInfo(userinfo);
    String[] sendmsg=userinfo.split(";");
    new webThread(url,"ph="+sendmsg[0]+"&ps="+sendmsg[1]+"&code=16899528","POST",3).start();
}

public void LoginOut()//退出登录
{
    RemoveLogin();
}
@JavascriptInterface
public void SaveSelect(String msg)
{
    String url="http://www.desheng168.cn/dsadmin/saveselect1.php";//投注
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg+"&msg="+msg;
        new webThread(url,sendmsg,"POST",1).start();
    } else Msg("你还没有登录");
}

public void CheckFanXian(String svalue)//自动提现功能（未开启）
{
    String url="http://www.desheng168.cn/dsadmin/txsq.php";
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg+"&timeinfo="+svalue;
        new webThread(url,sendmsg,"POST",7).start();
    } else Msg("你还没有登录");
}

public void FanXian(String svalue)//返现
{
    String url="http://www.desheng168.cn/dsadmin/khtx.php";
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg+"&timeinfo="+svalue;
        new webThread(url,sendmsg,"POST",8).start();
    } else Msg("你还没有登录");
}

public void UpdateUP(String svalue)//修改帐号密码
{
    String url="http://www.desheng168.cn/dsadmin/xgmm.php";
    if(CheckLogin())
    {
        String msg[]=svalue.split(";");
        userInfo=msg[1];
        String sendmsg=GetUserInfo();
        String uinfo[]=sendmsg.split(";");
        if(msg[0].equals(uinfo[1]))
        {
            sendmsg="userinfo="+sendmsg+"&msg="+msg[1];
            new webThread(url,sendmsg,"POST",10).start();
        } else Msg("原密码错误");
    } else Msg("你还没有登录");
}

public void UpdateTXUP(String svalue)//修改提现密码
{
    String url="http://www.desheng168.cn/dsadmin/xgtxmm.php";
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg+"&msg="+svalue;
        new webThread(url,sendmsg,"POST",11).start();
    } else Msg("你还没有登录");
}

public void GetCphm()//获取中奖号码，显示走势
{
    String url="http://www.desheng168.cn/dsadmin/cphm.php";
    new webThread(url,"","",12).start();
}

public void GetCphm1()///获取中奖号码，显示中奖号码
{
    String url="http://www.desheng168.cn/dsadmin/cphm1.php";
    new webThread(url,"","",16).start();
}

public void GetCphm2(String cpbh)//获取开奖号码
{
    String url="http://www.desheng168.cn/dsadmin/kjhm.php";
    new webThread(url,"bh="+cpbh,"POST",17).start();
}
public void SetwebTB()
{
    if(webTB==0) webTB=1;
}

public void GetDLContent()//获取代理
{
    String url="http://www.desheng168.cn/dsadmin/dlhy.php";
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg;
        new webThread(url,sendmsg,"POST",18).start();
    } else Msg("你还没有登录");
}

public void GetXZContent()//获取
{
    String url="http://www.desheng168.cn/dsadmin/tdxz.php";
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg;
        new webThread(url,sendmsg,"POST",19).start();
    } else Msg("你还没有登录");
}

public void GetTXContent()//获取提现信息
{
    String url="http://www.desheng168.cn/dsadmin/tdtx.php";
    if(CheckLogin())
    {
        String sendmsg=GetUserInfo();
        sendmsg="userinfo="+sendmsg;
        new webThread(url,sendmsg,"POST",20).start();
    } else Msg("你还没有登录");
}

public void GetNews()    //获取最新开奖号码
{
    String url="http://www.desheng168.cn/dsadmin/msg1.php";
    new webThread(url,"","",21).start();
}
*/
@end
