class Store < ApplicationRecord
  attr_accessor :terms
  store :settings, accessors:[:language, :broker_config, :address, :phone, :email, :url]

  include SentientStore 

  LANGUAGE = {'pt-br': 'pt-BR', en:'en'}

  has_many :users, dependent: :destroy
  has_many :brokers, dependent: :destroy
  has_many :persons, dependent: :destroy
  has_many :builds, dependent: :destroy
  has_many :units, :through => :builds, :source => :units
  has_many :proposals, :through => :builds, :source => :proposals

  accepts_nested_attributes_for :persons, allow_destroy: true
  
  validates_acceptance_of :terms, accept: "1", if: :validate_terms

  def validate_terms
    return true if self.terms.blank?
    self.term_at = DateTime.now
  end

end