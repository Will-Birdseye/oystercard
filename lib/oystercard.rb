class Oystercard

  MAXIMUM_BALANCE = 90
  MINIMUM_BALANCE = 1

  attr_reader :balance, :station_entry
  
  def initialize
    @balance = 0
    @station_entry = nil
  end

  def top_up(amount)
    fail 'Maximum balance of #{maximum_balance} exceeded' if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

    def touch_in(station)
    fail "Insufficient balance to touch in!" if balance < MINIMUM_BALANCE
    @in_journey = true
    @station_entry = station
  end

  def touch_out
    @in_journey = false
    deduct(MINIMUM_BALANCE)
    @station_entry = nil
  end

  def in_journey?
    @station_entry != nil
  end

  private

  def deduct(amount)
    @balance -= amount
  end
  
end