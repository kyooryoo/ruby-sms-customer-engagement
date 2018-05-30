require 'sinatra'
require 'dotenv'
require 'nexmo'

Dotenv.load

set :erb, 
layout: :layout

get '/' do
  erb :index
end

post '/' do  
  $nexmo = Nexmo::Client.new(
    key: params['api_key'], #ENV['NEXMO_API_KEY'],
    secret: params['api_secret'] #ENV['NEXMO_API_SECRET']
  )
  erb :send
end

get '/send' do
  erb :send
end

post '/send' do
  @numbers = params['number']
  @number_list = @numbers.split("\r\n")

  for @number in @number_list
    @number = params['prefix'] + @number
    $nexmo.sms.send(
      from: 'NEXMO',
      to: @number,
      text: params['message']
    )
    sleep 0.03
  end
  erb :send
end