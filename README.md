App42PaaS-Ruby-Redis-Sample
===========================

Sample Ruby App with Redis for App42 PaaS Platform

## Getting Start with App42

1. Setup infrastructure for required environment
2. Create service
3. Deploy a Ruby application

### Setup infrastructure for required environment

    $ app42 setupInfra   
    
### Create service

    $ app42 createService
    
DB Configure for Production environment (application_root_dir/config/redis.rb) 

    Redis.current = Redis.new(:host => '<VM IP>', :port => <VM PORT>, :password => '<PASSWORD>')
    
### Deploy a Ruby application

    $ app42 deploy

#### Get application details:

    $ app42 appInfo --app AppName    
    
Visit your application:


