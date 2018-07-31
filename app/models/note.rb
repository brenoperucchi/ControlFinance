## MENTORIA
class Note < ApplicationRecord
  store :information, accessors:[:message, :action, :comment]

  belongs_to :proposal
  belongs_to :broker, optional: true
  belongs_to :unit, optional: true
  belongs_to :admin, class_name: 'Person', optional: true
end
