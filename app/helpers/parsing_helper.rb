module ParsingHelper

  def resolve_xml(response, text)
    response.split(text)
  end

  #딱히 필요없음.
  def informatic(data)

    required = ['value']
    filter = ['msg', 'map']

    if required.any? {|x| data.include?(x)} and !filter.any? {|y| data.include?(y)}
      true
    else
      false
    end
  end

  #키값에 맞는 밸류를 뽑아내는 함수
  def find_by_key(data, key)
    target = nil
    data.split('/><').each do |block|
      if block.include?(key + ' ')
        target =  block.split('value=')[1].split("'")[1]
      else
        nil
      end
    end
    target
  end

  #해당 데이터가 포함된 문자열을 필터링하는 함수 나중에 통과/패스 필터링리스트를 배열로 넣어서 받아서 돌리도록 바꿔주면 더 좋음
  def filter_by_sub_string(data, subdata)
    if subdata.any? {|x| data.include?(x)}
      false
    else
      true
    end
  end

  def find_semester
    if (Time.now.month).between?(2, 7)
      '1'
    else
      '2'
    end
  end

end