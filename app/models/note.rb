## MENTORIA
class Note < ApplicationRecord
  store :information, accessors:[:action, :comment]

  belongs_to :proposal, optional: true
  belongs_to :broker, optional: true
  belongs_to :unit, optional: true
  belongs_to :admin, class_name: 'Person', optional: true
end
