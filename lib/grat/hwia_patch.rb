class ActiveSupport::HashWithIndifferentAccess
  def to_json(*args, &block)
    to_hash.to_json(*args, &block)
  end
end
