class Person < ApplicationRecord
  include Lib::Personhood

  has_one :user, as: :userable, dependent: :destroy
  belongs_to :store, optional: true

  accepts_nested_attributes_for :user, allow_destroy: true  

end