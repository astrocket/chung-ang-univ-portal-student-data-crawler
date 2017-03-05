module ParserHelper

  def resolve(response)
    response.force_encoding('UTF-8').split('/><')
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

  def key(data)
    data.split(' ')[0]
  end

  def value(data)
    data.split('value=')[1]
  end
end