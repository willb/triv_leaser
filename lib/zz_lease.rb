require 'user'
require 'vm'

class Lease
  include DataMapper::Resource
  property :id,     Serial
  belongs_to :user, :key=>true
  belongs_to :vm, :key=>true
  
  def to_s
    "#{user} has #{vm}"
  end
end
