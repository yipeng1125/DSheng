//
//  DSNetHeader.h
//  DSheng
//
//  Created by works_yip on 2020/3/9.
//  Copyright © 2020 works_yip. All rights reserved.
//

#ifndef DSNetHeader_h
#define DSNetHeader_h
typedef void(^reqeustSuccessBlock) (id result);
typedef void(^reqeustFailedBlock) (NSError *error);


#define DSHOST_URL @"http://www.desheng168.cn/"

#define DS_REGISTER_API_URL @"dsadmin/reg.php"
#define DS_LOGIN_API_URL @"dsadmin/login.php"
#define DS_COMMITORDER_API_URL @"dsadmin/saveselect1.php"

#define DS_MODIFY_PASSWORD_API_URL @"ios/xgmm.php"
#define DS_MODIFY_TAKEPASSWORKD_API_URL @"ios/xgtxmm.php"

#define DS_LOTTERYT_TICKET_INFO_API_URL @"dsadmin/cpinfo.php"


#define DS_GET_USERINFO_API_URL @"ios/usinfo.php"

#define DS_WINNER_INFO_API_URL @"dsadmin/kjhm.php"

#define DS_TREND_INFO_API_URL @"dsadmin/cphm.php"

#define DS_GET_ALL_WINNER_API_URL @"dsadmin/cphm1.php"

#define DS_GET_ODDS_LIST_API_URL @"ios/beilv.php"


#define DS_COMMIT_TICKETLOTTERY_API_URL @"ios/saveselect.php"

#define DS_RECHAEGE_HISTORY_API_URL @"ios/czjl.php"

#define DS_TAKE_HISTORY_API_URL @"ios/txjl.php"

#define DS_PAY_HISTORY_API_URL @"ios/tzjl.php"

#define DS_ZHONGJIA_HISTORY_API_URL @"ios/zjjl.php"


#define DS_RETURN_MONEY_INFO_API_URL @"ios/fxje.php"

#define DS_COMMIT_RETURNMONEY_API_URL @"ios/fanxian.php"

#endif /* DSNetHeader_h */
