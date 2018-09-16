class Notify < ApplicationRecord
  belongs_to :notiable, polymorhic:true
end
