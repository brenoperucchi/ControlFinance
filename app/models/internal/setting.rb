class Internal::Setting
  extend ActiveModel::Naming
  extend ActiveModel::Translation
  include ActiveModel::Conversion
  include ActiveModel::Validations
  include ActiveModel::AttributeMethods

  # attr_accessor :id, :name

  ATTRIBUTES = {name: nil}

  def initialize(args={})
    attributes = ATTRIBUTES.merge(args)
    attributes.each do |attr, value|
      instance_variable_set("@#{attr}", value)
      self.class.send(:define_method, attr) { instance_variable_get("@#{attr}") }    
      # self.class.send(:define_method, "#{attr}=") { instance_variable_set("@#{attr}", value) }    
      self.class_eval do
        define_method "#{attr}=" do |value|
          instance_variable_set("@#{attr}", value) 
        end
      end
    end
  end

  def method_missing(attr, value = nil, &block)  
    self.class_eval do
      attr_accessor attr
      # define_method "#{attr}=" do |value|
      #   instance_variable_set("@#{attr}", value) 
      # end
      # define_method "#{attr}" do
      #   instance_variable_get("@#{attr}") 
      # end
    end
  end

  class_attribute :_attributes
  self._attributes = []


  def persisted?
    false
  end

  def attributes=(attrs)
    return nil if attrs.nil?
    attrs.each do |attr, value|
      send("#{attr}=", value)
    end
  end

end