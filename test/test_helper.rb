require 'mongoid'

yaml_file = File.expand_path('../mongoid.yml', File.dirname(__FILE__))
Mongoid.load!(yaml_file, :test)

