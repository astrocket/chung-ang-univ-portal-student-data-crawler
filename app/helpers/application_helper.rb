module ApplicationHelper
  def component(type, name)
    return "components/#{type}/#{name}"
  end
end
