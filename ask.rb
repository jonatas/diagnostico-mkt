class Analysis
  def initialize answers
    @answer = answers
  end

  def output
    answer_budget
    answer_complexity
    answer_competition
#   answer_team
#    answer_strategy
  end

  def answer_budget
    case @answer["budget"]
    when "no" then
      {outsourcing: false}
    when /^(very_)?limited$/
      {}
    when "unlimited" then
      {outsourcing: true}
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
    subject { analysis.answer_budget }
    let(:budget) {"no"}
    it { is_expected.to eq(outsourcing: false) }
  end

  context "with money hire someone!" do
    subject { analysis.answer_budget }
    let(:budget) {"unlimited"}
    it { is_expected.to eq(outsourcing: true) }
  end

  context "complexity influences outsourcing" do
    subject { analysis.answer_complexity}
    let(:complexity) { "high" }
    it { is_expected.to eq(outsourcing: {tofu: false, mofu:false, guest:false}, redator: "internal") }
  end

  context "influences outsourcing" do
    subject { analysis.answer_competition}
    let(:complexity) { "high" }
    it { is_expected.to eq(outsourcing: {tofu: true, mofu:false, guest:true}) }
  end
end