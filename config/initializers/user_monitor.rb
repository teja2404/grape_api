ActiveRecord::Base.class_eval do
  before_save do |object|
    object.new_record? ? create_with_user : update_with_user
  end

  def current_user
    Current.user
  end

  def create_with_user
    user = current_user
    if !user.nil?
      self[:created_by] = user.id if self.has_attribute?(:created_by)
    end
  end

  def update_with_user
    user = current_user
    self[:updated_by] = user.id if !user.nil? && self.has_attribute?(:updated_by)
  end

  # def created_by
  #   begin
  #     User.find(self[:created_by]) if current_user
  #   rescue ActiveRecord::RecordNotFound
  #     nil
  #   end
  # end
  #
  # def updated_by
  #   begin
  #     User.find(self[:updated_by]) if current_user
  #   rescue ActiveRecord::RecordNotFound
  #     nil
  #   end
  # end
end
module ActiveRecord
  module AttributeMethods
    module ClassMethods
      def instance_method_already_implemented?(method_name)
        return true if method_name == 'created_by' or method_name == 'updated_by'
        super
      end
    end
  end
end