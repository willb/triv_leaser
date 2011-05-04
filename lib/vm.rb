class Vm
  include DataMapper::Resource

  property :id,         Serial
  property :hostname,       String
  property :leased,  Boolean, :default=>false

  validates_presence_of :hostname
end
