class Analysis
  def initialize answers
    @answer = answers
  end

  def output
    merge_outsourcing
      .merge answer_team
      .merge answer_strategy
  end

  def merge_outsourcing
    [answer_budget,
     answer_complexity,
     answer_competition].inject({}) do |h,output|
       h[:outsourcing] ||= {}
       output[:outsourcing].each do |key, value|
         if h[:outsourcing][key].nil? || value == false
           h[:outsourcing][key] = value
         end
       end
       output.each do |key, value|
         next if key == :outsourcing
         h[key] = value
       end
       h
     end
  end

  def answer_budget
    case @answer["budget"]
    when "no" then
      {outsourcing: {tofu: false, mofu: false, guest: false}}
    when "very_limited" then
      {outsourcing: {tofu: true, mofu: false, guest: false}}
    when "limited" then
      {outsourcing: {tofu: true, mofu: true, guest: false}}
    when "unlimited" then
      {outsourcing: {tofu: true, mofu: true, guest: true}}
    else
      {not_answer_budget: true}
    end
  end

  def answer_complexity
    case @answer["complexity"]
    when "high" then
      {outsourcing: {tofu: false, mofu: false, guest: false}, redator: 'internal'}
    when "medium" then
      {outsourcing: {tofu: true, mofu: false, guest: true}, redator: 'internal'}
    when "low" then
      {outsourcing: {tofu: true, mofu: true, guest: true}, redator: 'external'}
    else
      {not_answer_complexity: true}
    end
  end

  def answer_competition
    case @answer["competition"]
    when "high" then
      {outsourcing: {tofu: false, mofu: false, guest: false}}
    when "medium" then
      {outsourcing: {tofu: true, mofu: false, guest: true}}
    when "low" then
      {outsourcing: {tofu: true, mofu: true, guest: true}}
    else
      {not_answer_competition: true}
    end
  end

  def answer_team
    h = {}
    if !@answer["team"].empty?
      if @answer["team"].include? "editor"
        h[:editor_in_house] = !@answer["budget"].match?(/^(very_)?limited$/)
      end
      if @answer["team"].include? "high_availability"
        h[:distribuition] = "fluid"
      elsif @answer["team"].include? "low_availability"
        h[:distribuition] = "forced"
      elsif @answer["team"].include? "none"
        if @answer_budget["budget"] =~ /^(un)?limited$/
          h[:outsourcing] = {tofu: true, mofu: false, guest: true}
        end
      end
    else
      h[:not_answer_team] = true
    end
    h
  end

  def answer_strategy
    case @answer["strategy"]
    when "total_inbound_dependent" then
      {outsourcing: {tofu: false, mofu: false, guest: false}}
    when "partially_inbound_dependent" then
      {outsourcing: {tofu: true, mofu: false, guest: false}}
    when "no_inbound_dependent" then
      {outsourcing: {tofu: true, mofu: true, guest: true}}
    end
  end
end