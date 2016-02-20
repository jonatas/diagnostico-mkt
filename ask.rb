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
       output[:outsourcing].each do |key, value|
         if h[key].nil? || value == false
           h[key] = value
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
end

describe Analysis do

  let(:complete_answer) { 
    {
      "budget"=> budget,
      "complexity"=> complexity,
      "competition"=>"medium",
      "team"=>["redator", "low_availability"],
      "strategy"=>"partially_inbound_dependent"
    }
  }

  #let(:analysis) { Analysis.new complete_answer}


  let(:complexity) { "medium" }
  let(:budget) { "very_limited" }
  let(:analysis) { Analysis.new(complete_answer) }

  context "no money no outsourcing" do
    subject { analysis.answer_budget[:outsourcing].values }
    let(:budget) {"no"}
    it { is_expected.to eq([false,false,false]) }
  end

  context "with money you can conquer the world!" do
    subject { analysis.answer_budget[:outsourcing].values }
    let(:budget) {"unlimited"}
    it { is_expected.to eq([true,true,true]) }
  end

  context "complexity influences outsourcing" do
    subject { analysis.answer_complexity}
    let(:complexity) { "high" }
    it { is_expected.to eq(outsourcing: {tofu: false, mofu:false, guest:false}, redator: "internal") }
  end

  context "influences outsourcing" do
    subject { analysis.answer_competition}
    let(:competition) { "high" }
    it { is_expected.to eq(outsourcing: {tofu: true, mofu:false, guest:true}) }
  end
end