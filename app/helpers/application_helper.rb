module ApplicationHelper
  def title(value)
    unless value.nil?
      @title = "#{value} | Pairworking"
    end
  end
end
