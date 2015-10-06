module MailForm

  class Base
    include ActiveModel::AttributeMethods # 1) attribute methods behavior
    include ActiveModel::Conversion 
    include ActiveModel::Validations 
    extend  ActiveModel::Naming 
    extend  ActiveModel::Translation 

    attribute_method_prefix 'clear_'      # 2) clear_ is attribute prefix
    attribute_method_suffix '?'
    class_attribute :attribute_names
    self.attribute_names = []

    def self.attributes *names
      attr_accessor(*names)
      define_attribute_methods names
      self.attribute_names += names
    end

    def persisted?
      false
    end

    def deliver
      if valid?
        MailForm::Notifier.contact(self).deliver
      else
        false
      end
    end

    protected
      # 4) Since we declared a "clear_" prefix, it expects to have a
      # "clear_attribute" method defined, which receives an attribute
      # name and implements the clearing logic.
      def clear_attribute attribute
        send "#{attribute}=", nil
      end

      def attribute? attribute
        send(attribute).present?
      end
  end

end