class Activity < ApplicationRecord
  belongs_to :recipentable, polymorphic: true
  belongs_to :trackable, polymorphic: true
  belongs_to :ownerable, polymorphic: true
end