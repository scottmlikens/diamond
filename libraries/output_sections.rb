module Chef::Recipe::Diamond
  def output_sections(config, depth=0)
    config = config.to_hash  # enables .reject
    lines = []
    mydata = config.reject {|k,v| v.respond_to?('each_pair')}
    mydata.each_pair do |k,v|
      lines << k.to_s + ' = ' + v.to_s
    end
    lines << ''
    depth = depth + 1
    subsections = config.reject {|k,v| not v.respond_to?('each_pair')}
    subsections.each_pair do |k,v|
      lines << ('[' * depth) + k.to_s + (']' * depth)
      lines = lines.concat(output_sections(v, depth))
    end
    return lines
  end
end

