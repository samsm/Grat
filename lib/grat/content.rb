module Grat::Content
  
  def editable_fields
    attributes.reject {|k,v| uneditable_keys.include? k }
  end
  
  def uneditable_keys
    # url is in here so it can maually be placed at the top of edit form.
    ["updated_at", "_id", "url", "created_at","content","tags"]
  end
  def tags=(val)
    super(val.kind_of?(Array) ? val : val.split(' '))
  end
  
  def type
    self.class.to_s.sub(/.+::/, '')
  end
end