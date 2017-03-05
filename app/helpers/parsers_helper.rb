module ParsersHelper

  def resolve(response, text)
    response.split(text)
  end

  def informatic(data)

    required = ['value']
    filter = ['msg', 'map']

    if required.any? {|x| data.include?(x)} and !filter.any? {|y| data.include?(y)}
      true
    else
      false
    end
  end

  def find_by_key(data,key)
    target = ''
    data.split('/><').each do |block|
      if block.include?(key + ' ')
        target =  block.split('value=')[1].split("'")[1]
      else
        nil
      end
    end
    target
  end

  def filter_by_subdata(data, subdata)
    if data.include?(subdata)
      false
    else
      true
    end
  end
end