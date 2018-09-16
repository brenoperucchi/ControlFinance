class Notify < ApplicationRecord
  belongs_to :notiable, polymorphic:true
end
