class Action < ApplicationRecord
  belongs_to :potential_action
  belongs_to :organisation
  
  def getString()
    
    baseString = self.potential_action.format
    
    unless self.details.nil? 
      self.details.each do |key, val|
        baseString = baseString.sub('{{'+key+'}}', val)
      end
    end
    
    return baseString
  end
  
end
