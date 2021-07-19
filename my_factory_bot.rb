class MyFactoryBot
  def self.define(&block)
    instance_exec(&block)
  end

  def self.factory(model_sym, &block)
    @factories ||= {}
    @factories[model_sym] = MyFactory.new(model_sym)
    @factories[model_sym].instance_exec(&block)
  end

  def self.create(model_sym)
    @factories[model_sym].record
  end
end

class MyFactory
  attr_reader :record

  def initialize(model_sym)
    @record = model_sym.to_s.classify.constantize.new
  end

  def method_missing(attr, *args, &block)
    @record.send("#{attr}=", block.call)
  end
end

MyFactoryBot.define do
  factory :user do
    first_name { "John" }
    last_name { "Smith" }
  end
end

MyFactoryBot.define do
  factory :website do
    name { "Google" }
    url { "www.google.com" }
  end
end

user = MyFactoryBot.create(:user)
puts user.class.name
puts "First name: #{user.first_name}"
puts "Last name: #{user.last_name}"

website = MyFactoryBot.create(:website)
puts website.class.name
puts "Name: #{website.name}"
puts "URL: #{website.url}"
