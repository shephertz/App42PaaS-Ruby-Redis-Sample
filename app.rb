require 'erubis'
require 'json'
require 'redis-objects'
require 'dm-core'
require 'dm-redis-adapter'

DataMapper.setup(:default, {:adapter  => "redis"})

class App

  # call method, takes a single hash parameter and returns
  # an array containing the response status code, HTTP response
  # headers and the response body as an array of strings.
  def call env
    $params = nil
    $params = Rack::Utils.parse_nested_query(env["rack.input"].read)
    path = env['PATH_INFO']
    routes = ['index','new', 'create_user']
    action = path.split("/")
    if action.size > 0 and routes.include? action[1]
      body = User.new.send(action[1])
    elsif action.size == 0
      body = User.new.send('new')
    else
      body = 'Page not found' 
    end
    status = 200
    header = {"Content-Type" => "text/html"}

    [status, header, [body]]
  end
end

# User model that inherit ActiveRecored
class User
  include Redis::Objects
  include DataMapper::Resource

  # include ActiveModel::Validations  
  # include ActiveModel::Conversion  
  
  # # datamapper fields, just used for .create
  property :id, Serial
  property :name, String
  property :email, String
  property :des, Text

  def id
    1
  end

  def new
    render :file => 'users/new'
  end

  def index
    @users = User.all
    render :file => 'users/index'
  end

  def create_user
    User.create(:name => $params['name'], :email => $params['email'], :des => $params['des'])
    @users = User.all
    render :file => 'users/index'
  end

  def render(option)
    @body = render_erb_file('views/' + option[:file] + '.erb')
  end

  def render_erb_file(file)
    input = File.read(file)
    eruby = Erubis::Eruby.new(input)
    @body = eruby.result(binding())
  end
end

User.finalize