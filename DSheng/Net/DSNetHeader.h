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

#define DS_MODIFY_PASSWORD_API_URL @"dsadmin/xgmm.php"
#define DS_MODIFY_TAKEPASSWORKD_API_URL @"dsadmin/xgtxmm.php"

#define DS_LOTTERYT_TICKET_INFO_API_URL @"dsadmin/cpinfo.php"

#endif /* DSNetHeader_h */
