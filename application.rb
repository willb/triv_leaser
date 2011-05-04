require 'rubygems'
require 'bundler/setup'
require 'sinatra'
require File.join(File.dirname(__FILE__), 'environment')

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  Kernel.puts e.backtrace.join("\n")
  'Application error'
end

helpers do
  # add your helpers here
end

# root page
get '/' do
  haml :root
end

get '/vm' do
  @vms = Vm.all
  puts @vms
  haml :vms
end

get '/vm/:node' do |node|
  
end

post '/vm' do 
  raw = params[:data][:tempfile].read
  
  raw.split.each do |vm|
    Vm.first_or_create(:hostname=>vm)
  end
  
  redirect '/vm'
end

get '/lease/:user' do |user|
  u = User.first_or_create(:email=>user)
  @leases = Lease.all(:user=>u)
  
  Lease.transaction do
    if @leases.size != 0
      vms = Vm.all(:leased=>false)
      next_two = vms.slice(2)
      
      next_two.each do |nt|
        Lease.create(:user=>u, :vm=>nt)
        nt.leased = true
        nt.save
      end
    end
  end
  
  @leases = Lease.all(:user=>u)
  
  haml :leases
end
