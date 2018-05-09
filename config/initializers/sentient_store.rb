# module RestrictStore

#   def self.included(base)
#     base.send :extend, ClassMethods
#     base.class_eval do
#       before_action :restrict_store_filter

#       def restrict_store_filter
#         if current_store |= instance_variable_get("@#{self.class.store_restrict.to_s}").store
#           redirect_to public_dashboards_path, alert: "Store not allowed"
#         end
#       end
#     end
#   end

#   module ClassMethods

#     def restrict_store(method_name)
#       @object_store = method_name.to_s
#     end

#     def store_restrict
#       @object_store
#     end
#   end
# end


module SentientStoreController
  def self.included(base)
    base.class_eval do
      helper_method :current_store
    end
  end
  def current_store
    store = Store.all.detect{|s| s.url == request.subdomain.split('.').first}
    store ||= Store.last
  end
end

module SentientStore
  
  def self.included(base)
    base.class_eval do

      def self.current
        Thread.current[:store]
      end

      def self.current=(o)
        raise(ArgumentError,
            "Expected an object of class '#{self}', got #{o.inspect}") unless (o.is_a?(self) || o.nil?)
        Thread.current[:store] = o
      end
  
      def make_current
        Thread.current[:store] = self
      end

      def current?
        !Thread.current[:store].nil? && self.id == Thread.current[:store].id
      end
    end
  end
end