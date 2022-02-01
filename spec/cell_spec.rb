require "spec_helper"

RSpec.describe Cell do
  describe ".column_index" do
    it "retruns index when column character is passed" do
      expect(Cell.column_index("A")).to be 1
    end
  end

  describe "#inspect" do
    subject { Cell.new(row: 1, column: 1).inspect }

    it { is_expected.to eq("-") }

    context "when row is 0 and column is 0" do
      subject { Cell.new(row: 0, column: 0).inspect }

      it { is_expected.to eq("  ") }
    end

    context "when column is 0" do
      let(:row) { rand(1..9) }

      subject { Cell.new(row: row, column: 0).inspect }

      it { is_expected.to eq(" " + row.to_s) }
    end

    context "when row is 0" do
      let(:column_index) { rand(1..10) }

      subject { Cell.new(row: 0, column: column_index).inspect }

      it { is_expected.to eq(Cell::COLUMNS[column_index]) }
    end

    context "when row is 10 and column is 0" do
      subject { Cell.new(row: 10, column: 0).inspect }

      it { is_expected.to eq("10") }
    end
  end
end
