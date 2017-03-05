module ParserHelper

  def resolve(response, text)
    response.force_encoding('UTF-8').split(text)
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
    data.split('/><').each do |block|
      if block.include?(key)
        return block.split('value=')[1]
      else
        nil
      end
    end
  end

  def key(data)
    data.split(' ')[0]
  end

  def value(data)
    data.split('value=')[1]
  end

  def filter_by_subdata(data, subdata)
    if data.include?(subdata)
      false
    else
      true
    end
  end
end