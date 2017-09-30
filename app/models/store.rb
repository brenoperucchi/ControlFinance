class Store < ApplicationRecord
  attr_accessor :terms

  include SentientStore 

  store :settings, accessors:[:language]
  has_many :persons, dependent: :destroy
  has_many :brokers, dependent: :destroy
  has_many :builds, dependent: :destroy

  accepts_nested_attributes_for :persons, allow_destroy: true  
  
  validates_acceptance_of :terms, accept: "1", message: "You must accept the terms of service", if: :validate_terms

  def validate_terms
    return true if self.terms.blank?
    self.term_at = DateTime.now
  end

end