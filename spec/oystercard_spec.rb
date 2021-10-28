require 'oystercard'

describe Oystercard do
  let(:entry_station) { double :entry_station }
  let(:exit_station) { double :exit_station }

  it 'has a balance of zero' do
    expect(subject.balance).to eq(0)
  end

  describe '#top_up' do

    it 'can top up the balance' do
      expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
    end
    
    it 'raises an error if the maximum balance is exceeded' do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up 1 }.to raise_error 'Maximum balance of #{maximum_balance} exceeded'
    end
  end

  # it 'deducts an amount from the balance' do
  #   subject.top_up(20)
  #   expect{ subject.deduct 3}.to change{ subject.balance }.by -3
  # end

  it 'is initially not in a journey' do
    expect(subject).to respond_to(:in_journey?)
  end

  it "can touch in" do
    subject.top_up(1)
    subject.touch_in(entry_station)
    expect(subject.in_journey?).to be true
  end

  it "can touch out" do
    subject.top_up(1)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.in_journey?).to be false
  end

  it "raises touch_in error if balance is less than 1" do
    expect{ subject.touch_in(entry_station) }.to raise_error "Insufficient balance to touch in!"
  end

  it "reduces balance by 1 when touch_out is called" do
    expect { subject.touch_out(exit_station) }.to change{ subject.balance }.by -1
  end

  it "stores the entry station when touch_in" do
    subject.top_up(1)
    subject.touch_in(entry_station)
    expect(subject.entry_station).to eq entry_station
  end

  it "store the exit station upon touch_out" do
    subject.top_up(1)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.exit_station).to eq exit_station
  end

  it "stores a journey" do
    subject.top_up(1)
    subject.touch_in(entry_station)
    subject.touch_out(exit_station)
    expect(subject.journeys.count).to eq 1
  end
end
