module ApplicationHelper
  def component(type, name)
    return "components/#{type}/#{name}"
  end

  def sex_icon(gender_type)
    case gender_type
      when ('M' or 'Male' or 'Man' or 'Boy' or 'Guy')
        'fa-male' # 남성
      when ('F' or 'Female' or 'Woman' or 'Girl' or 'Lady')
        'fa-female' # 여성
      else
        'fa-book'
    end
  end
end
