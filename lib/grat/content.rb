module Grat::Content
  
  def editable_fields
    attributes.reject {|k,v| uneditable_keys.include? k }
  end
  
  def uneditable_keys
    # url is in here so it can maually be placed at the top of edit form.
    ["updated_at", "_id", "url", "created_at","content","tags",'template_url']
  end
  def tags=(val)
    super(val.kind_of?(Array) ? val : val.split(' '))
  end
  
  def type
    self.class.to_s.sub(/.+::/, '')
  end
  
  def template
    @template ||= Grat::Template.find_by_url(template_url) if template_url
  end
  
end