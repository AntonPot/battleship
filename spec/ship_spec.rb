require "spec_helper"

RSpec.fdescribe Ship do
  subject { Ship.new(:destroyer) }

  it { is_expected.to respond_to :type, :hit_count, :initial, :size, :afloat?, :hit! }

  describe "#initial" do
    it "returns first character of it's type" do
      expect(subject.initial).to eq "D"
    end
  end

  describe "#size" do
    it "returns how many cells it covers" do
      expect(subject.size).to be 2
    end
  end

  describe "#afloat?" do
    it "checks if ship is still on the board" do
      expect(subject.afloat?).to be true
    end
  end

  describe "#hit!" do
    it "changes hit_count" do
      expect { subject.hit! }.to change(subject, :hit_count).by(1)
    end
  end
end
