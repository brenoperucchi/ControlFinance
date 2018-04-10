class Store < ApplicationRecord
  attr_accessor :terms

  include SentientStore 

  LANGUAGE = {'pt-br': 'pt-BR', en:'en'}


  store :settings, accessors:[:language, :broker_config]
  has_many :users, dependent: :destroy
  has_many :brokers, dependent: :destroy
  has_many :persons, dependent: :destroy
  has_many :builds, dependent: :destroy

  accepts_nested_attributes_for :persons, allow_destroy: true
  
  validates_acceptance_of :terms, accept: "1", if: :validate_terms

  def validate_terms
    return true if self.terms.blank?
    self.term_at = DateTime.now
  end

end