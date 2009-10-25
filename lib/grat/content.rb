class Content
  include MongoMapper::Document
  
  key :url, String
  key :tags, Array
  key :content, String
  timestamps!
  
  def editable_fields
    attributes.reject {|k,v| uneditable_keys.include? k }
  end
  
  def tags=(val)
    super(val.kind_of?(Array) ? val : val.split(' '))
  end
  
  def uneditable_keys
    # url is in here so it can maually be placed at the top of edit form.
    ["updated_at", "_id", "url", "created_at"]
  end
end