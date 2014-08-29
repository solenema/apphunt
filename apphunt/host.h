//
//  host.h
//  apphunt
//
//  Created by Solene Maitre on 28/08/14.
//  Copyright (c) 2014 Enquire. All rights reserved.
//

// heroku configs
#define SERVER_CONFIG_LOCAL 0
#define SERVER_CONFIG_DEVELOPMENT 1
#define SERVER_CONFIG_PRODUCTION 2

#define SERVER_CONFIG SERVER_CONFIG_DEVELOPMENT

#if SERVER_CONFIG == SERVER_CONFIG_LOCAL
#define HOSTNAME @"http://localhost:3000"
#elif SERVER_CONFIG == SERVER_CONFIG_DEVELOPMENT
#define HOSTNAME @"http://apphuntdev.herokuapp.com"
#elif SERVER_CONFIG == SERVER_CONFIG_PRODUCTION
#define HOSTNAME @"http://apphunt.herokuapp.com"
#endif