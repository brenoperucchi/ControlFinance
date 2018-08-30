## MENTORIA
class Note < ApplicationRecord
  store :information, accessors:[:action, :comment]

  belongs_to :proposal, optional: true
  belongs_to :broker,   optional: true
  belongs_to :unit,     optional: true
  belongs_to :admin,    class_name: 'Person', optional: true
  has_many   :mailers,  class_name: 'Mailer', as: :mailable, dependent: :destroy
  
  after_save :mailer_notes

  def mailer_notes
    mailer = self.mailers.new(store: unit.builder.store, userable: self.broker, type: "Mailer::NoteCreated")
    mailer.prepare
    mailer.delivery
    
  end
end
