require "spec_helper"

RSpec.describe Cell do
  subject { Cell.new(row: 1, column: 1, value: "X") }

  it { is_expected.to respond_to :row, :column, :value }

  describe "#inspect" do
    it "returns cell value" do
      expect(subject.inspect).to eq "X"
    end
  end
end
