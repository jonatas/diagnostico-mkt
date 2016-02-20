class Analysis
  def initialize answers
    @answer = answers
    p @answer
  end

  def output
    answer_budget
      .merge answer_complexity
      .merge answer_competition
#    answer_team
#    answer_strategy
  end

  def answer_budget
    case @answer["budget"]
    when "no" then
      {parties: false}
    when /^(very_)?limited$/
      {}
    when "unlimited" then
      {parties: true}
    else
      {not_answer_budget: true}
    end
  end

  def answer_complexity
    case @answer["complexity"]
    when "high" then
      {}
    when "medium" then
      {}
    when "low" then
      {}
    else
      {not_answer_complexity: true}
    end
  end

  def answer_competition
    case @answer["competition"]
    when "high" then
      {}
    when "medium" then
      {}
    when "low" then
      {}
    else
      {not_answer_competition: true}
    end
  end
end

describe Analysis do

  let(:complete_answer) { 
    {
      "budget"=> budget,
      "complexity"=>"medium",
      "competition"=>"medium",
      "team"=>["redator", "low_availability"],
      "strategy"=>"partially_inbound_dependent"
    }
  }

  #let(:analysis) { Analysis.new complete_answer}

  subject { Analysis.new(complete_answer).answer_budget }

  context "no money no parties" do
    let(:budget) {"no"}
    it { is_expected.to eq(parties: false) }
  end

  context "with money hire someone!" do
    let(:budget) {"unlimited"}
    it { is_expected.to eq(parties: true) }
  end
end