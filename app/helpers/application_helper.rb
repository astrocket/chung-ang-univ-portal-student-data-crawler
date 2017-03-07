module ApplicationHelper

  #컴포넌트 관리용 호출 유알엘
  def component(type, name)
    return "components/#{type}/#{name}"
  end

  #성별 아이콘 분배
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
