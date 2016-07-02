# http://qiita.com/k-ta-yamada/items/72956c13049d583150e9

require 'mongoid'

class Blog
  include Mongoid::Document
  field :name, type: String
  field :user_id, type: Integer
end

