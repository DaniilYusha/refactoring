class CapitalistCard < BaseCard
  def initialize(account)
    super

    @type = 'capitalist'
    @balance = 100.00
  end

  def withdraw_tax(amount)
    tax(amount, withdraw_percent, withdraw_fixed)
  end

  def put_tax(amount)
    tax(amount, put_percent, put_fixed)
  end

  def sender_tax(amount)
    tax(amount, sender_percent, sender_fixed)
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
