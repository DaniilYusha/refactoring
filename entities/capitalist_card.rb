class CapitalistCard < BaseCard
  def initialize(account)
    super

    @type = 'capitalist'
    @balance = 100.00
  end

  private

  def withdraw_percent
    4
  end

  def put_fixed
    10
  end

  def sender_percent
    10
  end
end
