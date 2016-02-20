require "./analysis"
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

  let(:complexity) { "medium" }
  let(:budget) { "very_limited" }
  let(:analysis) { Analysis.new(complete_answer) }
  let(:output) { Analysis.new(complete_answer) }

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

  context "see complete output" do
    it { expect(output.output).to be_a Hash}
  end
end
